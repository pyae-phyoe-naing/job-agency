import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:job_agency/bloc/job_post/job_post_cubit.dart';
import 'package:job_agency/global.dart';
import 'package:job_agency/model/job_post_model.dart';

import 'package:job_agency/utils/string.dart';
import 'package:job_agency/utils/theme.dart';
import 'package:job_agency/widget/home_components/home_search_button.dart';
import 'package:job_agency/widget/work_components/work_card.dart';
import 'package:job_agency/widget/work_components/work_filter.dart';

class WorkView extends StatelessWidget {
  const WorkView({super.key});

  @override
  Widget build(BuildContext context) {
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
                            value: jobPostCubit,
                            child: const WorkFilter(),
                          ));
                },
                splashRadius: 20,
                icon: const Icon(
                  Icons.filter_alt_rounded,
                  color: ThemeUtils.buttonColor,
                ),
              ),
              const HomeSearchButton()
            ]),
        body: BlocBuilder<JobPostCubit, JobPostState>(
          builder: (context, state) {
            List<JobPostModel> filterPost = state.jobPostModelList.toList();
            if (state.amount > 0) {
              // Filter By Salary
              filterPost = state.jobPostModelList.toList()
                  .where((post) => post.salary == state.amount)
                  .toList();
            }
            if (state.sortByName) {
              // Filter By Name

              filterPost.sort((a, b) => a.title.compareTo(b.title));
            }
            if (state.sortByDate) {
              // Filter By Date

              filterPost.sort((a, b) => a.createdAt!.compareTo(b.createdAt!));
            }

            return ListView.builder(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              itemCount: filterPost.length,
              itemBuilder: ((context, index) => WorkCard(
                    jobPostModel: filterPost[index],
                  )),
            );
          },
        )

        // StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        //   stream: firebaseHelper.watchAll(collectionPath: 'job-post'),
        //   builder: (context, snapshot) {
        //     if (snapshot.connectionState == ConnectionState.waiting) {
        //       return const Center(
        //         child: CircularProgressIndicator(),
        //       );
        //     }
        //     if (snapshot.data == null) {
        //       return const Center(
        //         child: Text('Something Wrong'),
        //       );
        //     }
        //     final List<JobPostModel> jobPostList = snapshot.data!.docs
        //         .map((e) => JobPostModel.fromJson(e.id, e.data()))
        //         .toList();
        // print(snapshot.data?.docs
        //     .map((e) => JobPostModel.fromJson(e.id, e.data()))
        //     .toList()[0]
        //     .desc);
        //     return ListView.builder(
        //       padding: const EdgeInsets.only(top: 10, bottom: 10),
        //       itemCount: jobPostList.length,
        //       itemBuilder: ((context, index) => WorkCard(
        //             jobPostModel: jobPostList[index],
        //           )),
        //     );
        //   },
        // ),
        );
  }
}
