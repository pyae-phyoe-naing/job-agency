import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_agency/bloc/login/login_view_cubit.dart';

class LoginStatusBar extends StatelessWidget {
  final int currentIndex;
  const LoginStatusBar({Key? key,required this.currentIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LoginViewCubit loginViewCubit = context.read<LoginViewCubit>();
    return BlocBuilder<LoginViewCubit,int>(
      builder: (context, state) {
        return GestureDetector(
          onTap: (){
            loginViewCubit.animateTo(currentIndex);
          },
          child: Container(
            decoration: BoxDecoration(
                borderRadius:currentIndex == 0 ?  const BorderRadius.only(
                 topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ) : const BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                color: state == currentIndex ? Colors.blue : Colors.white),
            alignment: Alignment.center,
            child: Text(
              currentIndex == 0 ? 'Login' : 'Register',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color:
                  state == currentIndex ? Colors.white : Colors.black),
            ),
          ),
        );
      },
    );
  }
}
