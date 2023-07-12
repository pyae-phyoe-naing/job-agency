import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_agency/bloc/auth/auth_bloc.dart';
import 'package:job_agency/bloc/job_post/job_post_cubit.dart';
import 'package:job_agency/bloc/job_request/job_request_cubit.dart';
import 'package:job_agency/bloc/worker/worker_cubit.dart';
import 'package:job_agency/global.dart';
import 'package:job_agency/model/request_job_model.dart';
import 'package:job_agency/route/route.dart';
import 'package:starlight_utils/starlight_utils.dart';

class ManageAppliedJob extends StatelessWidget {
  const ManageAppliedJob({super.key});

  @override
  Widget build(BuildContext context) {
    final JobRequestCubit jobRequestCubit = context.watch<JobRequestCubit>();
    final WorkerCubit workerCubit = context.watch<WorkerCubit>();
    final JobPostCubit jobCubit = context.watch<JobPostCubit>();
    final AuthBloc authBloc = context.watch<AuthBloc>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
          splashRadius: 20,
        ),
        title: const Text(
          ' Applied Job',
          style: TextStyle(fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: jobRequestCubit.state.length,
          itemBuilder: (context, index) {
            String userName = workerCubit.state.workerList
                    .firstWhere(
                      (worker) =>
                          worker.docId == jobRequestCubit.state[index].workerId,
                      orElse: () => workerCubit.state.workerList[index],
                    )
                    .displayName ??
                '';

            String jobName = jobCubit.state.jobPostModelList
                .firstWhere(
                    (job) => job.id == jobRequestCubit.state[index].jobId)
                .title;

            return ListTile(
              onTap: () async {
                Navigator.pushNamed(context, RouteName.requestDetail,
                    arguments: jobRequestCubit.state[index]);
                RequestJobModel requestJob = jobRequestCubit.state[index];
                List view =(requestJob.view ?? []).toList();
                if (view.contains(authBloc.state.userModel?.user!.uid) == false) {
                  await firebaseHelper.update(
                      collectionPath: 'request-job',
                      docPath: requestJob.id,
                      data: requestJob
                          .notiView(authBloc.state.userModel!.user!.uid)
                          .toStoreFirebase());
                }
              },
              title: Text.rich(
                TextSpan(children: [
                  TextSpan(
                      text: userName,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                  const TextSpan(
                      text: '\t request \t', style: TextStyle(fontSize: 16)),
                  TextSpan(
                      text: jobName,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500)),
                ]),
              ),
              subtitle: Text(DateTime.now().differenceTimeInString(
                  jobRequestCubit.state[index].createdAt ?? DateTime.now())),
            );
          }),
    );
  }
}
