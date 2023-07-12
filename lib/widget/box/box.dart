import 'package:flutter/material.dart';
import 'package:job_agency/utils/theme.dart';

class Box extends StatelessWidget {
  final String title;
  final TextStyle? style;

  const Box({super.key, required this.title, this.style});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6.5, vertical: 4),
      margin: const EdgeInsets.only(right: 5),
      decoration: const BoxDecoration(
        color: ThemeUtils.bottomNavBg,
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: style ??
            const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                letterSpacing: 1,
                color: ThemeUtils.buttonColor),
      ),
    );
  }
}
