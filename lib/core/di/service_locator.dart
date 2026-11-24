import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:rafiq/core/controller/appointment_provider.dart';
import 'package:rafiq/core/controller/clinic_provider.dart';
import 'package:rafiq/core/controller/collar_provider.dart';
import 'package:rafiq/core/controller/community_provider.dart';
import 'package:rafiq/core/controller/pet_provider.dart';
import 'package:rafiq/core/controller/store_provider.dart';
import 'package:rafiq/core/controller/user_provider.dart';
import 'package:rafiq/core/helper/cache_helper.dart';
import 'package:rafiq/core/network/dio_client.dart';
import 'package:rafiq/core/services/appointment_service.dart';
import 'package:rafiq/core/services/auth_service.dart';
import 'package:rafiq/core/services/chat_service.dart';
import 'package:rafiq/core/services/clinic_service.dart';
import 'package:rafiq/core/services/collar_service.dart';
import 'package:rafiq/core/services/community_service.dart';
import 'package:rafiq/core/services/pet_service.dart';
import 'package:rafiq/core/services/store_service.dart';
import 'package:rafiq/core/services/user_service.dart';
import 'package:rafiq/core/storage/token_storage.dart';
import 'package:rafiq/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:rafiq/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:rafiq/features/auth/domain/repositories/auth_repository.dart';
import 'package:rafiq/features/auth/presentation/cubit/forget_password_cubit/forget_password_cubit.dart';
import 'package:rafiq/features/auth/presentation/cubit/login_cubit/login_cubit.dart';
import 'package:rafiq/features/auth/presentation/cubit/register_cubit/register_cubit.dart';
import 'package:rafiq/features/auth/presentation/cubit/session_cubit/session_cubit.dart';
import 'package:rafiq/features/chat/presentation/cubit/chat_cubit.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator({
  required void Function() onNetworkError,
}) async {
  // ---------- Services & providers ----------
  getIt.registerLazySingleton(() => AuthService(getIt()));
  getIt.registerLazySingleton(() => UserProvider());
  getIt.registerLazySingleton(() => UserService(getIt()));
  getIt.registerLazySingleton(() => PetService(getIt()));
  getIt.registerLazySingleton(() => PetProvider());
  getIt.registerLazySingleton(() => ClinicService(getIt()));
  getIt.registerLazySingleton(() => ClinicProvider(getIt()));
  getIt.registerLazySingleton(() => AppointmentService(getIt()));
  getIt.registerLazySingleton(() => AppointmentProvider());
  getIt.registerLazySingleton(() => CommunityService(getIt()));
  getIt.registerLazySingleton(() => CommunityProvider(getIt()));
  getIt.registerLazySingleton(() => ChatService(getIt<Dio>()));
  getIt.registerLazySingleton(() => StoreService(getIt<Dio>()));
  getIt.registerLazySingleton(() => StoreProvider(getIt<StoreService>()));
  getIt.registerLazySingleton(() => CollarService(getIt<Dio>()));
  getIt.registerLazySingleton(() => CollarProvider(getIt<CollarService>()));
  getIt.registerLazySingleton(() => TokenStorage());

  getIt.registerLazySingleton(() => AuthRemoteDataSource(getIt()));
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt(), getIt()),
  );

  // ---------- Dio ----------
  getIt.registerLazySingleton<Dio>(
    () => createDio(
      onSessionExpired: () => getIt<SessionCubit>().expire(),
      onNetworkError: onNetworkError,
      tokenStorage: getIt<TokenStorage>(),
    ),
  );

  // ---------- Cubits ----------
  getIt.registerFactory(() => ForgetPasswordCubit(getIt()));
  getIt.registerFactory(() => LoginCubit(getIt()));
  getIt.registerFactory(() => RegisterCubit(getIt()));
  getIt.registerFactory(() => ChatCubit(getIt()));

  getIt.registerLazySingleton(
    () =>
        SessionCubit(clearSession: _clearLocalSession, authRepository: getIt()),
  );
}

// Clears all user data after the server rejected the session.
Future<void> _clearLocalSession() async {
  try {
    await getIt<UserProvider>().logout();
  } catch (e) {
    log('[Session]: logout cleanup failed: $e');
    await CacheHelper.clearSession();
  }
}
