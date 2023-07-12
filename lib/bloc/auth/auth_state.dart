part of 'auth_bloc.dart';

@immutable
abstract class AuthState {
  final UserModel? userModel;
  const AuthState({this.userModel});
}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState{}
class LoginLoadingState extends AuthState {}

class GoogleLoadingState extends AuthState {}

class RegisterLoadingState extends AuthState {}

class AuthSuccessState extends AuthState {
  const AuthSuccessState(UserModel userModel) : super(userModel: userModel);
}

class AuthChangePassSuccessState extends AuthState {
  const AuthChangePassSuccessState(UserModel userModel)
      : super(userModel: userModel);
}

class AuthChangeEmailLoadingState extends AuthState {}

class LogoutState extends AuthState {}

class AuthErrorState extends AuthState {
  final String message;
  const AuthErrorState(this.message, {UserModel? userModel})
      : super(userModel: userModel);
}
class UserCancelState extends AuthState {
 
}
