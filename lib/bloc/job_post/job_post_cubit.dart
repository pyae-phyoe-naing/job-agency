import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_agency/global.dart';
import 'package:job_agency/model/job_post_model.dart';

class JobPostState {
  final List<JobPostModel> jobPostModelList;
  final bool sortByDate;
  final bool sortByName;
  final double amount;

  JobPostState(
      {required this.jobPostModelList,
      required this.sortByDate,
      required this.sortByName,
      required this.amount});
}

class JobPostCubit extends Cubit<JobPostState> {
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? subscription;
  JobPostCubit()
      : super(JobPostState(
            jobPostModelList: [],
            sortByDate: false,
            sortByName: false,
            amount: 0));
  

  // emitter
  void emitter({bool? sortByDate, bool? sortByName, double? amount}) =>
      emit(JobPostState(
          jobPostModelList: state.jobPostModelList,
          sortByDate: sortByDate ?? state.sortByDate,
          sortByName: sortByName ?? state.sortByName,
          amount: amount ?? 0));

  // Listen
  void init() {
    subscription =
        firebaseHelper.watchAll(collectionPath: 'job-post').listen(listen);
  }

  void listen(QuerySnapshot<Map<String, dynamic>> event) {
    final List<JobPostModel> jobPostList =
        event.docs.map((e) => JobPostModel.fromJson(e.id, e.data())).toList();
    emit(JobPostState(
        jobPostModelList: jobPostList,
        sortByDate: state.sortByDate,
        sortByName: state.sortByName,
        amount: state.amount));
  }

  // Cancel
  Future<void> clear() async {
    await subscription?.cancel();
    subscription = null;
    emit(JobPostState(
        jobPostModelList: [], sortByDate: false, sortByName: false, amount: 0));
  }
}
