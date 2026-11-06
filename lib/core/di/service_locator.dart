import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:rafiq/core/controller/appointment_provider.dart';
import 'package:rafiq/core/controller/clinic_provider.dart';
import 'package:rafiq/core/controller/collar_provider.dart';
import 'package:rafiq/core/controller/community_provider.dart';
import 'package:rafiq/core/controller/pet_provider.dart';
import 'package:rafiq/core/controller/store_provider.dart';
import 'package:rafiq/core/controller/user_provider.dart';
import 'package:rafiq/core/helper/cache_helper.dart';
import 'package:rafiq/core/helper/custom_snackbar.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
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
import 'package:rafiq/features/auth/presentation/manager/forget_password_cubit/forget_password_cubit.dart';
import 'package:rafiq/features/auth/presentation/manager/login_cubit/login_cubit.dart';
import 'package:rafiq/features/auth/presentation/manager/register_cubit/register_cubit.dart';
import 'package:rafiq/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:rafiq/main.dart';

final getIt = GetIt.instance;

DateTime? _lastErrorTime;

// Prevents showing the session-expired dialog more than once.
bool _sessionExpiring = false;

Future<void> setupServiceLocator() async {
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

  // ---------- Dio ----------
  getIt.registerLazySingleton<Dio>(
    () => createDio(
      onSessionExpired: _expireSession,
      onNetworkError: _showNetworkErrorThrottled,
      tokenStorage: getIt<TokenStorage>(),
    ),
  );

  // ---------- Cubits ----------
  getIt.registerFactory(() => ForgetPasswordCubit(getIt()));
  getIt.registerFactory(() => LoginCubit(getIt()));
  getIt.registerFactory(() => RegisterCubit(getIt()));
  getIt.registerFactory(() => ChatCubit(getIt()));
}

void _showNetworkErrorThrottled() {
  final context = navigatorKey.currentContext;
  if (context == null) return;

  final now = DateTime.now();
  if (_lastErrorTime != null &&
      now.difference(_lastErrorTime!).inSeconds <= 3) {
    return;
  }
  _lastErrorTime = now;

  try {
    showSnackBar(context, context.l10n.connectionError, isError: true);
  } catch (_) {}
}

Future<void> _expireSession() async {
  if (_sessionExpiring) return;
  _sessionExpiring = true;

  // Full local cleanup (providers + cache). Token is already dead, no revoke.
  try {
    await getIt<UserProvider>().logout(revoke: false);
  } catch (e) {
    log('[DioInterceptor]: Logout cleanup failed: $e');
    await CacheHelper.clearSession();
  }

  _showSessionExpiredDialog();
}

// TODO(clean-arch): move to presentation layer, trigger via an auth-state stream.
void _showSessionExpiredDialog() {
  final context = navigatorKey.currentContext;
  if (context == null) {
    _sessionExpiring = false;
    return;
  }

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red),
            SizedBox(width: 8.w),
            Text(
              context.l10n.sessionExpiredTitle,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
        content: Text(
          context.l10n.sessionExpiredMessage,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () {
              _sessionExpiring = false;
              Navigator.of(dialogContext).pop();
              navigatorKey.currentState?.pushNamedAndRemoveUntil(
                '/login',
                (route) => false,
              );
            },
            child: Text(
              context.l10n.login,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      );
    },
  );
}
