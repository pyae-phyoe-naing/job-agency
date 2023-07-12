import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_agency/bloc/auth/auth_bloc.dart';
import 'package:job_agency/bloc/job_post/job_post_cubit.dart';
import 'package:job_agency/bloc/job_request/job_request_cubit.dart';
import 'package:job_agency/bloc/pro_exp/watch_pro_exp_cubit.dart';
import 'package:job_agency/bloc/work_exp/watch_work_exp_cubit.dart';
import 'package:job_agency/bloc/worker/worker_cubit.dart';
import 'package:job_agency/route/route.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthBloc authBloc = context.read<AuthBloc>();
    final AuthBloc authBlocWatch = context.watch<AuthBloc>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
          splashRadius: 20,
        ),
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            // -------- Top Area -------
            Column(
              children: [
                ListTile(
                  tileColor: Colors.white,
                  onTap: () =>
                      Navigator.pushNamed(context, RouteName.emailChange),
                  title: const Text('Email'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                        return Text(
                          state.userModel?.user?.email ?? '',
                          style: const TextStyle(color: Colors.grey),
                        );
                      }),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.arrow_right),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  height: 0,
                ),
                ListTile(
                  tileColor: Colors.white,
                  onTap: () =>
                      Navigator.pushNamed(context, RouteName.passwordChange),
                  title: const Text('Password'),
                  trailing: const IconButton(
                      splashRadius: 20,
                      onPressed: null,
                      icon: Icon(Icons.arrow_right)),
                ),
              ],
            ),
            // --------------- Bottom Area

            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: ElevatedButton(
                    onPressed: () => authBloc.add(LogoutEvent([
                      context.read<JobPostCubit>().clear(),
                      context.read<JobRequestCubit>().clear(),
                      context.read<WatchProExpCubit>().clear(),
                      context.read<WatchWorkExpCubit>().clear(),
                      context.read<WorkerCubit>().clear(),
                    ])),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent),
                    child: BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                      return state is AuthLoadingState
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Sign Out',
                              style: TextStyle(color: Colors.white),
                            );
                    }),
                  ),
                ),
              ],
            ),
          ]),

          // --------- Loading ---------
          if (authBlocWatch.state is AuthLoadingState)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
