import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_agency/bloc/auth/auth_bloc.dart';
import 'package:job_agency/utils/helper.dart';
import 'package:job_agency/utils/theme.dart';
import 'package:starlight_utils/starlight_utils.dart';

class EmailChange extends StatefulWidget {
  const EmailChange({super.key});

  @override
  State<EmailChange> createState() => _EmailChangeState();
}

class _EmailChangeState extends State<EmailChange> {
  late final AuthBloc _authBloc = context.read();

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
        title: const Text('Change Email'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Form(
                key: _authBloc.emailChangeForm,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _authBloc.newEmailController,
                      focusNode: _authBloc.newEmailFocus,
                      onEditingComplete: () =>
                          _authBloc.oldPassFocus.requestFocus(),
                      validator: (value) => value?.isEmpty == true
                          ? 'Email is require'
                          : value!.isEmail
                              ? null
                              : 'Invalid email',
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: ThemeUtils.inputDec.copyWith(
                          prefixIcon: const Icon(Icons.alternate_email),
                          hintText: 'New Email'),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const CurPassChangeInput(),
                    Container(
                      height: 45,
                      margin: const EdgeInsets.only(top: 15),
                      child: ElevatedButton(
                          onPressed: () {
                            _authBloc.add(ChangeEmailEvent());
                          },
                          child: BlocConsumer<AuthBloc, AuthState>(
                            listener: (context, state) {
                              if (state is AuthSuccessState) {
                                _authBloc.newEmailController.clear();                              
                                _authBloc.oldPassController.clear();
                                _authBloc.emailChangeForm?.currentState
                                    ?.reset();
                              }
                            },
                            builder: (context, state) {
                              if (state is AuthChangeEmailLoadingState) {
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
                                'Change Email',
                                style: TextStyle(fontSize: 16),
                              );
                            },
                          )),
                    ),
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
      controller: _authBloc.oldPassController,
      focusNode: _authBloc.oldPassFocus,
      validator: passwordValidator,
      onEditingComplete: () => _authBloc.oldPassFocus.unfocus(),
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
