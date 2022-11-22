import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

import '../helpers/cloud_firestore_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<FormState> insertFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> updateFormKey = GlobalKey<FormState>();

  final TextEditingController authorController = TextEditingController();
  final TextEditingController bookController = TextEditingController();

  String? author;
  String? book;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: const Text("Author Registration"),
        centerTitle: true,
      ),
      backgroundColor: Colors.indigo.withOpacity(0.3),
      body: StreamBuilder(
        stream: CloudFirestoreHelper.cloudFirestoreHelper.selectRecords(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          } else if (snapshot.hasData) {
            QuerySnapshot? data = snapshot.data;

            List<QueryDocumentSnapshot> documents = data!.docs;

            return (documents.isEmpty)
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Spacer(),
                        Icon(
                          Icons.library_books_outlined,
                          size: 70,
                          color: Colors.blueAccent,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          " Authors you add appear here ! ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                  )
                : Container(
                    margin: const EdgeInsets.all(10),
                    child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: documents.length,
                        itemBuilder: (context, i) {
                          return Card(
                            color: Colors.indigo.shade50,
                            shadowColor: Colors.black,
                            surfaceTintColor: Colors.teal,
                            elevation: 10,
                            child: ListTile(
                              isThreeLine: true,
                              title: Row(
                                children: [
                                  Text(
                                    "Author : ",
                                    style: GoogleFonts.brawler(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    "${documents[i]['author']} ",
                                    style: GoogleFonts.aBeeZee(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, top: 5),
                                child: Row(
                                  children: [
                                    Text(
                                      "Book Name: \n",
                                      style: GoogleFonts.asul(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      "${documents[i]['book']} \n ",
                                      style: GoogleFonts.actor(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      validateAndUpdate(
                                          updata: documents[i].id);
                                      authorController.text =
                                          documents[i]['author'];

                                      bookController.text =
                                          documents[i]['book'];
                                    },
                                    icon: const Icon(
                                      Icons.mode_edit_outlined,
                                      color: Colors.teal,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      CloudFirestoreHelper.cloudFirestoreHelper
                                          .deleteRecord(id: documents[i].id);
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  );
          }
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.teal,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          validateAndInsert();
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.indigo,
      ),
    );
  }

  //for insert record
  void validateAndInsert() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 10,
            title: const Center(child: Text("Register Author")),
            content: Form(
              key: insertFormKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: authorController,
                        validator: (val) {
                          return (val!.isEmpty)
                              ? "Enter Author Name first"
                              : null;
                        },
                        onSaved: (val) {
                          setState(() {
                            author = val;
                          });
                        },
                        decoration: InputDecoration(
                            label: const Text("Author's Name"),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: bookController,
                        validator: (val) {
                          return (val!.isEmpty)
                              ? "Enter Book Name first"
                              : null;
                        },
                        onSaved: (val) {
                          setState(() {
                            book = val;
                          });
                        },
                        decoration: InputDecoration(
                            label: const Text("Book's Name"),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  if (insertFormKey.currentState!.validate()) {
                    insertFormKey.currentState!.save();

                    await CloudFirestoreHelper.cloudFirestoreHelper
                        .insertRecord(
                      author_name: author!,
                      book_name: book!,
                    )
                        .then((value) {
                      return ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.green,
                          behavior: SnackBarBehavior.floating,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          content: Text("Author Registered successfully..."),
                        ),
                      );
                    }).catchError(
                      (error) {
                        return ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Error: $error"),
                          ),
                        );
                      },
                    );
                  }

                  authorController.clear();
                  bookController.clear();

                  setState(() {
                    author = null;
                    book = null;
                  });

                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(primary: Colors.teal),
                child: const Text("ADD"),
              ),
              ElevatedButton(
                onPressed: () async {
                  authorController.clear();
                  bookController.clear();
                  setState(() {
                    author = null;
                    book = null;
                  });
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(primary: Colors.teal),
                child: const Text("Cancel"),
              )
            ],
          );
        });
  }

  //for update record
  void validateAndUpdate({required updata}) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            clipBehavior: Clip.none,
            title: const Center(child: Text("Edit Author")),
            content: Form(
              key: updateFormKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: authorController,
                        validator: (val) {
                          return (val!.isEmpty)
                              ? "Enter Author Name first"
                              : null;
                        },
                        onSaved: (val) {
                          setState(() {
                            author = val;
                          });
                        },
                        decoration: InputDecoration(
                            label: const Text("Author's Name"),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: bookController,
                        validator: (val) {
                          return (val!.isEmpty)
                              ? "Enter Book Name first"
                              : null;
                        },
                        onSaved: (val) {
                          setState(() {
                            book = val;
                          });
                        },
                        decoration: InputDecoration(
                            label: const Text("Book's Name"),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  if (updateFormKey.currentState!.validate()) {
                    updateFormKey.currentState!.save();

                    await CloudFirestoreHelper.cloudFirestoreHelper
                        .updateRecord(
                      id: updata,
                      author_name: author!,
                      book_name: book!,
                    )
                        .then((value) {
                      return ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.green,
                          behavior: SnackBarBehavior.floating,
                          content: Text("Author Edited successfully..."),
                        ),
                      );
                    }).catchError(
                      (error) {
                        return ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text("Author edition filed...Error: $error"),
                          ),
                        );
                      },
                    );
                  }

                  authorController.clear();
                  bookController.clear();
                  setState(() {
                    author = "";
                    book = "";
                  });
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(primary: Colors.teal),
                child: const Text("Edit"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.teal),
                onPressed: () async {
                  authorController.clear();
                  bookController.clear();
                  setState(() {
                    author = null;
                    book = null;
                  });
                  Navigator.of(context).pop();
                },
                child: const Text("Cancel"),
              )
            ],
          );
        });
  }
}
