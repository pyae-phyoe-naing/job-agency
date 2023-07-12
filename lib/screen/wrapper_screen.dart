import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_agency/bloc/auth/auth_bloc.dart';
import 'package:job_agency/route/route.dart';

class WrapperScreen extends StatefulWidget {
  const WrapperScreen({super.key});

  @override
  State<WrapperScreen> createState() => _WrapperScreenState();
}

class _WrapperScreenState extends State<WrapperScreen> {
  late final AuthBloc _authBloc = context.read<AuthBloc>();
  @override
  void initState() {
    super.initState();
    _authBloc.resetGlobalKey();

    checkState();
  }

  checkState() {
    // print("Wrapper State is ${_authBloc.state}");
    // print("Wrapper State is ${_authBloc.state.userModel}");
    Future.delayed(const Duration(milliseconds: 200), () {
      if (_authBloc.state is AuthSuccessState) {
        Navigator.pushNamed(context, RouteName.home);
      } else if (_authBloc.state is LogoutState) {
        Navigator.pushReplacementNamed(context, RouteName.login);
      } else {
        checkState();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
