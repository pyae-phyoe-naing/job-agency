import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_agency/bloc/job_post/job_post_cubit.dart';
import 'package:job_agency/bloc/pro_exp/watch_pro_exp_cubit.dart';
import 'package:job_agency/bloc/work_exp/watch_work_exp_cubit.dart';
import 'package:job_agency/bloc/worker/worker_cubit.dart';
import 'package:job_agency/global.dart';
import 'package:job_agency/model/job_post_model.dart';
import 'package:job_agency/model/pro_model.dart';
import 'package:job_agency/model/request_job_model.dart';
import 'package:job_agency/model/work_model.dart';
import 'package:job_agency/model/worker_model.dart';
import 'package:collection/collection.dart';
import 'package:job_agency/widget/box/box.dart';
import 'package:job_agency/widget/profile_components/pro_exp_card.dart';
import 'package:job_agency/widget/profile_components/work_exp_card.dart';
import 'package:starlight_utils/starlight_utils.dart';

class RequestDetailScreen extends StatelessWidget {
  final RequestJobModel requestModel;
  const RequestDetailScreen({super.key, required this.requestModel});

  @override
  Widget build(BuildContext context) {
    WorkerModel? worker = context.watch<WorkerCubit>().state.workerList.firstWhereOrNull(
          (worker) => worker.docId == requestModel.workerId,
        );
    ProModelList proModelList =
        context.watch<WatchProExpCubit>().state.firstWhere(
              (proList) => proList.id == requestModel.workerId,
              orElse: () => ProModelList([]),
            );
    WorkModelList workObj = context.watch<WatchWorkExpCubit>().state.firstWhere(
          (workModelList) => workModelList.id == requestModel.workerId,
          orElse: () => WorkModelList(workModelList: []),
        );
    JobPostModel jobPost = context
        .watch<JobPostCubit>()
        .state.jobPostModelList
        .firstWhere((job) => job.id == requestModel.jobId);
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
        title: Text(
          worker?.displayName ?? '',
          style: const TextStyle(fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 5, bottom: 40),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(4),
                      image: worker?.photoURL == null
                          ? null
                          : DecorationImage(
                              fit: BoxFit.cover,
                              image: CachedNetworkImageProvider(
                                  worker!.photoURL!))),
                  child: worker?.photoURL != null
                      ? null
                      : Center(
                          child: Text(
                            worker?.displayName![0] ?? '',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 40,
                                color: Colors.white),
                          ),
                        ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      Text.rich(
                        TextSpan(text: "City : ", children: [
                          TextSpan(
                              text: worker?.city ?? 'Not Set',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold))
                        ]),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text.rich(
                        TextSpan(text: "Expected : ", children: [
                          TextSpan(
                              text: "${worker?.price.currencyFormat ?? '0'}MMK",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold))
                        ]),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text.rich(
                        TextSpan(text: "Email : ", children: [
                          TextSpan(
                              text: worker?.email ?? '',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold))
                        ]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          titleWidget('Skills'),
          for (var proExp in proModelList.proModelList) ...[
            ProExpCard(
              proModel: proExp,
              visitor: true,
            )
          ],
          titleWidget('Experiences'),
          for (var workExp in workObj.workModelList) ...[
            WorkExpCard(
              workModel: workExp,
              visitor: true,
            )
          ],
          titleWidget('Request Jobs'),
          Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(4),
                        image: worker?.photoURL == null
                            ? null
                            : DecorationImage(
                                fit: BoxFit.cover,
                                image:
                                    CachedNetworkImageProvider(jobPost.photo))),
                    child: worker?.photoURL != null
                        ? null
                        : Center(
                            child: Text(
                              worker?.displayName![0] ?? '',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 40,
                                  color: Colors.white),
                            ),
                          ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(text: "Name : ", children: [
                            TextSpan(
                                text: jobPost.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold))
                          ]),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text.rich(
                          TextSpan(text: "Status : ", children: [
                            TextSpan(
                                text: jobPost.status,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold))
                          ]),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text.rich(
                          TextSpan(text: "Phone : ", children: [
                            TextSpan(
                                text: jobPost.phone,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold))
                          ]),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text.rich(
                          TextSpan(text: "Email : ", children: [
                            TextSpan(
                                text: jobPost.email,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold))
                          ]),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
          titleWidget('Requirements'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Wrap(
              children: jobPost.requirement.map((e) => Box(title: e)).toList(),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          AcceptRejectCheckCond(requestJobModel: requestModel)
        ],
      ),
    );
  }

  // Title Widget
  Widget titleWidget(String title) {
    return Container(
      margin: const EdgeInsets.only(
        top: 20,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        title,
        style: const TextStyle(
            letterSpacing: 1,
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.indigo),
      ),
    );
  }
}

// ------------ Accept Reject Check State Class -----------//
class AcceptRejectCheckCond extends StatefulWidget {
  final RequestJobModel requestJobModel;
  const AcceptRejectCheckCond({super.key, required this.requestJobModel});

  @override
  State<AcceptRejectCheckCond> createState() => _AcceptRejectCheckCondState();
}

class _AcceptRejectCheckCondState extends State<AcceptRejectCheckCond> {
  late RequestJobModel _model;
  @override
  void initState() {
    super.initState();
    _model = widget.requestJobModel;
  }

  @override
  Widget build(BuildContext context) {
    if (!(DateTime.now().difference(_model.createdAt ?? DateTime.now()).inDays <
            90 &&
        _model.status == 1)) return const SizedBox();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OutlinedButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (_) => const MessageDialog(
                        isAccept: false,
                      )).then((value) async {
                if (value != null) {
                  setState(() {
                    _model = _model.copyWith(status: 3, message: value);
                  });
                  await firebaseHelper.update(
                      collectionPath: 'request-job',
                      docPath: _model.id,
                      data: {"status": 3, "message": value,'updatedAt':DateTime.now()});
                }
              });
            },
            child: const Text('Reject')),
        const SizedBox(
          width: 10,
        ),
        ElevatedButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (_) => const MessageDialog()).then((value) async {
                if (value != null) {
                  setState(() {
                    _model = _model.copyWith(status: 2, message: value);
                  });
                  await firebaseHelper.update(
                      collectionPath: 'request-job',
                      docPath: _model.id,
                      data: {"status": 2, "message": value,
                        'updatedAt': DateTime.now()
                      });
                }
              });
            },
            child: const Text('Accept')),
      ],
    );
  }
}

// ------------ Message Dialog Class -----------//
class MessageDialog extends StatefulWidget {
  final bool isAccept;
  const MessageDialog({super.key, this.isAccept = true});

  @override
  State<MessageDialog> createState() => _MessageDialogState();
}

class _MessageDialogState extends State<MessageDialog> {
  final TextEditingController _message = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Do you want to ${widget.isAccept ? 'accept' : 'reject'}?"),
      content: TextField(
        controller: _message,
        maxLines: 3,
        decoration: InputDecoration(
            hintText: 'Message',
            helperText: '(optional) ',
            border: const OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(
                Radius.circular(6),
              ),
            ),
            fillColor: Colors.indigo.shade50,
            filled: true),
      ),
      actions: [
        OutlinedButton(
            onPressed: () => Navigator.pop(context, null),
            child: const Text('cancel')),
        ElevatedButton(
            onPressed: () => Navigator.pop(context, _message.text),
            child: const Text('OK')),
      ],
    );
  }
}
