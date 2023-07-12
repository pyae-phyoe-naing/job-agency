
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_agency/bloc/auth/auth_bloc.dart';
import 'package:starlight_utils/starlight_utils.dart';

class UpdateUsernameDialog extends StatefulWidget {
  const UpdateUsernameDialog({super.key});

  @override
  State<UpdateUsernameDialog> createState() => _UpdateUsernameDialogState();
}

class _UpdateUsernameDialogState extends State<UpdateUsernameDialog> {
  final TextEditingController _nameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode focusNode = FocusNode();
  late final AuthBloc _authBloc = context.read<AuthBloc>();

  @override
  void initState() {
    super.initState();
    _nameController.text = _authBloc.state.userModel?.user?.displayName ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _formKey.currentState?.dispose();
    focusNode.unfocus();
    super.dispose();
  }

  Future<void> updateUsername() async {
    if (_formKey.currentState?.validate() == false ||
        _authBloc.state.userModel?.user == null) return;

    try {
      await _authBloc.state.userModel?.user!
          .updateDisplayName(_nameController.text);
    //  userDataChange(_authBloc);
    } catch (e) {
      print('Username update error $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Username'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _nameController,
          focusNode: focusNode,
          validator: (_) => _?.isEmpty == true ? 'Name is require' : null,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onEditingComplete: () => focusNode.unfocus(),
          decoration: const InputDecoration(labelText: 'Username'),
        ),
      ),
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('cancel'),
        ),
        ChangeButton(onPress: updateUsername),
      ],
    );
  }
}

class ChangeButton extends StatefulWidget {
  final Future<void> Function()? onPress;

  const ChangeButton({super.key, required this.onPress});

  @override
  State<ChangeButton> createState() => _ChangeButtonState();
}

class _ChangeButtonState extends State<ChangeButton> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (isLoading) return;
        setState(() {
          isLoading = !isLoading;
        });
        await widget.onPress?.call();
        StarlightUtils.pop();
      },
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 1,
                color: Colors.white,
              ))
          : const Text('Change'),
    );
  }
}
