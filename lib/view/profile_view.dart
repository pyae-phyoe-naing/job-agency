import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_agency/bloc/auth/auth_bloc.dart';
import 'package:job_agency/bloc/job_post/job_post_cubit.dart';
import 'package:job_agency/bloc/job_request/job_request_cubit.dart';
import 'package:job_agency/bloc/pro_exp/pro_exp_cubit.dart';
import 'package:job_agency/bloc/work_exp/work_exp_cubit.dart';
import 'package:job_agency/model/job_post_model.dart';
import 'package:job_agency/model/request_job_model.dart';
import 'package:job_agency/route/route.dart';

import 'package:job_agency/utils/theme.dart';
import 'package:job_agency/widget/home_components/popular_card.dart';
import 'package:job_agency/widget/home_components/selection_title.dart';
import 'package:job_agency/widget/profile_components/pro_buttonsheet.dart';
import 'package:job_agency/widget/profile_components/pro_exp_list.dart';
import 'package:job_agency/widget/profile_components/profile_card.dart';
import 'package:job_agency/widget/profile_components/work_buttonsheet.dart';
import 'package:job_agency/widget/profile_components/work_exp_list.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthBloc authBloc = context.read<AuthBloc>();
    final JobPostCubit jobPostCubit = context.read<JobPostCubit>();

    final List<Widget> userProfile = [
      // Profile Card
      const ProfileCard(),
      // Pro Experience
      SelectionTitle(
        title: 'Pro Experience',
        onPressed: null,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        extraWidget: TextButton(
          onPressed: () {
            //   showModalBottomSheet(
            //       shape: const RoundedRectangleBorder(
            //           borderRadius: BorderRadius.all(Radius.circular(10))),
            //       context: context,
            //       builder: (_) => BlocProvider<ProExpCubit>.value(
            //           value: _cubit, child: const ModalBox()));
            showModalBottomSheet(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              context: context,
              builder: (_) => BlocProvider(
                  create: (context) => ProExpCubit(),
                  child: const ProButtonSheet()),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
      const ProExpList(),
      // Work Experience
      SelectionTitle(
        title: 'Work Experience',
        onPressed: null,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        extraWidget: TextButton(
          onPressed: () {
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return BlocProvider(
                    create: (context) => WorkExpCubit(),
                    child: const WorkButtonSheet(),
                  );
                });
          },
          child: const Icon(Icons.add),
        ),
      ),
      const WorkExpList(),
      // Recent Applied
      SelectionTitle(
        title: 'Recent Applied',
        onPressed: () {},
        padding: const EdgeInsets.symmetric(horizontal: 20),
      ),
      SizedBox(
        width: double.infinity,
        height: 235,
        child: BlocBuilder<JobPostCubit,JobPostState>(
          builder: (context, state) {
            return BlocBuilder<JobRequestCubit, List<RequestJobModel>>(
              builder: (context, state) {
               final List<JobPostModel> posts= state
                    .where((model) =>
                        model.workerId == authBloc.state.userModel?.user!.uid)
                    .toList()
                    .map((model) => jobPostCubit.state.jobPostModelList
                        .firstWhere((post) => post.id == model.jobId))
                    .toList().where((post) => (post.createdAt?.difference(DateTime.now()).inDays ??
                            0 ) < 31).toList();
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  itemCount: posts.length,
                  itemBuilder: (context, index) => PopularCard(jobPostModel: posts[index]),
                );
              },
            );
          },
        ),
      ),
    ];
    final List<Widget> adminProfile = [
      const ProfileCard(),
      const SizedBox(
        height: 30,
      ),
      ListTile(
        onTap: () => Navigator.pushNamed(context, RouteName.createJob),
        tileColor: Colors.white,
        title: const Text('Create Job Post'),
      ),
      const Divider(
        height: 1,
      ),
      ListTile(
        onTap: () => Navigator.pushNamed(context, RouteName.manageJob),
        tileColor: Colors.white,
        title: const Text('Manage Job Post'),
      ),
      const Divider(
        height: 1,
      ),
      ListTile(
        onTap: () => Navigator.pushNamed(context, RouteName.manageApplied),
        tileColor: Colors.white,
        title: const Text('Manage Applied Job'),
      ),
    ];

    // final ProExpCubit _cubit = context.read<ProExpCubit>();
    // print("Profileview state ${_cubit.state}");

    return Scaffold(
      backgroundColor: ThemeUtils.scaffoldBg,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Profile'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          // IconButton(
          //   onPressed: () => authBloc.add(LogoutEvent()),
          //   splashRadius: 20,
          //   icon: const Icon(
          //     Icons.logout,
          //     color: ThemeUtils.buttonColor,
          //   ),
          // ),
          IconButton(
            onPressed: () => Navigator.pushNamed(context, RouteName.setting),
            splashRadius: 20,
            icon: const Icon(
              Icons.settings,
              color: ThemeUtils.buttonColor,
            ),
          )
        ],
      ),
      body: ListView(
        children: authBloc.state.userModel?.role == 'user'
            ? userProfile
            : adminProfile,
      ),
    );
  }
}
