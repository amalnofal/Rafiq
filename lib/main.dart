import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/controller/app_controller.dart';
import 'package:rafiq/core/controller/appointment_provider.dart';
import 'package:rafiq/core/controller/clinic_provider.dart';
import 'package:rafiq/core/controller/pet_provider.dart';
import 'package:rafiq/core/controller/user_provider.dart';
import 'package:rafiq/core/di/service_locator.dart';
import 'package:rafiq/core/helper/cache_helper.dart';
import 'package:rafiq/core/theme/app_theme.dart';
import 'package:rafiq/features/auth/presentation/manager/forget_password_cubit/forget_password_cubit.dart';
import 'package:rafiq/features/auth/presentation/manager/login_cubit/login_cubit.dart';
import 'package:rafiq/features/auth/presentation/manager/register_cubit/register_cubit.dart';
import 'package:rafiq/features/auth/presentation/pages/forget_pass.dart';
import 'package:rafiq/features/auth/presentation/pages/register_screen.dart';
import 'package:rafiq/features/auth/presentation/pages/login_screen.dart';
import 'package:rafiq/features/clinics/presentation/pages/clinics_screen.dart';
import 'package:rafiq/features/collar/presentation/pages/smart_collar_screen.dart';
import 'package:rafiq/features/community/manager/community_provider.dart';
import 'package:rafiq/features/community/presentation/pages/community_screen.dart';
import 'package:rafiq/features/home/presentation/pages/notifications_screen.dart';
import 'package:rafiq/features/profile/presentation/pages/add_clinic_screen.dart';
import 'package:rafiq/features/profile/presentation/pages/add_pet_screen.dart';
import 'package:rafiq/features/store/presentation/pages/store_screen.dart';
import 'package:rafiq/l10n/app_localizations.dart';
import 'package:rafiq/layout/main_layout.dart';
import 'package:timeago/timeago.dart' as timeago;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await CacheHelper.init();

  await setupServiceLocator();

  final appController = AppController();
  await appController.loadSettings();

  final userProvider = UserProvider();
  await userProvider.loadUserData();

  timeago.setLocaleMessages('ar', timeago.ArMessages());
  timeago.setLocaleMessages('en', timeago.EnMessages());

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => appController),
        ChangeNotifierProvider.value(value: userProvider),
        ChangeNotifierProvider(create: (_) => getIt<PetProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<ClinicProvider>()),
        ChangeNotifierProvider(create: (_) => CommunityProvider()),
        ChangeNotifierProvider(create: (_) => getIt<AppointmentProvider>()),
      ],
      child: RafiqApp(initialRoute: userProvider.isAuth ? '/home' : '/login'),
    ),
  );
}

class RafiqApp extends StatelessWidget {
  final String initialRoute;

  const RafiqApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    final appController = Provider.of<AppController>(context);

    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          scrollBehavior: const MaterialScrollBehavior().copyWith(
            overscroll: false,
          ),

          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: const TextScaler.linear(1.0)),
              child: child!,
            );
          },
          debugShowCheckedModeBanner: false,
          title: 'Rafiq - رفيق',

          locale: appController.locale,
          supportedLocales: const [Locale('en'), Locale('ar')],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          theme: AppTheme.light(context),
          darkTheme: AppTheme.dark(context),
          themeMode: appController.isDarkMode
              ? ThemeMode.dark
              : ThemeMode.light,

          initialRoute: initialRoute,

          routes: {
            '/register': (context) => BlocProvider(
              create: (context) => getIt<RegisterCubit>(),
              child: const RegisterScreen(),
            ),

            '/login': (context) => BlocProvider(
              create: (context) => getIt<LoginCubit>(),
              child: const LoginScreen(),
            ),
            '/forget_pass': (context) => BlocProvider(
              create: (context) => getIt<ForgetPasswordCubit>(),
              child: const ForgetPass(),
            ),
            '/add_pet_screen': (context) => const AddPetScreen(),
            '/add_clinic_screen': (context) => const AddClinicScreen(),
            '/home': (context) => const MainLayout(),
            '/notifications': (context) => const NotificationsScreen(),
            '/community': (context) => const CommunityScreen(),
            '/clinics': (context) => const ClinicsScreen(),
            '/collar': (context) => const SmartCollarScreen(),
            '/store': (context) => const StoreScreen(),
          },
        );
      },
    );
  }
}
