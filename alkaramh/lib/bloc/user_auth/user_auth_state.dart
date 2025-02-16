part of 'user_auth_bloc.dart';

sealed class UserAuthState extends Equatable {
  const UserAuthState();

  @override
  List<Object> get props => [];
}

final class UserAuthInitial extends UserAuthState {}

final class UserRegisterLoading extends UserAuthState {}

final class UserRegisterSuccess extends UserAuthState {}

final class UserRegisterFailure extends UserAuthState {
  final String message;

  UserRegisterFailure({required this.message});

  @override
  List<Object> get props => [message];
}

//info: Google Signin State

class GoogleSignInLoading extends UserAuthState {}

class GoogleSignInSuccess extends UserAuthState {}

class GoogleSignInFailure extends UserAuthState {
  final String message;
  GoogleSignInFailure({required this.message});
}

class UserAuthSuccess extends UserAuthState {
  final User user;
  UserAuthSuccess({required this.user});
}

class UserAuthFailure extends UserAuthState {
  final String message;
  UserAuthFailure({required this.message});
}