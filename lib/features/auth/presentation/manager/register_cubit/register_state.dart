part of 'register_cubit.dart';

sealed class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object> get props => [];
}

final class RegisterInitial extends RegisterState {}

final class RegisterLoading extends RegisterState {}

final class RegisterSuccess extends RegisterState {
  final String message;

  const RegisterSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

final class RegisterFailure extends RegisterState {
  final String errorMessage;

  const RegisterFailure({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

// 1. حالة التحميل وقت فحص الإيميل
class EmailCheckLoading extends RegisterState {}

// 2. حالة إن الإيميل متاح (جديد ومش متسجل قبل كده)
class EmailAvailable extends RegisterState {}

// 3. حالة إن الإيميل محجوز (موجود في الداتا بيز)
class EmailTaken extends RegisterState {
  final String message;
  const EmailTaken({required this.message});

  @override
  List<Object> get props => [message];
}