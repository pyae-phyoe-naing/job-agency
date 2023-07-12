import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_agency/bloc/auth/auth_bloc.dart';
import 'package:job_agency/global.dart';
import 'package:job_agency/model/user_model.dart';
import 'package:starlight_utils/starlight_utils.dart';

class UpdateCityDialog extends StatefulWidget {
  const UpdateCityDialog({super.key});

  @override
  State<UpdateCityDialog> createState() => _UpdateCityDialogState();
}

class _UpdateCityDialogState extends State<UpdateCityDialog> {
  final TextEditingController _cityController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode focusNode = FocusNode();
  late final AuthBloc _authBloc = context.read<AuthBloc>();

  @override
  void initState() {
    super.initState();
    _cityController.text = _authBloc.state.userModel?.city ?? '';
  }

  @override
  void dispose() {
    _cityController.dispose();
    _formKey.currentState?.dispose();
    focusNode.unfocus();
    super.dispose();
  }

  Future<void> updateCity() async {
    try {
      UserModel? userModel = _authBloc.state.userModel;
      final String changeCity = _cityController.text;
      if (_formKey.currentState?.validate() == true ||
          _authBloc.state.userModel?.user != null) {
        await firebaseHelper.update(
            collectionPath: 'users',
            docPath: _authBloc.state.userModel!.user!.uid,
            data: {'city': changeCity});
        // changes effect current device only => if user use two device not effect
        _authBloc.add(
          AuthListnerEvent(
            UserModel(
                user: userModel?.user,
                cloudMessageToken: userModel?.cloudMessageToken,
                role: userModel!.role,
                price: userModel.price,
                city: changeCity),
          ),
        );
      }
    } catch (e) {
      print('Price update error $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit City'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _cityController,
          focusNode: focusNode,
        
          validator: (_) => _?.isEmpty == true ? 'City is require' : null,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onEditingComplete: () => focusNode.unfocus(),
          decoration: const InputDecoration(labelText: 'City Name'),
        ),
      ),
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('cancel'),
        ),
        ChangeButton(onPress: updateCity),
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
