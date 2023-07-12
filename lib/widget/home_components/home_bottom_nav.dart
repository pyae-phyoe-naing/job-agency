import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_agency/bloc/home/view_manage_cubit.dart';
import 'package:job_agency/utils/theme.dart';

class AdminHomeBottomNav extends StatelessWidget {
  const AdminHomeBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _NavigationBox(
          iconData: Icons.home,
          index: 0,
        ),
        _NavigationBox(
          iconData: Icons.work,
          index: 1,
        ),
        _NavigationBox(
          iconData: Icons.category,
          index: 2,
        ),
        // _NavigationBox(
        //   iconData: Icons.phone,
        //   index: 3,
        // ),
        _NavigationBox(
          iconData: Icons.person,
          index: 3,
        ),
      ],
    );
  }
}

class HomeBottomNav extends StatelessWidget {
  const HomeBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _NavigationBox(
          iconData: Icons.home,
          index: 0,
        ),
        _NavigationBox(
          iconData: Icons.work,
          index: 1,
        ),
        // _NavigationBox(
        //   iconData: Icons.category,
        //   index: 2,
        // ),
        // _NavigationBox(
        //   iconData: Icons.phone,
        //   index: 3,
        // ),
        _NavigationBox(
          iconData: Icons.person,
          index: 2,
        ),
      ],
    );
  }
}

class _NavigationBox extends StatelessWidget {
  final int index;
  final IconData iconData;
  const _NavigationBox(
      {super.key, required this.iconData, required this.index});

  @override
  Widget build(BuildContext context) {
    final ViewManageCubit viewManageCubit = context.read<ViewManageCubit>();
    return BlocBuilder<ViewManageCubit, int>(
        //buildWhen: ((previous, current) => index == current),
        builder: (context, state) {
      return GestureDetector(
        onTap: () => viewManageCubit.animateTo(index),
        child: Container(
          margin: const EdgeInsets.only(bottom: 10, top: 10),
          width: MediaQuery.of(context).size.width / 6,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
            color: state == index ? ThemeUtils.bottomNavBg : Colors.white,
          ),
          child: Icon(
            iconData,
            size: 30,
            color: ThemeUtils.buttonColor,
          ),
        ),
      );
    });
  }
}
