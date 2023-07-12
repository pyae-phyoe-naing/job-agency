import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_agency/bloc/auth/auth_bloc.dart';
import 'package:job_agency/global.dart';
import 'package:job_agency/model/user_model.dart';
import 'package:starlight_utils/starlight_utils.dart';

class UpdatePriceDialog extends StatefulWidget {
  const UpdatePriceDialog({super.key});

  @override
  State<UpdatePriceDialog> createState() => _UpdatePriceDialogState();
}

class _UpdatePriceDialogState extends State<UpdatePriceDialog> {
  final TextEditingController _priceController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode focusNode = FocusNode();
  late final AuthBloc _authBloc = context.read<AuthBloc>();

  @override
  void initState() {
    super.initState();
    _priceController.text = _authBloc.state.userModel!.price.toInt().toString();
  }

  @override
  void dispose() {
    _priceController.dispose();
    _formKey.currentState?.dispose();
    focusNode.unfocus();
    super.dispose();
  }

  Future<void> updatePrice() async {
    try {
      UserModel? userModel = _authBloc.state.userModel;
      final double changePrice = double.parse(_priceController.text);
      if (_formKey.currentState?.validate() == true ||
          _authBloc.state.userModel?.user != null) {
        await firebaseHelper.update(
            collectionPath: 'users',
            docPath: _authBloc.state.userModel!.user!.uid,
            data: {'price': changePrice});
        // changes effect current device only => if user use two device not effect
        _authBloc.add(
          AuthListnerEvent(
            UserModel(
                user: userModel?.user,
                cloudMessageToken: userModel?.cloudMessageToken,
                role: userModel!.role,
                price: changePrice,city: userModel.city),
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
      title: const Text('Edit Price'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _priceController,
          focusNode: focusNode,
          keyboardType: TextInputType.number,
          validator: (_) => _?.isEmpty == true
              ? 'Price is require'
              : double.tryParse(_!) == null
                  ? 'Number only'
                  : null,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onEditingComplete: () => focusNode.unfocus(),
          decoration: const InputDecoration(labelText: 'Price'),
        ),
      ),
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('cancel'),
        ),
        ChangeButton(onPress: updatePrice),
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
