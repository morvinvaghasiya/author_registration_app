import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

class CloudFirestoreHelper {
  CloudFirestoreHelper._();

  static final CloudFirestoreHelper cloudFirestoreHelper =
      CloudFirestoreHelper._();

  static final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  late CollectionReference authorsRef;
  late CollectionReference countersRef;

  //connection with collection

  connectWithAuthorsCollection() {
    authorsRef = firebaseFirestore.collection('authors');
  }

  connectWithCountersCollection() {
    countersRef = firebaseFirestore.collection('counters');
  }

  //insert record
  Future<void> insertRecord({
    required String author_name,
    required String book_name,
  }) async {
    connectWithAuthorsCollection();
    connectWithCountersCollection();

    //fetch counter value from notes_counter collection
    DocumentSnapshot documentSnapshot =
        await countersRef.doc('authors_counter').get();

    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;

    int counter = data['counter'];

    //insert a new document with that fetched counter value

    await authorsRef.doc("${++counter}").set({
      'author': author_name,
      'book': book_name,
    });

    print("**************************************");
    log(counter);
    //update the counter value in db

    countersRef.doc('authors_counter').set({'counter': counter});

    //second method---------------------

    //first method-----------------

    // Map<String, dynamic> data = {
    //   'name': 'Ram',
    //   'age': '18',
    //   'city': 'Ayodhya',
    // };

    // await studentsRef.add(data);
  }

  //select record
  Stream<QuerySnapshot> selectRecords() {
    connectWithAuthorsCollection();

    return authorsRef.snapshots();
  }
  //update record

  Future<void> updateRecord({
    required String id,
    required String author_name,
    required String book_name,
  }) async {
    connectWithAuthorsCollection();

    await authorsRef.doc(id).update({
      'author': author_name,
      'book': book_name,
    });
  }

  //delete record
  Future<void> deleteRecord({required String id}) async {
    connectWithAuthorsCollection();
    connectWithCountersCollection();

    await authorsRef.doc(id).delete();
  }
}
