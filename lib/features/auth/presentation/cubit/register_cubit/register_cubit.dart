import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rafiq/core/error/failure.dart';
import 'package:rafiq/features/auth/domain/entities/register_params.dart';
import 'package:rafiq/features/auth/domain/repositories/auth_repository.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthRepository _authRepository;

  RegisterCubit(this._authRepository) : super(RegisterInitial());

  // 1. Create the account.
  Future<void> submitRegister(RegisterParams params) async {
    emit(RegisterLoading());
    try {
      await _authRepository.register(params);
      emit(const RegisterSuccess(message: 'registrationSuccess'));
    } on Failure catch (f) {
      emit(RegisterFailure(errorMessage: _registerKey(f)));
    } catch (_) {
      emit(const RegisterFailure(errorMessage: 'unexpectedError'));
    }
  }

  // 2. Check that the email is free.
  Future<void> verifyEmail(String email) async {
    emit(EmailCheckLoading());
    try {
      final taken = await _authRepository.isEmailTaken(email);
      emit(
        taken
            ? const EmailTaken(message: 'emailAlreadyExists')
            : EmailAvailable(),
      );
    } on Failure catch (f) {
      emit(RegisterFailure(errorMessage: _emailKey(f)));
    } catch (_) {
      emit(const RegisterFailure(errorMessage: 'unexpectedError'));
    }
  }

  String _registerKey(Failure f) => switch (f) {
    NetworkFailure() => 'connectionError',
    BadRequestFailure(:final message) => message ?? 'registrationFailed',
    _ => 'unexpectedError',
  };

  String _emailKey(Failure f) => switch (f) {
    NetworkFailure() => 'connectionError',
    _ => 'unexpectedError',
  };
}