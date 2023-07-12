import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:job_agency/bloc/pro_exp/pro_exp_cubit.dart';
import 'package:job_agency/model/pro_model.dart';
import 'package:job_agency/utils/theme.dart';
import 'package:job_agency/widget/profile_components/pro_delete_dialog.dart';
import 'package:job_agency/widget/profile_components/pro_buttonsheet.dart';

class ProExpCard extends StatelessWidget {
  final ProModel proModel;
  final bool visitor;
  const ProExpCard({Key? key, required this.proModel, this.visitor = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Delete
      onLongPress: visitor == true
          ? null
          : () {
              showDialog(
                context: context,
                builder: (_) => BlocProvider(
                    create: (_) => ProExpCubit(),
                    child: ProDeleteDialog(proModel: proModel)),
              );
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
                    create: (context) => ProExpCubit(proModel),
                    child: const ProButtonSheet(
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
                  '${proModel.name} ✪',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: ThemeUtils.buttonColor),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: LinearProgressIndicator(
                      minHeight: 2,
                      value: proModel.level,
                    )),
                    const SizedBox(
                      width: 10,
                    ),
                    // Container(
                    //   width: width *0.7 ,
                    //   height: 3,
                    //   decoration: const BoxDecoration(
                    //     color: Colors.blue,
                    //     borderRadius: BorderRadius.all(Radius.circular(3),),
                    //   ),
                    //   child: Container(),
                    // ),
                    Text(
                      '${(proModel.level * 100).toInt()}%',
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
