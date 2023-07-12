part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class AuthInitialEvent extends AuthEvent {}

class AuthInitializeEvent extends AuthEvent {}

class LoginWithEmailEvent extends AuthEvent {}

class RegisterWithEmailEvent extends AuthEvent {}

class LoginWithGoogleEvent extends AuthEvent {}

class LogoutEvent extends AuthEvent {
  final List<Future> task;
  LogoutEvent(this.task);
}

class ChangeEmailEvent extends AuthEvent {}

class ChangePasswordEvent extends AuthEvent {}

class AuthListnerEvent extends AuthEvent {
  final UserModel? userModel;
  AuthListnerEvent(this.userModel);
}
