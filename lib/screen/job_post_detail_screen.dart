import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_agency/bloc/auth/auth_bloc.dart';
import 'package:job_agency/global.dart';
import 'package:job_agency/model/job_post_model.dart';
import 'package:job_agency/model/request_job_model.dart';
import 'package:job_agency/widget/box/box.dart';
import 'package:starlight_utils/starlight_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class JobPostDetailScreen extends StatelessWidget {
  final JobPostModel jobPostModel;
  const JobPostDetailScreen({super.key, required this.jobPostModel});

  @override
  Widget build(BuildContext context) {
    final AuthBloc authBloc = context.read<AuthBloc>();
    final String? workerId = authBloc.state.userModel?.user?.uid;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              splashRadius: 20,
              onPressed: () => Navigator.pop(context),
            ),
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(bottom: 10, left: 20),
              title: Container(
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(255, 255, 255, 0.1),
                      borderRadius: BorderRadius.circular(2)),
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Text(
                    jobPostModel.title,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1),
                  )),
              background: SizedBox(
                width: 100,
                height: 100,
                child: Hero(
                  tag: jobPostModel.photo,
                  child: CachedNetworkImage(
                    imageUrl: jobPostModel.photo,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => const Center(
                      child: Icon(Icons.error),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ListTile(
                      trailing: StreamBuilder<
                              DocumentSnapshot<Map<String, dynamic>>>(
                          stream: firebaseHelper.watch(
                              collectionPath: 'job-post',
                              docPath: jobPostModel.id),
                          builder: (context, snapshot) {
                            JobPostModel? model;
                            Map<String, dynamic>? data = snapshot.data?.data();
                            if (data != null) {
                              model = JobPostModel.fromJson(
                                  snapshot.data!.id, data);
                            }

                            return IconButton(
                                splashRadius: 20,
                                onPressed: () async {
                                  if (model == null) return;
                                  if (workerId == null) return;
                                  if (model.likes == null ||
                                      !model.likes!.contains(workerId)) {
                                    // like
                                    //print('like');
                                    await firebaseHelper.update(
                                        collectionPath: 'job-post',
                                        docPath: jobPostModel.id,
                                        data: model.addLike(workerId).toJson());
                                  } else {
                                    // Unlike
                                    //print('Unlike');
                                    model.likes!
                                        .removeWhere((id) => id == workerId);
                                    await firebaseHelper.update(
                                        collectionPath: 'job-post',
                                        docPath: model.id,
                                        data: model.toJson());
                                  }
                                },
                                icon: model?.likes != null &&
                                        model!.likes!.contains(workerId)
                                    ? const Icon(
                                        Icons.favorite,
                                        color: Colors.indigo,
                                        size: 30,
                                      )
                                    : const Icon(
                                        Icons.favorite_border,
                                        color: Colors.indigo,
                                        size: 30,
                                      ));
                          }),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      'Requirements',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Wrap(
                      children: jobPostModel.requirement
                          .map((e) => Box(
                                title: e,
                              ))
                          .toList(),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.wallet),
                      title: Text("${jobPostModel.salary.currencyFormat} MMK"),
                    ),
                    ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.code_rounded),
                      title: Text(jobPostModel.status),
                    ),
                    ListTile(
                      dense: true,
                      onTap: () async {
                        if (!await launchUrl(Uri(
                            scheme: 'tel',
                            path: "+959${jobPostModel.phone}"))) {
                          throw Exception('Could not launch ');
                        }
                      },
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.phone_android),
                      title: Text(jobPostModel.phone),
                      trailing: const Icon(Icons.arrow_right),
                    ),
                    ListTile(
                      dense: true,
                      onTap: () async {
                        if (!await launchUrl(
                            Uri(scheme: 'mailto', path: jobPostModel.email))) {
                          throw Exception('Could not launch ');
                        }
                      },
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.email_outlined),
                      title: Text(jobPostModel.email),
                      trailing: const Icon(Icons.arrow_right),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Content',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1),
                    ),
                    const Divider(),
                    Text(jobPostModel.desc),
                  ],
                ),
              )
            ]),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:
          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: firebaseHelper.watch(
                  collectionPath: 'request-job',
                  docPath: "$workerId${jobPostModel.id}"),
              builder: (context, snapshot) {
                RequestJobModel? requestJobModel;
                final Map<String, dynamic>? data = snapshot.data?.data();

                if (data != null) {
                  requestJobModel =
                      RequestJobModel.fromJson(snapshot.data!.id, data);
                }

                // CallBack Method
                Future<void> requestCallBack() async {
                  if (workerId == null) return;
                  try {
                    await firebaseHelper.create(
                        collectionPath: 'request-job',
                        docPath: "$workerId${jobPostModel.id}",
                        data: RequestJobModel(
                                workerId: workerId, jobId: jobPostModel.id)
                            .toStoreFirebase());
                  } catch (e) {
                    // To Do
                  }
                }

                final DateTime now = DateTime.now();
                // print(DateTime(now.year, now.month, now.day, now.hour)
                //         .difference(requestJobModel!.createdAt!)
                //         .inHours);

                return FloatingActionButton.extended(
                  backgroundColor: data == null
                      ? null
                      : requestJobModel == null
                          ? null
                          : DateTime(now.year, now.month, now.day)
                                      .difference(requestJobModel.createdAt!)
                                      .inDays <=
                                  90
                              ? Colors.grey
                              : null,
                  onPressed: data == null
                      ? requestCallBack
                      : requestJobModel == null
                          ? requestCallBack
                          : DateTime(now.year, now.month, now.day)
                                      .difference(requestJobModel.createdAt!)
                                      .inDays <=
                                  90
                              ? null
                              : requestCallBack,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  label: const Text('Apply Job'),
                );
              }),
    );
  }
}
