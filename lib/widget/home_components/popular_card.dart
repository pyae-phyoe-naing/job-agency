import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_agency/bloc/auth/auth_bloc.dart';
import 'package:job_agency/global.dart';
import 'package:job_agency/model/job_post_model.dart';
import 'package:job_agency/route/route.dart';
import 'package:job_agency/utils/theme.dart';

class PopularCard extends StatelessWidget {
  final JobPostModel jobPostModel;
  const PopularCard({super.key, required this.jobPostModel});

  @override
  Widget build(BuildContext context) {
    final AuthBloc authBloc = context.read<AuthBloc>();
    return GestureDetector(
      onTap: () {
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
      },
      child: Card(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Padding(
          padding: const EdgeInsets.all(13.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 170,
                height: 140,
                color: Colors.blue,
                child: CachedNetworkImage(
                  imageUrl: jobPostModel.photo,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                jobPostModel.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 14,
                    color: ThemeUtils.buttonColor,
                    fontWeight: FontWeight.w400),
              ),
              const SizedBox(
                height: 5,
              ),
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
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  const Icon(
                    Icons.favorite,
                    size: 16,
                    color: Colors.red,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    jobPostModel.likes?.length.toString() ?? '0',
                    style: ThemeUtils.rectionText,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
