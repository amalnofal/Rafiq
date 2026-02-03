import 'package:flutter/material.dart';
import 'package:rafiq/core/widgets/custom_nav_bar.dart';
import 'package:rafiq/features/clinics/presentation/pages/clinics_screen.dart';
import 'package:rafiq/features/home/presentation/pages/home_screen.dart';
import 'package:rafiq/features/community/presentation/pages/community_screen.dart';
import 'package:rafiq/features/collar/presentation/pages/smart_collar_screen.dart';
import 'package:rafiq/features/store/presentation/pages/store_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(), // Index 0
    const CommunityScreen(), // Index 1
    const SmartCollarScreen(), // Index 2 (الطوق الذكي - في المنتصف)
    const ClinicsScreen(), // Index 3
    const StoreScreen(), // Index 4
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 3. استخدام IndexedStack هو السر في النعومة والحفاظ على حالة الصفحات
      body: IndexedStack(index: _currentIndex, children: _screens),

      // 4. البار موجود هنا وثابت
      bottomNavigationBar: CustomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // تغيير الصفحة عند الضغط
          });
        },
        onFabTap: () {
          setState(() {
            _currentIndex = 2;
          });
        },
      ),
    );
  }
}
