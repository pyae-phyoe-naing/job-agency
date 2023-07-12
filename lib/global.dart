import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:job_agency/bloc/auth/auth_bloc.dart';
import 'package:job_agency/bloc/job_post/job_post_cubit.dart';
import 'package:job_agency/bloc/job_request/job_request_cubit.dart';
import 'package:job_agency/bloc/pro_exp/pro_exp_cubit.dart';
import 'package:job_agency/bloc/pro_exp/watch_pro_exp_cubit.dart';
import 'package:job_agency/bloc/work_exp/watch_work_exp_cubit.dart';
import 'package:job_agency/bloc/work_exp/work_exp_cubit.dart';
import 'package:job_agency/bloc/worker/worker_cubit.dart';
import 'package:job_agency/model/user_model.dart';
import 'package:job_agency/services/database.dart';

final FirebaseHelper firebaseHelper = FirebaseHelper();
final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final ImagePicker imagePicker = ImagePicker();
final JobRequestCubit jobRequestCubit = JobRequestCubit();
final ProExpCubit proExpCubit = ProExpCubit();
final WorkExpCubit workExpCubit = WorkExpCubit();
final JobPostCubit jobPostCubit = JobPostCubit();
final WorkerCubit workerCubit = WorkerCubit();
final WatchProExpCubit watchProExpCubit = WatchProExpCubit();
final WatchWorkExpCubit watchWorkExpCubit = WatchWorkExpCubit();

void userDataChange(AuthBloc authBloc) {
  FirebaseAuth.instance.userChanges().listen((User? user) async {
    if (user != null) {
      final UserModel userModel = UserModel(
          user: user,
          cloudMessageToken: authBloc.state.userModel?.cloudMessageToken,
          role: authBloc.state.userModel?.role ?? 'user',
          city: authBloc.state.userModel?.city,
          price: authBloc.state.userModel?.price ?? 0);
      authBloc.add(
        AuthListnerEvent(userModel),
      );
      //If User data change  :  update also firesotre userData
      if (user.displayName != authBloc.state.userModel?.user?.displayName ||
          user.email != authBloc.state.userModel?.user?.email ||
          user.photoURL != authBloc.state.userModel?.user?.photoURL) {
        await firebaseHelper.update(
            collectionPath: 'users',
            docPath: user.uid,
            data: userModel.toUpdate());
      }
    }
  });
}
