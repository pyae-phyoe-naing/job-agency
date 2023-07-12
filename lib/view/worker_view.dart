import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_agency/bloc/auth/auth_bloc.dart';
import 'package:job_agency/bloc/worker/worker_cubit.dart';
import 'package:job_agency/global.dart';
import 'package:job_agency/model/worker_model.dart';
import 'package:job_agency/widget/worker_components/worker_card.dart';
import 'package:job_agency/widget/worker_components/worker_filter.dart';
import 'package:job_agency/widget/worker_components/worker_search_button.dart';

import '../utils/string.dart';
import '../utils/theme.dart';

class WorkerView extends StatelessWidget {
  const WorkerView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthBloc authBloc = context.read();
    return Scaffold(
      backgroundColor: ThemeUtils.scaffoldBg,
      appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: ThemeUtils.scaffoldBg,
          foregroundColor: Colors.black,
          title: const Text(StringUtils.appName),
          actions: [
            IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (_) => BlocProvider.value(
                          value: workerCubit,
                          child: const WorkerFilter(),
                        ));
              },
              splashRadius: 20,
              icon: const Icon(
                Icons.filter_alt_rounded,
                color: ThemeUtils.buttonColor,
              ),
            ),
         const WorkerSearchButton()
          ]),
      body: BlocBuilder<WorkerCubit, WorkerState>(
        builder: (context, state) {
          if (state.workerList.isNotEmpty) {
            state.workerList.removeWhere((user) =>
                user.role == "admin" ||
                user.docId == authBloc.state.userModel?.user!.uid);
          }
          List<WorkerModel> filterWorker = state.workerList.toList();
          if (state.amount > 0) {
            filterWorker = state.workerList
                .toList()
                .where((worker) => worker.price == state.amount)
                .toList();
          }
          if (state.selectCity.isNotEmpty) {
            filterWorker = filterWorker
                .where((worker) =>
                    worker.city.toString().replaceAll(' ', '').toLowerCase() ==
                    state.selectCity)
                .toList();
          }
          if (state.sortByName) {
            filterWorker.sort((a, b) => (a.displayName ?? StringUtils.appName)
                .compareTo(b.displayName ?? StringUtils.appName));
          }
          return ListView.builder(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              itemCount: filterWorker.length,
              itemBuilder: ((context, index) =>
                  WorkerCard(workerModel: filterWorker[index])));
        },
      ),
      // StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      //     stream: firebaseHelper.watchAll(collectionPath: 'users'),
      //     builder: (context, snapshot) {
      //       if (snapshot.connectionState == ConnectionState.waiting) {
      //         return const Center(
      //           child: CircularProgressIndicator(),
      //         );
      //       }
      //       List<QueryDocumentSnapshot<Map<String, dynamic>>>? data =
      //           snapshot.data?.docs;
      //       //  print(" Users is ========= ${data?.docs.length}");
      //       if (data == null) {
      //         return const Center(
      //           child: Text('Empty'),
      //         );
      //       }
      //       // data.forEach((element) {
      //       //   print(element.id);
      //       // });
      //       List<WorkerModel> userList = data
      //           .map((value) => WorkerModel.fromJson(value.id, value))
      //           .toList();
      //       // userList.forEach((element) {
      //       //   print(element.docId);
      //       // });
      //       userList.removeWhere((user) =>
      //           user.role == "admin" ||
      //           user.docId == authBloc.state.userModel?.user!.uid);
      //       return ListView.builder(
      //           padding: const EdgeInsets.only(top: 10, bottom: 10),
      //           itemCount: userList.length,
      //           itemBuilder: ((context, index) =>
      //               WorkerCard(workerModel: userList[index])));
      //     }),
    );
  }
}
