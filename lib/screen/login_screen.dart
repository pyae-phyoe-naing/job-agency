import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:job_agency/bloc/auth/auth_bloc.dart';
import 'package:job_agency/bloc/login/login_view_cubit.dart';
import 'package:job_agency/route/route.dart';
import 'package:job_agency/utils/helper.dart';
import 'package:job_agency/utils/theme.dart';
import 'package:job_agency/widget/login_components/login_password_input.dart';
import 'package:job_agency/widget/login_components/login_status_bar.dart';
import 'package:job_agency/widget/login_components/register_password_input.dart';

import 'package:starlight_utils/starlight_utils.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LoginViewCubit loginViewCubit = context.read<LoginViewCubit>();
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: context.width > 300 ? 300 : context.width - 20,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                    border: Border.all(color: Colors.black26),
                  ),
                  // padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                  child: const Row(
                    children: [
                      Expanded(
                        child: LoginStatusBar(
                          currentIndex: 0,
                        ),
                      ),
                      Expanded(
                        child: LoginStatusBar(
                          currentIndex: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 30),
                  height: 400,
                  child: BlocConsumer<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is UserCancelState) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Please Login Now !'),
                          backgroundColor: Colors.redAccent,
                        ));
                      }
                      if (state is AuthErrorState) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(
                                  loginViewCubit.state == 0
                                      ? 'Login Fail'
                                      : 'Register Fail',
                                  style: const TextStyle(
                                    fontSize: 17,
                                  ),
                                ),
                                content: Text(
                                  state.message,
                                  style: const TextStyle(fontSize: 16),
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Ok'))
                                ],
                              );
                            });
                      }
                    },
                    builder: (context, state) {
                      return PageView.builder(
                          controller: loginViewCubit.controller,
                          itemCount: 2,
                          onPageChanged: loginViewCubit.animateTo,
                          itemBuilder: (context, index) {
                            return const [_loginForm(), _registerForm()][index];
                          });
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _loginForm extends StatelessWidget {
  const _loginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthBloc authBloc = context.read<AuthBloc>();
    authBloc.resetGlobalKey();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        key: authBloc.loginForm,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: authBloc.loginEmaiController,
              focusNode: authBloc.loginEmailFocus,
              onEditingComplete: authBloc.loginPasswordFocus.requestFocus,
              validator: emailValidator,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: ThemeUtils.inputDec.copyWith(
                  prefixIcon: const Icon(Icons.alternate_email),
                  hintText: 'Email'),
            ),
            const SizedBox(
              height: 15,
            ),
            const LoginPasswordInput(),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                InkWell(
                    onTap: () =>
                        Navigator.pushNamed(context, RouteName.forgotPassword),
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.blue),
                    )),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 45,
              child: ElevatedButton(
                onPressed: () {
                  authBloc.add(LoginWithEmailEvent());
                },
                child: BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) => state is LoginLoadingState
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Login',
                          )),
              ),
            ),
            const OrDivider(),
            const _LoginWithGoogle(),
          ],
        ),
      ),
    );
  }
}

class _registerForm extends StatelessWidget {
  const _registerForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthBloc authBloc = context.read<AuthBloc>();
    authBloc.resetGlobalKey();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        key: authBloc.registerForm,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              validator: emailValidator,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: authBloc.registerEmaiController,
              focusNode: authBloc.registerEmailFocus,
              onEditingComplete: authBloc.registerPasswordFocus.requestFocus,
              decoration: ThemeUtils.inputDec.copyWith(
                  hintText: 'Email',
                  prefixIcon: const Icon(Icons.alternate_email)),
            ),
            const SizedBox(
              height: 10,
            ),
            const RegisterPasswordInput(),
            const SizedBox(
              height: 10,
            ),
            const RegisterConfirmPasswordInput(),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 45,
              child: ElevatedButton(
                onPressed: () {
                  authBloc.add(RegisterWithEmailEvent());
                },
                child: BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) => state is RegisterLoadingState
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Register',
                          )),
              ),
            ),
            const OrDivider(),
            const _LoginWithGoogle()
          ],
        ),
      ),
    );
  }
}

class _LoginWithGoogle extends StatelessWidget {
  const _LoginWithGoogle({super.key});

  @override
  Widget build(BuildContext context) {
    AuthBloc authBloc = context.read<AuthBloc>();
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return state is GoogleLoadingState
            ? const Center(child: CircularProgressIndicator())
            : SizedBox(
                height: 48,
                child: OutlinedButton.icon(
                    onPressed: () {
                      authBloc.add(LoginWithGoogleEvent());
                    },
                    icon: const FaIcon(FontAwesomeIcons.google),
                    label: const Text('Login With Google')),
              );
      },
    );
  }
}

// class _LoginWithFacdbook extends StatelessWidget {
//   const _LoginWithFacdbook({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     AuthBloc authBloc = context.read<AuthBloc>();
//     return SizedBox(
//       height: 48,
//       child: OutlinedButton.icon(
//           onPressed: () {
//             authBloc.add(LoginWithGoogleEvent());
//           },
//           icon: const FaIcon(FontAwesomeIcons.facebook),
//           label: const Text('Login With Facebook')),
//     );
//   }
// }

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
              child: Container(
            margin: const EdgeInsets.only(right: 10),
            height: 1,
            color: Colors.grey,
          )),
          const Text('OR'),
          Expanded(
              child: Container(
            margin: const EdgeInsets.only(left: 10),
            height: 1,
            color: Colors.grey,
          )),
        ],
      ),
    );
  }
}
