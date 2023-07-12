import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_agency/bloc/auth/auth_bloc.dart';
import 'package:job_agency/bloc/work_exp/watch_work_exp_cubit.dart';
import 'package:job_agency/model/work_model.dart';
import 'package:job_agency/widget/profile_components/work_exp_card.dart';

class WorkExpList extends StatelessWidget {
  const WorkExpList({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthBloc authBloc = context.read<AuthBloc>();
    return BlocBuilder<WatchWorkExpCubit, List<WorkModelList>>(
        builder: (_, state) {
      WorkModelList workModelListObj = state.firstWhere(
        (workModelList) =>
            workModelList.id == authBloc.state.userModel?.user!.uid,
        orElse: () => WorkModelList(workModelList: []),
      );
      return Column(
        children: workModelListObj.workModelList
            .map((workModel) => WorkExpCard(
                  workModel: workModel,
                ))
            .toList(),
      );
    });
    // StreamBuilder(
    //     stream: firebaseHelper.watch(
    //         collectionPath: 'work-exp',
    //         docPath: authBloc.state.userModel?.user?.uid ?? ''),
    //     builder: (context, snapshot) {
    //       if (snapshot.connectionState == ConnectionState.waiting ||
    //           snapshot.data?.data() == null) {
    //         return const SizedBox();
    //       }
    //       final WorkModelList workModelListObj =
    //           WorkModelList.fromJson(snapshot.data!.data());
    //       return Column(
    //         children: workModelListObj.workModelList
    //             .map((workModel) => WorkExpCard(
    //                   workModel: workModel,
    //                 ))
    //             .toList(),
    //       );
    //     });
  }
}
