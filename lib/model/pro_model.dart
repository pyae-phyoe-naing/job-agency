// Collection  => Doc => Data
// pro_exp     => userId => [ProModel,ProModel]

import 'package:cloud_firestore/cloud_firestore.dart';

class ProModel {
  final String name;
  final double level;
  final DateTime? createdAt;

  ProModel({required this.name, required this.level, this.createdAt});

  factory ProModel.fromDynamic(dynamic data) => ProModel(
      name: data['name'],
      level: double.parse(data['level'].toString()),
      createdAt: (data['created_at'] as Timestamp).toDate());

  Map<String, dynamic> toJson() =>
      {'name': name, 'level': level, 'created_at': createdAt ?? DateTime.now()};
}

class ProModelList {
  final String? id;
  final List<ProModel> proModelList;
  ProModelList(this.proModelList, [this.id]);

  factory ProModelList.fromJson(dynamic data) => ProModelList(
      (data['data'] as List).map((e) => ProModel.fromDynamic(e)).toList());
  factory ProModelList.fromJsonWithId(String id, dynamic data) => ProModelList(
      (data['data'] as List).map((e) => ProModel.fromDynamic(e)).toList(), id);
  Map<String, dynamic> toJson() =>
      {'data': proModelList.map((proModel) => proModel.toJson()).toList()};
}
