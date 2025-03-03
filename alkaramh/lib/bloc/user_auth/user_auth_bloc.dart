import 'package:alkaramh/services/apple_auth_services.dart';
import 'package:alkaramh/services/auth_services.dart';
import 'package:alkaramh/services/google_services.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'user_auth_event.dart';
part 'user_auth_state.dart';

class UserAuthBloc extends Bloc<UserAuthEvent, UserAuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AppleServices _appleServices = AppleServices();
  UserAuthBloc() : super(UserAuthInitial()) {
    on<UserAuthEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<UserAuthRegisterEvent>(userAuthRegisterEvent);
    on<SignupGoogleEvent>(signupGoogleEvent);
    on<SignInEvent>(signInEvent);
    on<SignInGoogleEvent>(signInGoogleEvent);
    on<LogoutEvent>(logoutEvent);
    on<GetCurrentUserEvent>(_getCurrentUser);
    //info: apple signup
    on<SignupAppleEvent>(_signupAppleEvent);
  }

  void userAuthRegisterEvent(
      UserAuthRegisterEvent event, Emitter<UserAuthState> emit) async {
    emit(UserRegisterLoading());
    try {
      AuthServices authServices = AuthServices();
      final result = await authServices.register(
        email: event.email,
        password: event.password,
        name: event.name,
      );

      if (result.success) {
        emit(UserRegisterSuccess());
      } else {
        emit(UserRegisterFailure(
            message: result.errorMessage ?? 'Registration failed'));
      }
    } catch (e) {
      emit(UserRegisterFailure(message: e.toString()));
    }
  }

  void signupGoogleEvent(
      SignupGoogleEvent event, Emitter<UserAuthState> emit) async {
    emit(GoogleSignInLoading());
    try {
      final userCredential = await GoogleServices.signupWithGoogle();
      if (userCredential.user != null) {
        emit(GoogleSignInSuccess());
      } else {
        emit(GoogleSignInFailure(message: 'Google sign in failed'));
      }
    } catch (e) {
      emit(GoogleSignInFailure(message: e.toString()));
    }
  }

  void signInEvent(SignInEvent event, Emitter<UserAuthState> emit) async {
    emit(UserRegisterLoading());
    try {
      AuthServices authServices = AuthServices();
      final result = await authServices.login(
        event.email,
        event.password,
      );
      if (result.success) {
        emit(UserRegisterSuccess());
      } else {
        emit(UserRegisterFailure(
            message: result.errorMessage ?? 'Login failed'));
      }
    } catch (e) {
      emit(UserRegisterFailure(message: e.toString()));
    }
  }

  void signInGoogleEvent(
      SignInGoogleEvent event, Emitter<UserAuthState> emit) async {
    emit(GoogleSignInLoading());
    try {
      final userCredential = await GoogleServices.signInWithGoogle();
      if (userCredential.user != null) {
        emit(GoogleSignInSuccess());
      } else {
        emit(GoogleSignInFailure(message: 'Google sign in failed'));
      }
    } catch (e) {
      emit(GoogleSignInFailure(message: e.toString()));
    }
  }

  void _getCurrentUser(
      GetCurrentUserEvent event, Emitter<UserAuthState> emit) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        emit(UserAuthSuccess(user: user));
      }
    } catch (e) {
      emit(UserAuthFailure(message: e.toString()));
    }
  }

  void logoutEvent(LogoutEvent event, Emitter<UserAuthState> emit) async {
    AuthServices authServices = AuthServices();
    final logout = await authServices.logout();
    if (logout) {
      emit(UserAuthInitial());
    } else {
      emit(UserRegisterFailure(message: 'Logout failed'));
    }
  }

  //info: apple signup
  void _signupAppleEvent(
      SignupAppleEvent event, Emitter<UserAuthState> emit) async {
    emit(UserRegisterLoading());
    try {
      final userCredential = await _appleServices.signInWithApple();
      if (userCredential.user != null) {
        emit(UserRegisterSuccess());
      } else {
        emit(UserRegisterFailure(message: 'Apple sign-in failed'));
      }
    } catch (e) {
      emit(UserRegisterFailure(message: e.toString()));
    }
  }
}
