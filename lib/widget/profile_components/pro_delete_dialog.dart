import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_agency/bloc/auth/auth_bloc.dart';
import 'package:job_agency/bloc/pro_exp/pro_exp_cubit.dart';
import 'package:job_agency/model/pro_model.dart';
import 'package:starlight_utils/starlight_utils.dart';

class ProDeleteDialog extends StatelessWidget {
  final ProModel proModel;
  const ProDeleteDialog({super.key, required this.proModel});

  @override
  Widget build(BuildContext context) {
    final ProExpCubit proExpCubit = context.read<ProExpCubit>();
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
            await proExpCubit.delete(
                authBloc.state.userModel?.user?.uid ?? '', proModel.createdAt!);
          },
          child: const Text('Ok'),
        ),
      ],
    );
  }
}
