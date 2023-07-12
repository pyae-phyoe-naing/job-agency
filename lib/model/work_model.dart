import 'package:cloud_firestore/cloud_firestore.dart';

class WorkModel {
  final String title;
  final String subTitle;
  final DateTime? createdAt;
  WorkModel({required this.title, required this.subTitle, this.createdAt});

// Change DartModel from Json(Dynamic Data)
  factory WorkModel.fromJson(dynamic data) => WorkModel(
      title: data['title'],
      subTitle: data['subTitle'],
      createdAt: (data['created_at'] as Timestamp).toDate());

// Change Json from DartModel to save Database or Firebase
  Map<String, dynamic> toJson() => {
        'title': title,
        'subTitle': subTitle,
        'created_at': createdAt ?? DateTime.now()
      };
}

class WorkModelList {
  String? id;
  final List<WorkModel> workModelList;
  WorkModelList({required this.workModelList, this.id});

  factory WorkModelList.fromJson(dynamic data) => WorkModelList(
      workModelList: (data['work-exp-list'] as List)
          .map((workModel) => WorkModel.fromJson(workModel))
          .toList());
  factory WorkModelList.fromJsonWithId(String id, dynamic data) =>
      WorkModelList(
          id: id,
          workModelList: (data['work-exp-list'] as List)
              .map((workModel) => WorkModel.fromJson(workModel))
              .toList());
  Map<String, dynamic> toJson() => {
        'work-exp-list':
            workModelList.map((workModel) => workModel.toJson()).toList()
      };
}
