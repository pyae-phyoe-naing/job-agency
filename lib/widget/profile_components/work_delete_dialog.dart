import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_agency/bloc/auth/auth_bloc.dart';
import 'package:job_agency/bloc/work_exp/work_exp_cubit.dart';
import 'package:starlight_utils/starlight_utils.dart';


class WorkDeleteDialog extends StatelessWidget {

  const WorkDeleteDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final WorkExpCubit workExpCubit = context.read<WorkExpCubit>();
    final AuthBloc authBloc = context.read<AuthBloc>();
    return AlertDialog(
      title: const Text('Delete'),
      content: const Text('Are you sure delete?'),
      actions: [
        TextButton(
          onPressed: () => StarlightUtils.pop(),
          child: const Text('cancel'),
        ),
        TextButton(
          onPressed: () async {
            StarlightUtils.pop();
            await workExpCubit.delete(
                authBloc.state.userModel?.user?.uid ?? '');
          },
          child: const Text('Ok'),
        ),
      ],
    );
  }
}
