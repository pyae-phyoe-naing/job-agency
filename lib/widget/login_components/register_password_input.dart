import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_agency/bloc/auth/auth_bloc.dart';
import 'package:job_agency/utils/helper.dart';

class RegisterPasswordInput extends StatefulWidget {
  const RegisterPasswordInput({super.key});

  @override
  State<RegisterPasswordInput> createState() => _RegisterPasswordInputState();
}

class _RegisterPasswordInputState extends State<RegisterPasswordInput> {
  bool isShow = true;

  @override
  Widget build(BuildContext context) {
    AuthBloc authBloc = context.read<AuthBloc>();

    return TextFormField(
      obscureText: isShow,
      controller: authBloc.registerPassController,
      focusNode: authBloc.registerPasswordFocus,
      onEditingComplete: authBloc.registerConfirmPasswordFocus.requestFocus,
      validator: passwordValidator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.password),
          hintText: 'Password',
          isDense: true,
          border: const OutlineInputBorder(),
          suffixIcon: IconButton(
            splashRadius: 20,
            onPressed: () {
              setState(() {
                isShow = !isShow;
              });
            },
            icon: isShow
                ? const Icon(Icons.visibility_off)
                : const Icon(Icons.visibility),
          )),
    );
  }
}

class RegisterConfirmPasswordInput extends StatefulWidget {
  const RegisterConfirmPasswordInput({super.key});

  @override
  State<RegisterConfirmPasswordInput> createState() =>
      _RegisterConfirmPasswordInputState();
}

class _RegisterConfirmPasswordInputState
    extends State<RegisterConfirmPasswordInput> {
  bool isShow = true;

  @override
  Widget build(BuildContext context) {
    AuthBloc authBloc = context.read<AuthBloc>();

    return TextFormField(
      obscureText: isShow,
      validator: (value) => passwordValidator(value,
          checkPass: true, checkValue: authBloc.registerPassController.text),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: authBloc.registerConfirmPassController,
      focusNode: authBloc.registerConfirmPasswordFocus,
      onEditingComplete: () {
        authBloc.add(RegisterWithEmailEvent());
      },
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.password),
          hintText: 'Confirm Password',
          isDense: true,
          border: const OutlineInputBorder(),
          suffixIcon: IconButton(
            splashRadius: 20,
            onPressed: () {
              setState(() {
                isShow = !isShow;
              });
            },
            icon: isShow
                ? const Icon(Icons.visibility_off)
                : const Icon(Icons.visibility),
          )),
    );
  }
}
