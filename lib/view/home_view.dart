import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_agency/bloc/job_post/job_post_cubit.dart';
import 'package:job_agency/model/job_post_model.dart';
import 'package:job_agency/utils/string.dart';
import 'package:job_agency/utils/theme.dart';
import 'package:job_agency/widget/button/stack_button.dart';
import 'package:job_agency/widget/home_components/home_search_button.dart';

import 'package:job_agency/widget/home_components/popular_card.dart';
import 'package:job_agency/widget/home_components/selection_title.dart';
import 'package:job_agency/widget/home_components/today_card.dart';
import 'package:job_agency/widget/home_components/welcome_card.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: ThemeUtils.scaffoldBg,
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          StringUtils.appName,
          style: TextStyle(letterSpacing: 0.5),
        ),
        actions: const [
          StackButton(),
          HomeSearchButton(),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 10),
        children: [
          const WelcomeCard(),
          BlocBuilder<JobPostCubit, JobPostState>(
            builder: (context, state) {
              List<JobPostModel> recent = state.jobPostModelList
                  .where((model) =>
                      (DateTime.now()
                              .difference(model.createdAt ?? DateTime.now()))
                          .inDays <=
                      5)
                  .toList();
              if (recent.isEmpty) {
                return const SizedBox();
              }
              return SelectionTitle(
                title: 'Recent',
                onPressed: () {},
              );
            },
          ),
          SizedBox(
              width: double.infinity,
              height: 235,
              child: BlocBuilder<JobPostCubit, JobPostState>(
                builder: (context, state) {
                  List<JobPostModel> recent = state.jobPostModelList
                      .where((model) =>
                          (DateTime.now()
                                  .difference(model.createdAt ?? DateTime.now()))
                              .inDays <=
                          5)
                      .toList();
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    scrollDirection: Axis.horizontal,
                    itemCount: recent.length > 10 ? 10 : recent.length,
                    itemBuilder: (context, index) => PopularCard(
                      jobPostModel: recent[index],
                    ),
                  );
                },
              )),
          BlocBuilder<JobPostCubit, JobPostState>(
            builder: (context, state) {
              List<JobPostModel> popular = state.jobPostModelList.toList();
              popular.sort((pre, cur) =>
                  cur.views.length.compareTo(pre.views.length) +
                  (cur.likes?.length ?? 0).compareTo(pre.likes?.length ?? 0));
              popular.removeWhere((post) => (post.likes?.length ?? 0) < 2);
              if (popular.isEmpty) {
                return const SizedBox();
              }
              return SelectionTitle(
                title: 'Popular',
                onPressed: () {},
              );
            },
          ),
          SizedBox(
              width: double.infinity,
              height: 235,
              child: BlocBuilder<JobPostCubit, JobPostState>(
                builder: (context, state) {
                  List<JobPostModel> popular = state.jobPostModelList.toList();
                  popular.sort((pre, cur) =>
                      cur.views.length.compareTo(pre.views.length) +
                      (cur.likes?.length ?? 0)
                          .compareTo(pre.likes?.length ?? 0));
                  popular.removeWhere((post) => (post.likes?.length ?? 0) < 2);
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    scrollDirection: Axis.horizontal,
                    itemCount: popular.length > 10 ? 10 : popular.length,
                    itemBuilder: (context, index) =>
                        PopularCard(jobPostModel: popular[index]),
                  );
                },
              )),
          BlocBuilder<JobPostCubit, JobPostState>(
            builder: (context, state) {
              List<JobPostModel> today = state.jobPostModelList
                  .where(
                    (job) =>
                        (DateTime.now()
                                .difference(job.createdAt ?? DateTime.now()))
                            .inDays <
                        1,
                  )
                  .toList();
              if (today.isEmpty) return const SizedBox();
              return SelectionTitle(
                title: 'Today',
                onPressed: () {},
              );
            },
          ),
          BlocBuilder<JobPostCubit, JobPostState>(
            builder: (context, state) {
              List<JobPostModel> today = state.jobPostModelList.where((job) {
                // print(
                //     (DateTime.now().difference(job.createdAt ?? DateTime.now()))
                //         .inDays);
                return (DateTime.now()
                            .difference(job.createdAt ?? DateTime.now()))
                        .inDays <
                    1;
              }).toList();
              return Column(
                children: today.map((e) => TodayCard(post: e)).toList(),
              );
            },
          )
        ],
      ),
    );
  }
}
