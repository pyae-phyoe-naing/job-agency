import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_agency/bloc/pro_exp/watch_pro_exp_cubit.dart';
import 'package:job_agency/model/pro_model.dart';
import 'package:job_agency/model/worker_model.dart';
import 'package:job_agency/route/route.dart';
import 'package:starlight_utils/starlight_utils.dart';

import '../box/box.dart';

class WorkerCard extends StatelessWidget {
  final WorkerModel workerModel;
  const WorkerCard({Key? key, required this.workerModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, RouteName.workerDetail,
          arguments: workerModel),
      child: Container(
        color: Colors.white,
        margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: workerModel.photoURL != null
                  ? CachedNetworkImageProvider(workerModel.photoURL!)
                  : null,
              radius: 25,
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    workerModel.displayName?.isEmpty == true ||
                            workerModel.displayName == null
                        ? workerModel.email!.split("@").first
                        : workerModel.displayName!,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  BlocBuilder<WatchProExpCubit, List<ProModelList>>(
                      builder: (context, state) {
                   
                    ProModelList proModelListObj = state.firstWhere(
                        (element) => element.id == workerModel.docId,
                        orElse: () => ProModelList([]));
                    if (proModelListObj.proModelList.isEmpty) {
                      return const Box(
                        title: 'Empty',
                      );
                    }
                    return Wrap(
                        children: proModelListObj.proModelList
                            .map((pro) => Box(title: pro.name))
                            .toList());
                  }),
                  // StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  //     stream: firebaseHelper.watch(
                  //         collectionPath: 'pro-exp',
                  //         docPath: workerModel.docId),
                  //     builder: (context, snapshot) {
                  //       if (snapshot.connectionState ==
                  //           ConnectionState.waiting) {
                  //         return const LinearProgressIndicator(

                  //         );
                  //       }
                  //       if (snapshot.data?.data() == null) {
                  //         return const Box(
                  //           title: 'Empty',
                  //         );
                  //       }
                  //       DocumentSnapshot<Map<String, dynamic>>? data =
                  //           snapshot.data;
                  //       List<ProModel> proModelList =
                  //           ProModelList.fromJson(data?.data())
                  //               .proModelList
                  //               .toList();
                  //       return Wrap(
                  //           children: proModelList
                  //               .map((pro) => Box(title: pro.name))
                  //               .toList());
                  //     }),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    workerModel.city ?? 'Not Set',
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text('${workerModel.price.currencyFormat} Lakh',
                      style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          letterSpacing: 0.5)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
