import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:job_agency/global.dart';
import 'package:job_agency/model/pro_model.dart';
import 'package:job_agency/model/work_model.dart';
import 'package:job_agency/model/worker_model.dart';
import 'package:job_agency/utils/theme.dart';
import 'package:job_agency/widget/profile_components/pro_exp_card.dart';
import 'package:job_agency/widget/profile_components/work_exp_card.dart';
import 'package:starlight_utils/starlight_utils.dart';

class _MultiStream {
  ProModelList proModelList;
  WorkModelList workModelList;
  _MultiStream(this.proModelList, this.workModelList);

  _MultiStream copyWith(
          {ProModelList? proModelList, WorkModelList? workModelList}) =>
      _MultiStream(proModelList ?? this.proModelList,
          workModelList ?? this.workModelList);
}

class WorkerDetailScreen extends StatefulWidget {
  final WorkerModel workerModel;
  const WorkerDetailScreen({super.key, required this.workerModel});

  @override
  State<WorkerDetailScreen> createState() => _WorkerDetailScreenState();
}

class _WorkerDetailScreenState extends State<WorkerDetailScreen> {
  // First Stream
  late final Stream<DocumentSnapshot<Map<String, dynamic>>> _proStream =
      firebaseHelper.watch(
          collectionPath: 'pro-exp', docPath: widget.workerModel.docId);
  // Second Stream
  late final Stream<DocumentSnapshot<Map<String, dynamic>>> _workStream =
      firebaseHelper.watch(
          collectionPath: 'work-exp', docPath: widget.workerModel.docId);

  _MultiStream? _multiStream;
  
  // Create Stream Controller Broadcast
  final StreamController<_MultiStream> _controller =
      StreamController.broadcast();

  @override
  void initState() {
    super.initState();
    // --------Listen Pro Stream-----------//
    _proStream.listen((event) {
      if (event.data() != null) {
        if (_multiStream == null) {
          _multiStream = _MultiStream(ProModelList.fromJson(event.data()),
              WorkModelList(workModelList: []));
          _controller.sink.add(_multiStream!);
        } else {
          _multiStream = _multiStream!
              .copyWith(proModelList: ProModelList.fromJson(event.data()));
          _controller.sink.add(_multiStream!);
        }
      }
    });
    // -------- Listen Work Stream-----------//
    _workStream.listen((event) {
      if (event.data() != null) {
        if (_multiStream == null) {
          _multiStream = _MultiStream(
              ProModelList([]), WorkModelList.fromJson(event.data()));
          _controller.sink.add(_multiStream!);
        } else {
          _multiStream = _multiStream!
              .copyWith(workModelList: WorkModelList.fromJson(event.data()));
          _controller.sink.add(_multiStream!);
        }
      }
    });
  }

  @override
  void dispose() {
    _multiStream = null;
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<_MultiStream>(
        stream: _controller.stream,
        builder: (context, snapshot) {
          final ProModelList proModelList =
              snapshot.data?.proModelList ?? ProModelList([]);
          final WorkModelList workModelList =
              snapshot.data?.workModelList ?? WorkModelList(workModelList: []);
          return ListView(children: [
            UserAccountsDrawerHeader(
              //decoration:  BoxDecoration(color: Colors.blue.shade50),
              otherAccountsPicturesSize: const Size(50, 30),
              otherAccountsPictures: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Back',
                    maxLines: 1,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
              currentAccountPicture: CircleAvatar(
                  backgroundImage: widget.workerModel.photoURL != null
                      ? CachedNetworkImageProvider(widget.workerModel.photoURL!)
                      : null),
              accountName: Text(
                widget.workerModel.displayName ??
                    widget.workerModel.email!.split('@').first,
                style: const TextStyle(color: Colors.white),
              ),
              accountEmail: Text(
                widget.workerModel.email ?? 'example@com',
                style: const TextStyle(color: Colors.white),
              ),
            ),

            //  ----------------  StreamBuilder Pro Data ---------
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Text(
                'Pro Experience',
                style: TextStyle(
                    color: ThemeUtils.buttonColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
            for (var pro in proModelList.proModelList) ...[
              ProExpCard(
                proModel: pro,
                visitor: true,
              ),
            ],
            //  ----------------  StreamBuilder Work Exp Data ---------
            Container(
              margin: const EdgeInsets.only(bottom: 10, top: 20),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Text(
                'Working Experience',
                style: TextStyle(
                    color: ThemeUtils.buttonColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
            for (var work in workModelList.workModelList) ...[
              WorkExpCard(workModel: work, visitor: true),
            ],
            Container(
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Icon(Icons.location_on),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    widget.workerModel.city ?? "Not Set",
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: ThemeUtils.buttonColor),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Icon(Icons.money),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    "${widget.workerModel.price.currencyFormat} MMk",
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: ThemeUtils.buttonColor),
                  )
                ],
              ),
            ),
          ]);
        },
      ),
    );
  }
}
