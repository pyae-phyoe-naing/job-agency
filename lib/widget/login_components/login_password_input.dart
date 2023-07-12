import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_agency/utils/helper.dart';

import '../../bloc/auth/auth_bloc.dart';

class LoginPasswordInput extends StatefulWidget {
  const LoginPasswordInput({super.key});

  @override
  State<LoginPasswordInput> createState() => _LoginPasswordInputState();
}

class _LoginPasswordInputState extends State<LoginPasswordInput> {
  bool isShow = true;
  @override
  Widget build(BuildContext context) {
    AuthBloc authBloc = context.read<AuthBloc>();

    return TextFormField(
      obscureText: isShow,
      controller: authBloc.loginPassController,
      focusNode: authBloc.loginPasswordFocus,
      onEditingComplete: () {
        authBloc.add(LoginWithEmailEvent());
      },
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
