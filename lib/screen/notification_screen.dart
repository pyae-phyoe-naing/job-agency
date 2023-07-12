import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_agency/bloc/auth/auth_bloc.dart';
import 'package:job_agency/bloc/job_post/job_post_cubit.dart';
import 'package:job_agency/bloc/job_request/job_request_cubit.dart';
import 'package:job_agency/bloc/worker/worker_cubit.dart';
import 'package:job_agency/global.dart';
import 'package:job_agency/model/request_job_model.dart';
import 'package:job_agency/model/user_model.dart';
import 'package:job_agency/model/worker_model.dart';
import 'package:job_agency/route/route.dart';
import 'package:job_agency/utils/theme.dart';
import 'package:starlight_utils/starlight_utils.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final JobRequestCubit reqJob = context.watch<JobRequestCubit>();
    final UserModel? auth = context.read<AuthBloc>().state.userModel;
    final WorkerCubit workerCubit = context.watch<WorkerCubit>();
    final JobPostCubit jobCubit = context.watch<JobPostCubit>();
    List<RequestJobModel> noti = [];
    noti = reqJob.state
        .where((element) => auth?.role == 'admin'
            ? (element.view ?? []).contains(auth?.user!.uid) != true
            : element.status != 1 && element.workerId == auth?.user!.uid)
        .toList();
    // if (auth?.role == 'user') {
    //   noti = reqJob.state
    //       .where(
    //         (element) =>
    //             !(element.view ?? []).contains(auth?.user!.uid) &&
    //             element.workerId == auth?.user!.uid &&
    //             element.status != 1,
    //       )
    //       .toList();
    // } else {
    //   // Admin
    //   noti = reqJob.state
    //       .where(
    //         (element) =>
    //             !(element.view ?? []).contains(auth?.user!.uid) &&
    //             element.status == 1,
    //       )
    //       .toList();
    // }
    noti.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          onPressed: () async {
            Navigator.pop(context);
            if (auth?.role == 'user') {
              for (var req in noti) {
                if (!(req.view ?? []).contains(auth!.user!.uid)) {
                  await firebaseHelper.update(
                      collectionPath: 'request-job',
                      docPath: req.id,
                      data: req.notiView(auth.user!.uid).toStoreFirebase());
                }
              }
            }
          },
          icon: const Icon(Icons.arrow_back),
          splashRadius: 20,
        ),

        title: const Text(
          ' Notifications',
          style: TextStyle(fontSize: 18),
        ),
        // centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: noti.length,
          itemBuilder: (context, index) {
            String userName = workerCubit.state.workerList
                    .firstWhere(
                      (worker) => worker.docId == noti[index].workerId,
                      orElse: () => WorkerModel(
                          docId: '',
                          displayName: '',
                          photoURL: '',
                          email: '',
                          city: '',
                          cloudMessageToken: '',
                          role: '',
                          price: 0.0),
                    )
                    .displayName ??
                '';

            String jobName = jobCubit.state.jobPostModelList
                .firstWhere((job) => job.id == noti[index].jobId)
                .title;

            return Container(
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 3),
              margin: const EdgeInsets.only(top: 5),
              color: auth?.role == 'admin'
                  ? ThemeUtils.scaffoldBg
                  : (noti[index].view ?? []).contains(auth?.user!.uid) != true
                      ? const Color.fromARGB(255, 231, 229, 229)
                      : ThemeUtils.scaffoldBg,
              child: ListTile(
                onTap: () async {
                  if (auth?.role == 'admin') {
                    Navigator.pushNamed(context, RouteName.requestDetail,
                        arguments: noti[index]);
                    RequestJobModel requestJob = noti[index];
                    List view = (requestJob.view ?? []).toList();
                    if (view.contains(auth?.user!.uid) == false) {
                      await firebaseHelper.update(
                          collectionPath: 'request-job',
                          docPath: requestJob.id,
                          data: requestJob
                              .notiView(auth!.user!.uid)
                              .toStoreFirebase());
                    }
                  }
                },
                title: auth?.role == "admin"
                    ?
                    // Admin
                    Text.rich(
                        TextSpan(children: [
                          TextSpan(
                              text: userName,
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600)),
                          const TextSpan(
                              text: '\t request \t',
                              style: TextStyle(fontSize: 15)),
                          TextSpan(
                              text: jobName,
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500)),
                        ]),
                      )
                    :
                    // User
                    Text.rich(
                        TextSpan(children: [
                          const TextSpan(
                              text: 'Your',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600)),
                          const TextSpan(
                              text: '\t request \t',
                              style: TextStyle(fontSize: 15)),
                          TextSpan(
                              text: jobName,
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500)),
                          const TextSpan(
                              text: " job is ", style: TextStyle(fontSize: 16)),
                          TextSpan(
                              text: noti[index].status == 2
                                  ? " accept."
                                  : " reject.",
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                        ]),
                      ),
                subtitle: auth?.role != "admin"
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Text(noti[index].message ?? "",
                                style: const TextStyle(
                                    color: Colors.blueAccent, fontSize: 15)),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                  "${DateTime.now().differenceTimeInString(noti[index].updatedAt ?? DateTime.now())} ago",
                                  style: const TextStyle(color: Colors.indigo)),
                            ],
                          ),
                        ],
                      )
                    : Text(DateTime.now().differenceTimeInString(
                        noti[index].createdAt ?? DateTime.now())),
              ),
            );
          }),
    );
  }
}
