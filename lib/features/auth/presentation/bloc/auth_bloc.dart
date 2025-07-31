import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/api_service.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';

// Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class RegisterRequested extends AuthEvent {
  final String email;
  final String name;
  final String password;

  const RegisterRequested({
    required this.email,
    required this.name,
    required this.password,
  });

  @override
  List<Object?> get props => [email, name, password];
}

class LogoutRequested extends AuthEvent {}

class CheckAuthStatus extends AuthEvent {}

class LoadProfile extends AuthEvent {}

class UploadPhotoRequested extends AuthEvent {
  final String filePath;

  const UploadPhotoRequested(this.filePath);

  @override
  List<Object?> get props => [filePath];
}

// States
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final User user;

  const Authenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

class ProfileLoading extends AuthState {}

class ProfileLoaded extends AuthState {
  final User user;

  const ProfileLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

class PhotoUploading extends AuthState {}

class PhotoUploaded extends AuthState {
  final String photoUrl;

  const PhotoUploaded(this.photoUrl);

  @override
  List<Object?> get props => [photoUrl];
}

// BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final AuthRepositoryImpl _authRepository;

  AuthBloc()
      : _authRepository = AuthRepositoryImpl(ApiService()),
        _loginUseCase = LoginUseCase(AuthRepositoryImpl(ApiService())),
        _registerUseCase = RegisterUseCase(AuthRepositoryImpl(ApiService())),
        super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<LoadProfile>(_onLoadProfile);
    on<UploadPhotoRequested>(_onUploadPhotoRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _loginUseCase(event.email, event.password);
      emit(Authenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _registerUseCase(event.email, event.name, event.password);
      emit(Authenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _authRepository.logout();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final isLoggedIn = await _authRepository.isLoggedIn();
      if (isLoggedIn) {
        final user = await _authRepository.getProfile();
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(Unauthenticated());
    }
  }

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<AuthState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      final user = await _authRepository.getProfile();
      emit(ProfileLoaded(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onUploadPhotoRequested(
    UploadPhotoRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(PhotoUploading());
    try {
      final photoUrl = await _authRepository.uploadPhoto(event.filePath);
      emit(PhotoUploaded(photoUrl));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
} 