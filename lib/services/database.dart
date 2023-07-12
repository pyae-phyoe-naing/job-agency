import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../global.dart';

class FirebaseHelper {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  final Reference storageRef = FirebaseStorage.instance.ref();

  // upload file
  Future<void> uploadFile({required User user}) async {
    final XFile? xFile =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (xFile == null) return;
    // print("XFile $xFile");
    // print("Mime Type ${xFile.mimeType}");
    final Reference ref = storageRef.child('user/${user.uid}');
    try {
      UploadTask uploadTask = ref.putFile(
          File(xFile.path), SettableMetadata(contentType: xFile.mimeType));
      uploadTask.whenComplete(() async {
        final String profileLink = await ref.getDownloadURL();
        await user.updatePhotoURL(profileLink);
        // print('Upload done ${await ref.getDownloadURL()}');
      });
    } catch (e) {
      print('Upload error $e');
    }
  }

  Future<void> uploadJobFile(
      {required XFile xFile,
      required Future Function(String) firestore}) async {
    Reference ref =
        storageRef.child("job/${DateTime.now().toString()}${Random().nextInt(1000)}");
    try {
      UploadTask uploadTask = ref.putFile(
          File(xFile.path), SettableMetadata(contentType: xFile.mimeType));
      uploadTask.whenComplete(() async {
        final String imgLink = await ref.getDownloadURL();
        firestore(imgLink);
      });
    } catch (e) {
      print('Upload error $e');
    }
  }

  Future<void> create(
          {required String collectionPath,
          required Map<String, dynamic> data,
          String? docPath}) =>
      _firestore.collection(collectionPath).doc(docPath).set(data);

  Future<void> update(
          {required String collectionPath,
          required String docPath,
          required Map<String, dynamic> data}) =>
      _firestore.collection(collectionPath).doc(docPath).update(data);

  Future<void> delete(
          {required String collectionPath, required String docPath}) =>
      _firestore.collection(collectionPath).doc(docPath).delete();

  Stream<QuerySnapshot<Map<String, dynamic>>> watchAll(
          {required String collectionPath}) =>
      _firestore.collection(collectionPath).snapshots();

  Stream<DocumentSnapshot<Map<String, dynamic>>> watch(
          {required String collectionPath, required String docPath}) =>
      _firestore.collection(collectionPath).doc(docPath).snapshots();

  Future<QuerySnapshot<Map<String, dynamic>>> readAll(
          {required String collectionPath}) =>
      _firestore.collection(collectionPath).get();

  Future<DocumentSnapshot<Map<String, dynamic>>> read(
          {required String collectionPath, required String docPath}) =>
      _firestore.collection(collectionPath).doc(docPath).get();
}
