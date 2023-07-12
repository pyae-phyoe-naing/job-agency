import 'package:cloud_firestore/cloud_firestore.dart';

class RequestJobModel {
  final String id;
  final String workerId;
  final String jobId;
  final String? message;
  final int status; // 1 for waiting , 2 for accept , 3 for reject
  final List? view;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  RequestJobModel(
      {this.id = "",
      this.view,
      required this.workerId,
      required this.jobId,
      this.status = 1,
      this.message,
      this.createdAt,
      this.updatedAt});

  RequestJobModel notiView(String id) {
    final viewsList = (view ?? []).toList();
    viewsList.add(id);
    return RequestJobModel(
        workerId: workerId,
        jobId: jobId,
        view: viewsList,
        message: message,
        status: status,
        createdAt: createdAt,
        updatedAt: updatedAt);
  }

  copyWith({required int status, String? message, List? view}) =>
      RequestJobModel(
          id: id,
          workerId: workerId,
          jobId: jobId,
          message: message ?? this.message,
          view: view ?? this.view,
          status: status,
          createdAt: createdAt,
          updatedAt: updatedAt);

  factory RequestJobModel.fromJson(String id, dynamic data) => RequestJobModel(
        id: id,
        workerId: data['workerId'],
        jobId: data['jobId'],
        view: data['view'] as List?,
        message: data['message'] as String?,
        status: int.parse(data['status'].toString()),
        createdAt: (data['createdAt'] as Timestamp).toDate(),
        updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      );
  factory RequestJobModel.fromRouteArg(String id, dynamic data) =>
      RequestJobModel(
        id: data['id'],
        workerId: data['workerId'],
        jobId: data['jobId'],
        view: data['view'] as List?,
        message: data['message'] as String?,
        status: int.parse(data['status'].toString()),
        createdAt: (data['createdAt'] as Timestamp).toDate(),
        updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      );

  Map<String, dynamic> toStoreFirebase() => {
        'workerId': workerId,
        'jobId': jobId,
        'message': message,
        'status': status,
        'view': view,
        'createdAt': createdAt ?? DateTime.now(),
        'updatedAt': updatedAt ?? DateTime.now(),
      };

  Map<String, dynamic> toRouteArg() => {
        'id': id,
        'workerId': workerId,
        'jobId': jobId,
        'message': message,
        'view': view,
        'status': status,
        'createdAt': createdAt ?? DateTime.now(),
        'updatedAt': updatedAt ?? DateTime.now(),
      };
}
