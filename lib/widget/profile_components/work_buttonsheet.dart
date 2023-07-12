import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_agency/bloc/auth/auth_bloc.dart';
import 'package:job_agency/bloc/work_exp/work_exp_cubit.dart';

class WorkButtonSheet extends StatefulWidget {
  final bool isUpdate;
  const WorkButtonSheet({super.key, this.isUpdate = false});

  @override
  State<WorkButtonSheet> createState() => _WorkButtonSheetState();
}

class _WorkButtonSheetState extends State<WorkButtonSheet> {
  late final WorkExpCubit _workExpCubit = context.read<WorkExpCubit>();
  late final AuthBloc _authBloc = context.read<AuthBloc>();
  final GlobalKey<FormState> _workFormkey = GlobalKey<FormState>();

  @override
  void dispose() {
    _workExpCubit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _workFormkey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _workExpCubit.titleController,
              validator: (_) => _?.isEmpty == true ? 'Title is require' : null,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Enter Title'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _workExpCubit.subTitleController,
              validator: (_) =>
                  _?.isEmpty == true ? 'Subtitle is require' : null,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Enter Subtitle'),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () async {
                  if (_workFormkey.currentState?.validate() == true &&
                      _authBloc.state.userModel?.user?.uid != null) {
                    Navigator.pop(context);
                    if (widget.isUpdate) {
                      await _workExpCubit
                          .update(_authBloc.state.userModel!.user!.uid);
                    } else {
                      await _workExpCubit
                          .create(_authBloc.state.userModel!.user!.uid);
                    }
                  }
                },
                child: Text(widget.isUpdate ? 'Update' : 'Add'))
          ],
        ),
      ),
    );
  }
}
