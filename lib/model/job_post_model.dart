import 'package:cloud_firestore/cloud_firestore.dart';

class JobPostModel {
  final String id;
  final String title;
  final String photo;
  final String desc;
  final double salary;
  final List requirement;
  final List views;
  final List? likes;
  final String status;
  final String phone;
  final String email;
  final DateTime? createdAt;
  JobPostModel(
      {this.id = '',
      this.likes,
      this.createdAt,
      required this.title,
      required this.photo,
      required this.desc,
      required this.salary,
      required this.requirement,
      required this.views,
      required this.status,
      required this.phone,
      required this.email});

  Map<String, dynamic> toJson() => {
        'title': title,
        'desc': desc,
        'photo': photo,
        'salary': salary,
        'requirement': requirement,
        'views': views,
        'likes': likes,
        'status': status,
        'phone': phone,
        'email': email,
        'createdAt': createdAt ?? DateTime.now()
      };

  factory JobPostModel.fromJson(String id, dynamic data) => JobPostModel(
        id: id,
        title: data['title'],
        photo: data['photo'],
        desc: data['desc'],
        salary: double.parse(data['salary'].toString()),
        requirement: data['requirement'] as List,
        views: data['views'] as List,
        //likes:data['likes'] == null ? null : data['likes'] as List?,
        likes: data['likes'] as List?,
        status: data['status'],
        phone: data['phone'],
        email: data['email'],
        // createdAt: data['createdAt'] == null
        //     ? null
        //     : (data['createdAt'] as Timestamp).toDate(),
        createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      );

  JobPostModel addView(String viewrId) {
    List viewers = views.toList();
    viewers.add(viewrId);
    return JobPostModel(
        title: title,
        photo: photo,
        desc: desc,
        salary: salary,
        requirement: requirement,
        views: viewers,
        likes: likes,
        status: status,
        phone: phone,
        email: email,
        createdAt: createdAt);
  }

  JobPostModel addLike(String likerId) {
    List likers = likes?.toList() ?? [];

    likers.add(likerId);

    return JobPostModel(
        title: title,
        photo: photo,
        desc: desc,
        salary: salary,
        requirement: requirement,
        views: views,
        likes: likers,
        status: status,
        phone: phone,
        email: email,
        createdAt: createdAt);
  }
}
