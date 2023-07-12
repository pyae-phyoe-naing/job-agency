import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_agency/bloc/auth/auth_bloc.dart';

import 'package:job_agency/route/route.dart';
import 'package:job_agency/utils/helper.dart';

class PasswordChange extends StatefulWidget {
  const PasswordChange({super.key});

  @override
  State<PasswordChange> createState() => _PasswordChangeState();
}

class _PasswordChangeState extends State<PasswordChange> {
  late final AuthBloc _authBloc = context.read<AuthBloc>();

  @override
  void dispose() {
    _authBloc.resetGlobalKey();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
          splashRadius: 20,
        ),
        title: const Text('Change Password'),
        centerTitle: true,
      ),
      // old password
      // new password // confirm password
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Form(
                key: _authBloc.passChangeForm,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const CurPassChangeInput(),
                    const SizedBox(
                      height: 15,
                    ),
                    const NewPassChangeInput(),
                    const SizedBox(
                      height: 15,
                    ),
                    const ConPassChangeInput(),
                    Container(
                      height: 45,
                      margin: const EdgeInsets.only(top: 15),
                      child: ElevatedButton(
                          onPressed: () {
                            _authBloc.add(ChangePasswordEvent());
                          },
                          child: BlocConsumer<AuthBloc, AuthState>(
                            listener: (context, state) {
                            
                              if (state is AuthSuccessState) {
                                _authBloc.currPassController.clear();
                                _authBloc.newPassController.clear();
                                _authBloc.conPassController.clear();
                                _authBloc.passChangeForm?.currentState?.reset();
                              }
                            },
                            builder: (context, state) {
                              if (state is AuthChangePassSuccessState) {
                                return const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                );
                              }

                              return const Text(
                                'Change Password',
                                style: TextStyle(fontSize: 16),
                              );
                            },
                          )),
                    ),
                    TextButton(
                        onPressed: () => Navigator.pushNamed(
                            context, RouteName.forgotPassword),
                        child: const Text('Forgot Password ?'))
                  ],
                )),
          ),
        ),
      ),
    );
  }
}

class CurPassChangeInput extends StatefulWidget {
  const CurPassChangeInput({super.key});

  @override
  State<CurPassChangeInput> createState() => _CurPassChangeInputState();
}

class _CurPassChangeInputState extends State<CurPassChangeInput> {
  late final _authBloc = context.read<AuthBloc>();
  bool isShow = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isShow,
      controller: _authBloc.currPassController,
      focusNode: _authBloc.curPassFocus,
      validator: passwordValidator,
      onEditingComplete: () => _authBloc.newPassFocus.requestFocus(),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.password),
          hintText: 'Current Password',
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

class NewPassChangeInput extends StatefulWidget {
  const NewPassChangeInput({super.key});

  @override
  State<NewPassChangeInput> createState() => _NewPassChangeInputState();
}

class _NewPassChangeInputState extends State<NewPassChangeInput> {
  late final _authBloc = context.read<AuthBloc>();
  bool isShow = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isShow,
      validator: passwordValidator,
      controller: _authBloc.newPassController,
      focusNode: _authBloc.newPassFocus,
      onEditingComplete: () => _authBloc.conPassFocus.requestFocus(),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.password),
          hintText: 'New Password',
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

class ConPassChangeInput extends StatefulWidget {
  const ConPassChangeInput({super.key});

  @override
  State<ConPassChangeInput> createState() => _ConPassChangeInputState();
}

class _ConPassChangeInputState extends State<ConPassChangeInput> {
  late final _authBloc = context.read<AuthBloc>();
  bool isShow = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isShow,
      validator: (value) => passwordValidator(value,
          checkPass: true, checkValue: _authBloc.newPassController.text),
      controller: _authBloc.conPassController,
      focusNode: _authBloc.conPassFocus,
      onEditingComplete: () => _authBloc.conPassFocus.unfocus(),
      autovalidateMode: AutovalidateMode.onUserInteraction,
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
