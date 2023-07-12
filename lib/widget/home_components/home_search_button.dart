import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_agency/bloc/job_post/job_post_cubit.dart';
import 'package:job_agency/global.dart';
import 'package:job_agency/model/job_post_model.dart';
import 'package:job_agency/route/route.dart';
import 'package:job_agency/widget/box/box.dart';
import 'package:job_agency/widget/work_components/work_card.dart';
import 'package:starlight_search_bar/starlight_search_bar.dart';

class HomeSearchButton extends StatelessWidget {
  const HomeSearchButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        StarlightSearchBar.searchBar(
            context: context,
            data: context.read<JobPostCubit>().state.jobPostModelList,
            onSearch: (List<JobPostModel> list, query) => list
                .where((job) =>
                    job.title.toLowerCase().contains(query.toLowerCase()) ||
                    job.status.toLowerCase().contains(query.toLowerCase()) ||
                    job.email.toLowerCase().contains(query.toLowerCase()) ||
                    job.phone.toLowerCase().contains(query.toLowerCase()))
                .toList(),
            buildSuggestion: (JobPostModel model) => ListTile(
                  onTap: () => Navigator.pushNamed(
                      context, RouteName.jobPostDetail,
                      arguments: model),
                  dense: true,
                  title: Text(model.title),
                  subtitle: Row(
                    children: [
                      for (var i = 0;
                          i <
                              (model.requirement.length > 5
                                  ? 5
                                  : model.requirement.length);
                          i++) ...[
                        Box(
                          title: model.requirement[i],
                        ),
                      ]
                    ],
                  ),
                ),
            buildResult: (JobPostModel model) => BlocProvider.value(
                  value: jobRequestCubit,
                  child: WorkCard(jobPostModel: model),
                ));
      },
      splashRadius: 20,
      icon: const Icon(
        Icons.search,
        size: 28,
      ),
    );
  }
}
