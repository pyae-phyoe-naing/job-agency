import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_agency/bloc/auth/auth_bloc.dart';
import 'package:job_agency/bloc/create_job/create_job_post_cubit.dart';
import 'package:job_agency/bloc/home/view_manage_cubit.dart';
import 'package:job_agency/bloc/job_post/job_post_cubit.dart';
import 'package:job_agency/bloc/job_request/job_request_cubit.dart';
import 'package:job_agency/bloc/login/login_view_cubit.dart';
import 'package:job_agency/bloc/pro_exp/watch_pro_exp_cubit.dart';
import 'package:job_agency/bloc/worker/worker_cubit.dart';
import 'package:job_agency/global.dart';
import 'package:job_agency/model/job_post_model.dart';
import 'package:job_agency/model/request_job_model.dart';
import 'package:job_agency/model/worker_model.dart';

import 'package:job_agency/route/route.dart';
import 'package:job_agency/screen/email_change.dart';
import 'package:job_agency/screen/forgot_password.dart';
import 'package:job_agency/screen/home_screen.dart';
import 'package:job_agency/screen/job_post_detail_screen.dart';
import 'package:job_agency/screen/login_screen.dart';
import 'package:job_agency/screen/notification_screen.dart';
import 'package:job_agency/screen/password_change.dart';
import 'package:job_agency/screen/request_detail_screen.dart';
import 'package:job_agency/screen/setting_screen.dart';
import 'package:job_agency/screen/worker_detail_screen.dart';
import 'package:job_agency/screen/wrapper_screen.dart';
import 'package:job_agency/screen/create_job_post.dart';
import 'package:job_agency/screen/manage_applied_job.dart';
import 'package:job_agency/screen/manage_job_post.dart';
import 'package:starlight_utils/starlight_utils.dart';
import 'package:starlight_notification/starlight_notification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // FirebaseAuth.instance.signOut();
  await messagingRegister();
  await StarlightNotificationService.setup(
      onSelectNotification: (e) => StarlightUtils.pushNamed(RouteName.home));
  runApp(const MyApp());
}

Future<void> messagingRegister() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  //Requesting permission
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');
//Foreground messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');
    print('Title : ${message.notification!.title}');
    print('Body : ${message.notification!.body}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
      await StarlightNotificationService.show(
        StarlightNotification(
          title: message.notification?.title ?? '',
          body: message.notification?.body ?? '',
          payload: '{"name":"mg mg","age":20}',
        ),
      );
    }
  });

  // Background
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      child: const UnderMyApp(),
      create: (context) => AuthBloc(),
    );
  }
}

class UnderMyApp extends StatefulWidget {
  const UnderMyApp({super.key});

  @override
  State<UnderMyApp> createState() => _UnderMyAppState();
}

class _UnderMyAppState extends State<UnderMyApp> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthInitializeEvent());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: StarlightUtils.navigatorKey,
      onGenerateInitialRoutes: (_) => [
        RouteName.route(const WrapperScreen()),
      ],
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case RouteName.requestDetail:
            if (settings.arguments == null) {
              return RouteName.route(const ErrorPage());
            }
            return RouteName.route(MultiBlocProvider(
                providers: [
                  BlocProvider.value(value: workerCubit),
                  BlocProvider.value(value: jobRequestCubit),
                  BlocProvider.value(value: watchProExpCubit),
                  BlocProvider.value(value: watchWorkExpCubit),
                  BlocProvider.value(value: workExpCubit),
                  BlocProvider.value(value: jobRequestCubit),
                  BlocProvider.value(value: jobPostCubit),
                ],
                child: RequestDetailScreen(
                    requestModel: settings.arguments as RequestJobModel)));
          case RouteName.wrapper:
            return RouteName.route(BlocProvider(
              create: (context) => ViewManageCubit(),
              child: const WrapperScreen(),
            ));
          case RouteName.home:
            return RouteName.route(
              MultiBlocProvider(providers: [
                BlocProvider(create: (_) => ViewManageCubit()),
                BlocProvider.value(value: jobPostCubit),
                BlocProvider.value(value: workerCubit),
                BlocProvider.value(value: proExpCubit),
                BlocProvider.value(value: workExpCubit),
                BlocProvider(create: (_) => watchProExpCubit),
                BlocProvider(create: (_) => watchWorkExpCubit),
                BlocProvider.value(value: jobRequestCubit),
              ], child: const HomeScreen()),
            );
          case RouteName.login:
            return RouteName.route(BlocProvider(
              create: (context) => LoginViewCubit(),
              child: const LoginScreen(),
            ));
          case RouteName.setting:
            return RouteName.route(MultiBlocProvider(
              providers: [
                BlocProvider.value(value: jobRequestCubit),
                BlocProvider.value(value: jobPostCubit),
                BlocProvider.value(value: workerCubit),
                BlocProvider.value(value: watchProExpCubit),
                BlocProvider.value(value: watchWorkExpCubit),
              ],
              child: const SettingScreen(),
            ));
          case RouteName.emailChange:
            return RouteName.route(const EmailChange());
          case RouteName.passwordChange:
            return RouteName.route(const PasswordChange());
          case RouteName.forgotPassword:
            return RouteName.route(const ForgotPassword());
          case RouteName.createJob:
            return RouteName.route(BlocProvider(
              create: (context) => CreateJobPostCubit(),
              child: CreateJobPost(
                jobPostModel: settings.arguments == null
                    ? null
                    : settings.arguments as JobPostModel,
              ),
            ));
          case RouteName.jobPostDetail:
            if (settings.arguments == null) {
              return RouteName.route(const ErrorPage());
            }
            return RouteName.route(JobPostDetailScreen(
              jobPostModel: settings.arguments! as JobPostModel,
            ));
          case RouteName.manageJob:
            return RouteName.route(
              MultiBlocProvider(
                providers: [
                  BlocProvider.value(value: jobPostCubit),
                  BlocProvider.value(value: jobRequestCubit)
                ],
                child: const ManageJobPost(),
              ),
            );
          case RouteName.manageApplied:
            return RouteName.route(
              MultiBlocProvider(
                providers: [
                  BlocProvider.value(value: jobRequestCubit),
                  BlocProvider.value(value: jobPostCubit),
                  BlocProvider.value(value: workerCubit),
                  BlocProvider.value(value: proExpCubit),
                  BlocProvider.value(value: workExpCubit),
                ],
                child: const ManageAppliedJob(),
              ),
            );
          case RouteName.notification:
            return RouteName.route(
              MultiBlocProvider(
                providers: [
                  BlocProvider.value(value: jobRequestCubit),
                  BlocProvider.value(value: jobPostCubit),
                  BlocProvider.value(value: workerCubit),
                  BlocProvider.value(value: proExpCubit),
                  BlocProvider.value(value: workExpCubit),
                ],
                child: const NotificationScreen(),
              ),
            );
          case RouteName.workerDetail:
            if (settings.arguments == null) {
              return RouteName.route(const ErrorPage());
            }
            return RouteName.route(WorkerDetailScreen(
              workerModel: settings.arguments! as WorkerModel,
            ));
          default:
            return RouteName.route(const WrapperScreen());
        }
      },
    );
  }
}

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Error : No Data')),
    );
  }
}
