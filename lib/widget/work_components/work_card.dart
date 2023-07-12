import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_agency/bloc/auth/auth_bloc.dart';
import 'package:job_agency/bloc/job_request/job_request_cubit.dart';
import 'package:job_agency/global.dart';
import 'package:job_agency/model/job_post_model.dart';
import 'package:job_agency/model/request_job_model.dart';
import 'package:job_agency/route/route.dart';
import 'package:job_agency/utils/theme.dart';
import 'package:job_agency/widget/box/box.dart';

class WorkCard extends StatelessWidget {
  final bool visitor;
  final JobPostModel jobPostModel;
  const WorkCard({super.key, required this.jobPostModel, this.visitor = true});

  @override
  Widget build(BuildContext context) {
    final AuthBloc authBloc = context.read<AuthBloc>();
    final JobRequestCubit jobRequest = context.read<JobRequestCubit>();
    return GestureDetector(
      onLongPress: () async {
        // Delete Job Post
        if (visitor == false) {
          await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: const Text('Delete'),
                    content: const Text('Are you sure delete post?'),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('cancel')),
                      TextButton(
                          onPressed: () async {
                            Navigator.pop(context);

                            try {
                              await firebaseHelper.delete(
                                  collectionPath: 'job-post',
                                  docPath: jobPostModel.id);
                              RequestJobModel requestJob = jobRequest.state
                                  .firstWhere((element) =>
                                      element.jobId == jobPostModel.id);

                              await firebaseHelper.delete(
                                  collectionPath: 'request-job',
                                  docPath: requestJob.id);
                            } catch (e) {
                              // To Do
                            }
                          },
                          child: const Text('Ok')),
                    ],
                  ));
        }
      },
      onTap: () {
        if (visitor) {
          final String? viewerId = authBloc.state.userModel?.user?.uid;
          if (viewerId == null) return;
          if (!jobPostModel.views.contains(viewerId)) {
            firebaseHelper.update(
                collectionPath: 'job-post',
                docPath: jobPostModel.id,
                data: jobPostModel.addView(viewerId).toJson());
          }
          Navigator.pushNamed(context, RouteName.jobPostDetail,
              arguments: jobPostModel);
        } else {
          // ---------- Manage Post
          Navigator.pushNamed(context, RouteName.createJob,
              arguments: jobPostModel);
        }
      },
      child: Container(
        height:150,
        color: Colors.white,
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Hero(
            tag: jobPostModel.photo,
            child: SizedBox(
              width: 100,
              height: 100,
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
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: SizedBox(
              height: 125,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    jobPostModel.title,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: ThemeUtils.buttonColor),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height:28,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: jobPostModel.requirement.length,
                        itemBuilder: (context, index) {
                          return Box(title: jobPostModel.requirement[index]);
                        }),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    jobPostModel.status,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: ThemeUtils.buttonColor),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.visibility,
                            size: 16,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            jobPostModel.views.length.toString(),
                            style: ThemeUtils.rectionText,
                          )
                        ],
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.favorite,
                            color: Colors.redAccent,
                            size: 16,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            (jobPostModel.likes ?? []).length.toString(),
                            style: ThemeUtils.rectionText,
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          const Icon(Icons.chevron_right)
        ]),
      ),
    );
  }
}
