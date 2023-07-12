import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_agency/global.dart';
import 'package:job_agency/model/pro_model.dart';

class WatchProExpCubit extends Cubit<List<ProModelList>> {
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? subscription;
  WatchProExpCubit() : super([]);
  void listen(QuerySnapshot<Map<String, dynamic>> event) {
    List<ProModelList> models = event.docs
        .map((doc) => ProModelList.fromJsonWithId(doc.id, doc.data()))
        .toList();

    emit(models);
  }

  void init() {
    subscription =
        firebaseHelper.watchAll(collectionPath: 'pro-exp').listen(listen);
  }

  Future<void> clear() async {
    await subscription?.cancel();
    subscription = null;
    emit([]);
  }
}
