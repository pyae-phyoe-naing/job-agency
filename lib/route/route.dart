import 'package:flutter/material.dart';

abstract class RouteName {
  static const String wrapper = '/wrapper';
  static const String home = '/home';
  static const String login = '/login';
  static const String setting = '/setting';
  static const String emailChange = '/email/change';
  static const String passwordChange = '/password/change';
  static const String forgotPassword = '/forgot/password';
  static const String createJob = '/create/job';
  static const String manageJob = '/manage/job';
  static const String notification = '/notification';
  static const String manageApplied = '/manage/applied';
  static const String workerDetail = '/worker/detail';
  static const String jobPostDetail = '/job/detail';
  static const String requestDetail = '/request/detail';

  static Route route(Widget widget) =>
      MaterialPageRoute(builder: (_) => widget);
}
