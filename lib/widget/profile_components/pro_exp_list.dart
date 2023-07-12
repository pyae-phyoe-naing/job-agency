import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_agency/bloc/auth/auth_bloc.dart';
import 'package:job_agency/global.dart';
import 'package:job_agency/model/pro_model.dart';
import 'package:job_agency/widget/profile_components/pro_exp_card.dart';

class ProExpList extends StatelessWidget {
  const ProExpList({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthBloc authBloc = context.read<AuthBloc>();
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: firebaseHelper.watch(
            collectionPath: 'pro-exp',
            docPath: authBloc.state.userModel?.user?.uid ?? ''),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.data?.data() == null) {
            return const SizedBox();
          }
          final ProModelList proObj = ProModelList.fromJson(
              snapshot.data?.data()); // change dynamic data to dart obj
          return Column(
            children: proObj.proModelList
                .map(
                  (e) => ProExpCard(proModel: e),
                )
                .toList(),
          );
        });
  }
}
