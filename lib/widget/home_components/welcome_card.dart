import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_agency/bloc/auth/auth_bloc.dart';
import 'package:job_agency/utils/theme.dart';

class WelcomeCard extends StatelessWidget {
  const WelcomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      child: Row(
        children: [
          BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
            return CircleAvatar(
              radius: 35,
              backgroundImage: state.userModel?.user?.photoURL != null
                  ? CachedNetworkImageProvider(
                      state.userModel?.user?.photoURL ?? '')
                  : null,
            );
          }),
          const SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome',
                style: TextStyle(
                    color: ThemeUtils.buttonColor, fontWeight: FontWeight.w400),
              ),
              const SizedBox(
                height: 5,
              ),
              BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
                return Text(
                  state.userModel?.user?.displayName ?? 'Username',
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 18),
                );
              }),
            ],
          )
        ],
      ),
    );
  }
}
