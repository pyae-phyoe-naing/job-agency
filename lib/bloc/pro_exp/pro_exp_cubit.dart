import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_agency/global.dart';
import 'package:job_agency/model/pro_model.dart';

class ProExpCubit extends Cubit<double> {
  final TextEditingController controller = TextEditingController();
  DateTime? createdAt;
  ProExpCubit([ProModel? proModel]) : super(proModel?.level ?? 0) {
    controller.text = proModel?.name ?? '';
    createdAt = proModel?.createdAt;
  }

  void onSlide(double slideValue) {
    emit(slideValue);
  }

  void dispose() {
    controller.dispose();
  }

  Future<void> create(String uId) async {
    final ProModel proModel = ProModel(name: controller.text, level: state);

    // Empty proModelList
    final List<ProModel> proModelList = [];

    // Read user old Data
    DocumentSnapshot<Map<String, dynamic>> data =
        await firebaseHelper.read(collectionPath: 'pro-exp', docPath: uId);

    // Check exist old Data and if exist more add new ProModal
    if (data.data() != null) {
      //   print('Old data [ ]  ${data.data()}');
      proModelList.addAll(ProModelList.fromJson(data.data())
          .proModelList
          .toList()); // copy instance
    }
    // if not exist Add New Promodal
    proModelList.add(proModel);

    // Create
    await firebaseHelper.create(
        collectionPath: 'pro-exp',
        data: ProModelList(proModelList).toJson(),
        docPath: uId);
  }

  Future<void> update(String uId) async {
    // Read user exist Data List
    DocumentSnapshot<Map<String, dynamic>> data =
        await firebaseHelper.read(collectionPath: 'pro-exp', docPath: uId);

    final List<ProModel> proModelList =
        ProModelList.fromJson(data.data()).proModelList.toList();

    // Update proModelList data
    proModelList[proModelList
            .indexWhere((proModel) => proModel.createdAt == createdAt)] =
        ProModel(name: controller.text, level: state, createdAt: createdAt);
    // Create
    await firebaseHelper.update(
        collectionPath: 'pro-exp',
        data: ProModelList(proModelList).toJson(),
        docPath: uId);
  }

  // Delete
  Future<void> delete(String uId, DateTime deleteId) async {
    // Read user exist Data List
    DocumentSnapshot<Map<String, dynamic>> data =
        await firebaseHelper.read(collectionPath: 'pro-exp', docPath: uId);

    final List<ProModel> proModelList =
        ProModelList.fromJson(data.data()).proModelList.toList();

    // Update proModelList data
    proModelList.removeWhere((proModel) => proModel.createdAt == deleteId);

    // OR
    // proModelList.remove(proModelList[
    //     proModelList.indexWhere((proModel) => proModel.createdAt == deleteId)]);

    // Delete

    await firebaseHelper.update(
        collectionPath: 'pro-exp',
        data: ProModelList(proModelList).toJson(),
        docPath: uId);
  }
}
