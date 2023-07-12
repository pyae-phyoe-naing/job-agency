import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_agency/global.dart';
import 'package:job_agency/model/request_job_model.dart';

class JobRequestCubit extends Cubit<List<RequestJobModel>> {
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? subscription;
  JobRequestCubit() : super([]);
  
  listen(QuerySnapshot<Map<String, dynamic>> event) {
    List<RequestJobModel> requestJob = event.docs
        .map((doc) => RequestJobModel.fromJson(doc.id, doc.data()))
        .toList();
    emit(requestJob);
  }

  init() {
    subscription =
        firebaseHelper.watchAll(collectionPath: 'request-job').listen(listen);
  }

  Future<void> clear() async {
    await subscription?.cancel();
    subscription = null;
    emit([]);
  }
}
