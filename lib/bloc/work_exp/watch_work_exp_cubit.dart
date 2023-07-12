import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_agency/global.dart';
import 'package:job_agency/model/work_model.dart';

class WatchWorkExpCubit extends Cubit<List<WorkModelList>> {
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? subscription;
  WatchWorkExpCubit() : super([]);
  void init() {
    subscription =
        firebaseHelper.watchAll(collectionPath: 'work-exp').listen((event) {
      List<WorkModelList> workModelList = event.docs
          .map((doc) => WorkModelList.fromJsonWithId(doc.id, doc.data()))
          .toList();
      emit(workModelList);
    });
  }

  Future<void> clear() async {
    await subscription?.cancel();
    subscription = null;
    emit([]);
  }
}
