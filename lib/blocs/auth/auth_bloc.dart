import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<UsernameSubmitted>((event, emit) async {
      final username = event.username.trim();
      if (username.isEmpty) {
        emit(AuthFailure('Username cannot be empty'));
        return;
      }
      emit(AuthLoading());
      
      emit(AuthSuccess(username));
    });
  }
}