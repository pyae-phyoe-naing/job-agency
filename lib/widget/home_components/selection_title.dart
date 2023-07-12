import 'package:flutter/material.dart';
import 'package:job_agency/utils/theme.dart';

class SelectionTitle extends StatelessWidget {
  final String title;
  final EdgeInsetsGeometry? padding;
  final void Function()? onPressed;
  final Widget? extraWidget;

  const SelectionTitle(
      {super.key,
      required this.title,
      required this.onPressed,
      this.padding,
      this.extraWidget});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ThemeUtils.buttonColor),
          ),
          extraWidget != null
              ? extraWidget!
              : TextButton(onPressed: onPressed, child: const Text(''))
        ],
      ),
    );
  }
}
