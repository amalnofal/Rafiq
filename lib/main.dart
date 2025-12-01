import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/controller/app_controller.dart';
import 'package:rafiq/core/controller/user_provider.dart';
import 'package:rafiq/core/models/user_info.dart';
import 'package:rafiq/core/theme/app_theme.dart';
import 'package:rafiq/features/home/presentation/pages/home_screen.dart';
import 'package:rafiq/features/login/presentation/pages/login_screen.dart';
import 'package:rafiq/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appController = AppController();
  await appController.loadSettings();

  final currentUser = UserInfo(
    name: "أحمد محمد",
    email: "ahmed@example.com",
    phone: "+966 50 123 4567",
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => appController),
        ChangeNotifierProvider(create: (_) => UserProvider(user: currentUser)),
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
      builder: (context, child) {
        return MaterialApp(
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

          initialRoute: '/login',
          routes: {
            '/login': (context) => LoginScreen(),
            '/home': (context) => HomeScreen(),
          },
          home: child,
        );
      },

      child: const LoginScreen(),
    );
  }
}
