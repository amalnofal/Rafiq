import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/controller/app_controller.dart';
import 'package:rafiq/core/controller/user_provider.dart';
import 'package:rafiq/core/theme/app_theme.dart';
import 'package:rafiq/features/auth/presentation/pages/forget_pass.dart';
import 'package:rafiq/features/auth/presentation/pages/register_screen.dart';
import 'package:rafiq/features/auth/presentation/pages/welcome_screen.dart';
import 'package:rafiq/features/auth/presentation/pages/login_screen.dart';
import 'package:rafiq/features/clinics/presentation/pages/clinics_screen.dart';
import 'package:rafiq/features/collar/presentation/pages/smart_collar_screen.dart';
import 'package:rafiq/features/community/manager/community_provider.dart';
import 'package:rafiq/features/community/presentation/pages/community_screen.dart';
import 'package:rafiq/features/store/presentation/pages/store_screen.dart';
import 'package:rafiq/l10n/app_localizations.dart';
import 'package:rafiq/layout/main_layout.dart';
import 'package:timeago/timeago.dart' as timeago;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
        ChangeNotifierProvider(create: (_) => userProvider),
        ChangeNotifierProvider(create: (_) => CommunityProvider()),
      ],
      child: const RafiqApp(),
    ),
  );
}

class RafiqApp extends StatelessWidget {
  const RafiqApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appController = Provider.of<AppController>(context);

    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          scrollBehavior: const MaterialScrollBehavior().copyWith(
            overscroll: false, // بيلغي الوهج الأخضر بتاع الأندرويد
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

          initialRoute: '/welcome',

          routes: {
            '/welcome': (context) => const WelcomeScreen(),
            '/register': (context) => const RegisterScreen(),
            '/login': (context) => const LoginScreen(),
            '/home': (context) => const MainLayout(),
            '/store': (context) => const StoreScreen(),
            '/clinics': (context) => const ClinicsScreen(),
            '/collar': (context) => const SmartCollarScreen(),
            '/community': (context) => const CommunityScreen(),
            '/forget_pass': (context) => const ForgetPass(),
          },
        );
      },
    );
  }
}
