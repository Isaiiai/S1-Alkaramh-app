part of 'user_auth_bloc.dart';

sealed class UserAuthEvent extends Equatable {
  const UserAuthEvent();

  @override
  List<Object> get props => [];
}

class UserAuthRegisterEvent extends UserAuthEvent {
  final String email;
  final String password;
  final String name;

  UserAuthRegisterEvent(
      {required this.email, required this.password, required this.name});

  @override
  List<Object> get props => [email, password];
}

class SignupGoogleEvent extends UserAuthEvent {}


class LogoutEvent extends UserAuthEvent {}