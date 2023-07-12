import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_agency/bloc/auth/auth_bloc.dart';
import 'package:job_agency/bloc/job_request/job_request_cubit.dart';
import 'package:job_agency/model/request_job_model.dart';
import 'package:job_agency/route/route.dart';
import 'package:job_agency/utils/theme.dart';

class StackButton extends StatelessWidget {
  const StackButton({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthBloc authBloc = context.read<AuthBloc>();
    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, RouteName.notification);
          },
          splashRadius: 20,
          icon: const Icon(
            Icons.notifications,
            color: ThemeUtils.buttonColor,
            size: 28,
          ),
        ),
        Positioned(
          top: 10,
          right: 7,
          child: BlocBuilder<JobRequestCubit, List<RequestJobModel>>(
              builder: (context, state) {
            List<RequestJobModel> noti = state
                .toList()
                .where((requestJob) => authBloc.state.userModel?.role == "admin"
                    ?
                    // Admin
                    // DateTime.now()
                    //         .difference(requestJob.createdAt ?? DateTime.now())
                    //         .inDays <
                    //     1 &&
                    (requestJob.view ?? [])
                            .contains(authBloc.state.userModel?.user!.uid) !=
                        true
                    :
                    // User
                    (requestJob.view ?? []).contains(
                                authBloc.state.userModel?.user?.uid) !=
                            true &&
                        requestJob.workerId ==
                            authBloc.state.userModel?.user?.uid &&
                        requestJob.status != 1)
                .toList();
            return noti.isEmpty
                ? const Center()
                : Container(
                    alignment: Alignment.center,
                    width: 17,
                    height: 17,
                    decoration: const BoxDecoration(
                        color: Colors.red, shape: BoxShape.circle),
                    child: Text(
                      "${noti.length}",
                      style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ));
          }),
        ),
      ],
    );
  }
}
