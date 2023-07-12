import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_agency/bloc/auth/auth_bloc.dart';
import 'package:job_agency/bloc/home/view_manage_cubit.dart';
import 'package:job_agency/bloc/job_post/job_post_cubit.dart';
import 'package:job_agency/bloc/job_request/job_request_cubit.dart';
import 'package:job_agency/bloc/pro_exp/watch_pro_exp_cubit.dart';
import 'package:job_agency/bloc/work_exp/watch_work_exp_cubit.dart';
import 'package:job_agency/bloc/worker/worker_cubit.dart';
import 'package:job_agency/utils/theme.dart';
import 'package:job_agency/view/home_view.dart';
import 'package:job_agency/view/profile_view.dart';
import 'package:job_agency/view/work_view.dart';
import 'package:job_agency/view/worker_view.dart';
import 'package:job_agency/widget/home_components/home_bottom_nav.dart';

List<Widget> _homeScreen = [
  const HomeView(),
  const WorkView(),
  const ProfileView()
];
List<Widget> _adminHomeScreen = [
  const HomeView(),
  const WorkView(),
  const WorkerView(),
  const ProfileView()
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final ViewManageCubit viewManageCubit = context.read<ViewManageCubit>();

  @override
  void initState() {
    super.initState();
    context.read<JobPostCubit>().init();
    context.read<JobRequestCubit>().init();
    context.read<WatchProExpCubit>().init();
    context.read<WatchWorkExpCubit>().init();
    context.read<WorkerCubit>().init();
  }

  @override
  void dispose() {
    super.dispose();
    viewManageCubit.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AuthBloc authBloc = context.read<AuthBloc>();
    return Scaffold(
        backgroundColor: ThemeUtils.scaffoldBg,
        body: PageView.builder(
            onPageChanged: (value) {
              viewManageCubit.animateTo(value, false);
            },
            controller: viewManageCubit.controller,
            itemCount: authBloc.state.userModel?.role == 'admin'
                ? _adminHomeScreen.length
                : _homeScreen.length,
            itemBuilder: (context, index) {
              return authBloc.state.userModel?.role == 'admin'
                  ? _adminHomeScreen[index]
                  : _homeScreen[index];
            }),
        bottomNavigationBar: authBloc.state.userModel?.role == 'admin'
            ? const AdminHomeBottomNav()
            : const HomeBottomNav());
  }
}
