import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_agency/global.dart';
import 'package:job_agency/model/worker_model.dart';

class WorkerState {
  final List<WorkerModel> workerList;
  final bool sortByName;
  final String selectCity;
  final double amount;
  WorkerState(
      {required this.workerList,
      required this.selectCity,
      required this.sortByName,
      required this.amount});
}

class WorkerCubit extends Cubit<WorkerState> {
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? subscription;
  WorkerCubit()
      : super(WorkerState(
            workerList: [], selectCity: "", sortByName: false, amount: 0));

  void listen(QuerySnapshot<Map<String, dynamic>> event) {
    List<WorkerModel> workerModelList =
        event.docs.map((e) => WorkerModel.fromJson(e.id, e.data())).toList();

    emit(WorkerState(
        workerList: workerModelList,
        selectCity: state.selectCity,
        sortByName: state.sortByName,
        amount: state.amount));
  }

  void emitter({String? selectCity, bool? sortByName, double? amount}) =>
      emit(WorkerState(
          workerList: state.workerList,
          selectCity: selectCity ?? state.selectCity,
          sortByName: sortByName ?? state.sortByName,
          amount: amount ?? 0));
  void init() {
    subscription =
        firebaseHelper.watchAll(collectionPath: 'users').listen(listen);
  }

  Future<void> clear() async {
    await subscription?.cancel();
    subscription = null;
    emit(WorkerState(
        workerList: [], selectCity: "", sortByName: false, amount: 0));
  }
}
