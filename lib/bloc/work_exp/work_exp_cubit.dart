import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_agency/global.dart';
import 'package:job_agency/model/work_model.dart';

class WorkExpCubit extends Cubit<dynamic> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController subTitleController = TextEditingController();
  DateTime? createdAt;
  WorkExpCubit([WorkModel? workModel]) : super(null) {
    createdAt = workModel?.createdAt;
    titleController.text = workModel?.title ?? '';
    subTitleController.text = workModel?.subTitle ?? '';
  }
  void dispose() {
    titleController.dispose();
    subTitleController.dispose();
  }

  Future<void> create(String uId) async {
    final WorkModel workModel = WorkModel(
        title: titleController.text, subTitle: subTitleController.text);
    // Empty List => collection of WorkModel
    List<WorkModel> workModelList = [];

    // Get Old Data From Firebase
    DocumentSnapshot<Map<String, dynamic>> dataFromDb =
        await firebaseHelper.read(collectionPath: 'work-exp', docPath: uId);

    // Check
    if (dataFromDb.data() != null) {
      // Existting data
      workModelList.addAll(
          WorkModelList.fromJson(dataFromDb.data()).workModelList.toList());
    }
    // Not Exist data in DB
    workModelList.add(workModel);
    await firebaseHelper.create(
        collectionPath: 'work-exp',
        data: WorkModelList(workModelList: workModelList).toJson(),
        docPath: uId);
  }

  // ---------- Delete ------------ //
  Future<void> delete(String uId) async {
    DocumentSnapshot<Map<String, dynamic>> dataFromDb =
        await firebaseHelper.read(collectionPath: 'work-exp', docPath: uId);
    List<WorkModel> workModelList =
        WorkModelList.fromJson(dataFromDb.data()).workModelList.toList();

    workModelList.removeWhere((workModel) => workModel.createdAt == createdAt);

    await firebaseHelper.update(
        collectionPath: 'work-exp',
        docPath: uId,
        data: WorkModelList(workModelList: workModelList).toJson());
  }

// ------------ Update ---------//
  Future<void> update(String uId) async {
    DocumentSnapshot<Map<String, dynamic>> dataFromDb =
        await firebaseHelper.read(collectionPath: 'work-exp', docPath: uId);

    List<WorkModel> workModelList =
        WorkModelList.fromJson(dataFromDb.data()).workModelList.toList();

    workModelList[workModelList
            .indexWhere((workModel) => workModel.createdAt == createdAt)] =
        WorkModel(
            title: titleController.text,
            subTitle: subTitleController.text,
            createdAt: createdAt);

    await firebaseHelper.update(
        collectionPath: 'work-exp', docPath: uId, data: 
       WorkModelList(workModelList: workModelList).toJson());
  }
}
