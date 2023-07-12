import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:job_agency/global.dart';
import 'package:job_agency/model/user_model.dart';
import 'package:job_agency/route/route.dart';
import 'package:job_agency/services/database.dart';
import 'package:meta/meta.dart';
import 'package:starlight_utils/starlight_utils.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _authInstance = FirebaseAuth.instance;
  final FirebaseHelper _firebaseHelper = FirebaseHelper();
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  GlobalKey<FormState>? loginForm = GlobalKey<FormState>();
  final TextEditingController loginEmaiController = TextEditingController();
  final TextEditingController loginPassController = TextEditingController();
  final FocusNode loginEmailFocus = FocusNode();
  final FocusNode loginPasswordFocus = FocusNode();

  GlobalKey<FormState>? registerForm = GlobalKey<FormState>();
  final TextEditingController registerEmaiController = TextEditingController();
  final TextEditingController registerPassController = TextEditingController();
  final TextEditingController registerConfirmPassController =
      TextEditingController();
  final FocusNode registerEmailFocus = FocusNode();
  final FocusNode registerPasswordFocus = FocusNode();
  final FocusNode registerConfirmPasswordFocus = FocusNode();

  GlobalKey<FormState>? passChangeForm = GlobalKey<FormState>();
  final TextEditingController currPassController = TextEditingController();
  final TextEditingController newPassController = TextEditingController();
  final TextEditingController conPassController = TextEditingController();
  final FocusNode curPassFocus = FocusNode();
  final FocusNode newPassFocus = FocusNode();
  final FocusNode conPassFocus = FocusNode();

  GlobalKey<FormState>? emailChangeForm = GlobalKey<FormState>();
  final TextEditingController newEmailController = TextEditingController();
  final TextEditingController oldPassController = TextEditingController();
  final FocusNode newEmailFocus = FocusNode();
  final FocusNode oldPassFocus = FocusNode();

  AuthBloc() : super(AuthInitialState()) {
    on<RegisterWithEmailEvent>(_registerWithEmail);
    on<LoginWithEmailEvent>(_loginWithEmail);
    on<LoginWithGoogleEvent>(_loginWithGoogle);

    // App Loading
    // App run check
    on<AuthInitializeEvent>(_onInitial);
    on<AuthListnerEvent>(
      (event, emit) {
        // print('Listener ${event.userModel}');
        if (event.userModel?.user == null || event.userModel == null) {
          emit(LogoutState());
        } else {
          emit(AuthSuccessState(event.userModel!));
        }
      },
    );
    // Logout
    on<LogoutEvent>(_logout);

    // Change Password
    on<ChangePasswordEvent>(_changePassword);

    // Change Email
    on<ChangeEmailEvent>(_changeEmail);
  }

  Future<void> _tokenReset(UserModel userModel) async {
    _firebaseHelper.update(
        collectionPath: 'users',
        docPath: userModel.user!.uid,
        data: UserModel(
                cloudMessageToken: null,
                price: userModel.price,
                user: userModel.user,
                role: userModel.role,
                city: userModel.city)
            .toUpdate());
    await _messaging.deleteToken();
    resetGlobalKey();
  }

  Future<void> _afterAuth(User user, Emitter<AuthState> emit) async {
    DocumentSnapshot<Map<String, dynamic>> data =
        await _firebaseHelper.read(collectionPath: 'users', docPath: user.uid);
    final String? messageToken = await _messaging.getToken();

    if (data.data() != null) {
      // Exist User
      // Update Token
      // print('exist user =======${user}');
      // print("price ===== ${data.data()!['price']}");
      add(
        AuthListnerEvent(
          UserModel(
              user: user,
              cloudMessageToken: messageToken,
              price: double.parse(data.data()!['price'].toString()),
              role: data.data()!['role'],
              city: data.data()!['city']),
        ),
      );
      await _firebaseHelper.update(
          collectionPath: 'users',
          docPath: user.uid,
          data: UserModel(
                  user: user,
                  cloudMessageToken: messageToken,
                  price: double.parse(data.data()!['price'].toString()),
                  role: data.data()!['role'],
                  city: data.data()!['city'])
              .toUpdate());
    } else {
      // Register New User
      await _firebaseHelper.create(
          collectionPath: 'users',
          docPath: user.uid,
          data:
              UserModel(user: user, cloudMessageToken: messageToken).toJson());
      add(
        AuthListnerEvent(
          UserModel(
            user: user,
            cloudMessageToken: messageToken,
          ),
        ),
      );
    }
  }

  resetGlobalKey() {
    loginForm = null;
    loginForm = GlobalKey();
    registerForm = null;
    registerForm = GlobalKey();
    passChangeForm = null;
    passChangeForm = GlobalKey();
    emailChangeForm = null;
    emailChangeForm = GlobalKey();
  }

  //-------Register With Email
  Future<void> _registerWithEmail(
      RegisterWithEmailEvent event, Emitter<AuthState> emit) async {
    registerConfirmPasswordFocus.unfocus();
    if (registerForm?.currentState?.validate() != true) return;
    emit(RegisterLoadingState());

    try {
      final UserCredential credential =
          await _authInstance.createUserWithEmailAndPassword(
              email: registerEmaiController.text,
              password: registerPassController.text);
      StarlightUtils.pushReplacementNamed(RouteName.wrapper);

      if (credential.user != null) {
        await _afterAuth(credential.user!, emit);
      } else {
        emit(const AuthErrorState('Unknown Error'));
      }
      registerEmaiController.clear();
      registerPassController.clear();
      registerConfirmPassController.clear();
    } on FirebaseAuthException catch (e) {
      emit(AuthErrorState(e.message ?? e.code));
    } catch (e) {
      emit(AuthErrorState(e.toString()));
    }
  }

  //--------Login With Email
  Future<void> _loginWithEmail(
      LoginWithEmailEvent event, Emitter<AuthState> emit) async {
    loginPasswordFocus.unfocus();
    if (loginForm?.currentState?.validate() != true) return;
    emit(LoginLoadingState());
    try {
      final UserCredential credential =
          await _authInstance.signInWithEmailAndPassword(
              email: loginEmaiController.text,
              password: loginPassController.text);
      StarlightUtils.pushReplacementNamed(RouteName.wrapper);

      if (credential.user != null) {
        
        await _afterAuth(credential.user!, emit);
      } else {
        emit(const AuthErrorState('Unknown Error'));
      }
      loginEmaiController.clear();
      loginPassController.clear();
    } on FirebaseAuthException catch (e) {
      emit(AuthErrorState(e.message ?? e.code));
    } catch (e) {
      emit(AuthErrorState(e.toString()));
    }
  }

  //--------Login With Google
  Future<void> _loginWithGoogle(
      LoginWithGoogleEvent event, Emitter<AuthState> emit) async {
    emit(GoogleLoadingState());
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      final UserCredential loginCredential =
          await _authInstance.signInWithCredential(credential);
      StarlightUtils.pushReplacementNamed(RouteName.wrapper);

      if (loginCredential.user != null) {
        // -----Check user exist in firestore-----

        await _afterAuth(loginCredential.user!, emit);
      } else {
        emit(const AuthErrorState('Unknown Error'));
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthErrorState(e.message ?? e.code));
    } catch (e) {
      emit(UserCancelState());
    }
  }

  // Checking State Login or Logout
  void _onInitial(AuthInitializeEvent event, Emitter<AuthState> emit) {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user != null) {
        _afterAuth(user, emit);

        // final DocumentSnapshot<Map<String, dynamic>> data =
        //     await _firebaseHelper.read(
        //         collectionPath: 'users', docPath: user.uid);
        // if (data.data() != null) {

        // Before Already login
        // add(
        //   AuthListnerEvent(
        //     UserModel(
        //       user: user,
        //       cloudMessageToken: data.data()!['cloudMessageToken'],
        //       role: data.data()!['role'],
        //       price: double.parse(data.data()!['price'].toString()),
        //     ),
        //   ),
        // );
        //  } else {
        // Before not login (or) Register
        //   final String? messageToken = await _messaging.getToken();

        //   _firebaseHelper.create(
        //       collectionPath: 'users',
        //       docPath: user.uid,
        //       data: UserModel(user: user, cloudMessageToken: messageToken)
        //           .toJson());

        //   add(
        //     AuthListnerEvent(
        //       UserModel(
        //           user: user, cloudMessageToken: messageToken, role: 'user'),
        //     ),
        //   );
        // }
        // ----------- Watch User Data --------- //
        // firebaseHelper
        //     .watch(collectionPath: 'users', docPath:user.uid)
        //     .listen((event) {
        //   if (event.data() != null) {
        //     final double price = double.parse(event.data()!['price'].toString());
        //     final String token = event.data()!['cloudMessageToken'];
        //     final String role = event.data()!['role'];

        //     if (price != state.userModel?.price ||
        //         token != state.userModel?.cloudMessageToken ||
        //         role != state.userModel?.role) {
        //       final UserModel userModel = UserModel(
        //           user: state.userModel?.user,
        //           cloudMessageToken: token,
        //           role: role,
        //           price: price);
        //       add(AuthListnerEvent(userModel));
        //     }
        //   }
        // });

        //   } else {
        //     add(AuthListnerEvent(UserModel()));

        // -----------User Data Change
        FirebaseAuth.instance.userChanges().listen((User? user) async {
          if (user != null) {
            DocumentSnapshot<Map<String, dynamic>> data = await firebaseHelper
                .read(collectionPath: 'users', docPath: user.uid);
            if (data.data() != null) {
              final UserModel userModel = UserModel(
                  user: user,
                  cloudMessageToken: data.data()!['cloudMessageToken'],
                  price: data.data()!['price'],
                  role: data.data()!['role'],
                  city: data.data()!['city']);
              add(
                AuthListnerEvent(userModel),
              );
              //If User data change  :  update also firesotre userData
              if (user.displayName != state.userModel?.user?.displayName ||
                  user.email != state.userModel?.user?.email ||
                  user.photoURL != state.userModel?.user?.photoURL) {
                await firebaseHelper.update(
                    collectionPath: 'users',
                    docPath: user.uid,
                    data: userModel.toUpdate());
              }
            }
          }
        });
      } else {
        StarlightUtils.pushNamed(RouteName.login);
      }
    }); // auth change
  } // main close

  // -------- Change Password
  Future<void> _changePassword(
      ChangePasswordEvent event, Emitter<AuthState> emit) async {
    final UserModel? userModel = state.userModel;
    if (passChangeForm?.currentState?.validate() == true && userModel != null) {
      emit(AuthChangePassSuccessState(userModel));
      try {
        // First Login
        final UserCredential userCredential =
            await firebaseAuth.signInWithEmailAndPassword(
                email: userModel.user!.email!,
                password: currPassController.text);
        if (userCredential.user != null) {
          await userCredential.user!.updatePassword(newPassController.text);
        }
        StarlightUtils.snackbar(
          const SnackBar(
            content: Text('Change password success!'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        emit(AuthErrorState(e.toString(), userModel: userModel));
        // ToDo
        StarlightUtils.snackbar(
          const SnackBar(
            content: Text('Current password is incorrect'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // -------- Change Email
  Future<void> _changeEmail(
      ChangeEmailEvent event, Emitter<AuthState> emit) async {
    final UserModel? userModel = state.userModel;
    if (emailChangeForm?.currentState?.validate() == true &&
        userModel != null) {
      emit(AuthChangeEmailLoadingState());
      try {
        final UserCredential userCredential =
            await firebaseAuth.signInWithEmailAndPassword(
                email: userModel.user!.email!,
                password: oldPassController.text);
        if (userCredential.user != null) {
          await userCredential.user!.updateEmail(newEmailController.text);
          StarlightUtils.snackbar(
            const SnackBar(
              content: Text('Change email success!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        emit(AuthErrorState(e.toString(), userModel: userModel));
        // ToDo
        StarlightUtils.snackbar(
          const SnackBar(
            content: Text('Current password is incorrect'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  //------- Logout
  Future<void> _logout(LogoutEvent event, Emitter<AuthState> emit) async {
    if (state is AuthLoadingState) return;
    UserModel? userModel = state.userModel;
    if (userModel == null) return;
    User? user = state.userModel?.user;
    if (user == null) return;
    try {
      emit(AuthLoadingState());

      switch (user.providerData[0].providerId) {
        case "google.com":
          await Future.wait(event.task);
          await _tokenReset(userModel);
          await GoogleSignIn().signOut();
          await _authInstance.signOut();

          break;
        default:
          await Future.wait(event.task);

          await _tokenReset(userModel);
          await _authInstance.signOut();
      }

      StarlightUtils.pushReplacementNamed(RouteName.wrapper);

      emit(LogoutState());
    } on FirebaseAuthException catch (e) {
      emit(AuthErrorState(e.message ?? e.code, userModel: state.userModel));
    } catch (e) {
      emit(AuthErrorState(e.toString(), userModel: state.userModel));
    }
  }
}
