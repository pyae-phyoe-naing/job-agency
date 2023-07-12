import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_agency/bloc/work_exp/work_exp_cubit.dart';
import 'package:job_agency/model/work_model.dart';
import 'package:job_agency/utils/theme.dart';
import 'package:job_agency/widget/profile_components/work_buttonsheet.dart';
import 'package:job_agency/widget/profile_components/work_delete_dialog.dart';

class WorkExpCard extends StatelessWidget {
  final WorkModel workModel;
   final bool visitor;
  const WorkExpCard({super.key, required this.workModel,this.visitor=false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: visitor == true
          ? null
          : () {
        showDialog(
            context: context,
            builder: (context) => BlocProvider(
                  create: (context) => WorkExpCubit(workModel),
                  child: const WorkDeleteDialog(),
                ));
      },
      // Update
       onTap: visitor == true
          ? null
          : () {
        showModalBottomSheet(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          context: context,
          builder: (_) => BlocProvider(
              create: (context) => WorkExpCubit(workModel),
              child: const WorkButtonSheet(
                isUpdate: true,
              )),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: 60,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  workModel.title,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: ThemeUtils.buttonColor),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      workModel.subTitle,
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: ThemeUtils.buttonColor),
                    ),
                    Text(
                      workModel.createdAt
                          .toString()
                          .split(' ')
                          .last
                          .substring(0, 5),
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: ThemeUtils.buttonColor),
                    ),
                  ],
                )
              ]),
        ),
      ),
    );
  }
}
