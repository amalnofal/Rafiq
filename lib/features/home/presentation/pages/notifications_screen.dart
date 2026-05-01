import 'package:flutter/material.dart';
import 'package:rafiq/core/widgets/rafiq_scaffold.dart';
import 'package:rafiq/features/home/data/models/notification_model.dart';
import 'package:rafiq/features/home/presentation/widgets/notifications/notification_item_tile.dart'; // استيراد الويدجت
import 'package:rafiq/l10n/app_localizations.dart';
import '../widgets/notifications/empty_notifications_body.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy Data
    final List<NotificationModel> notifications = [
      // // 1. نوع التنبيه (تنبيه صحي)
      // NotificationModel(
      //   title: "تنبيه: حرارة مرتفعة",
      //   subtitle:
      //       "درجة حرارة ماكس وصلت إلى 39.5 درجة، يرجى مراقبته أو استشارة طبيب.",
      //   time: "منذ 10 دقائق",
      //   type: NotificationType.alert,
      //   isUnread: true,
      // ),

      // // 2. تفاعلات المجتمع (الإعجابات والتعليقات)
      // NotificationModel(
      //   title: "تفاعل جديد",
      //   subtitle: "سارة أحمد و 5 آخرون أعجبوا بمنشورك في المجتمع",
      //   time: "منذ 3 ساعات",
      //   type: NotificationType.community,
      //   // isUnread: true,
      // ),

      // // 3. المواعيد (التطعيم والعيادات)
      // NotificationModel(
      //   title: "تذكير بالموعد",
      //   subtitle: "موعدك في عيادة الرحمة غداً الساعة 3 مساءً",
      //   time: "أمس",
      //   type: NotificationType.appointment,
      //   isUnread: true,
      // ),

      // // 4. الطوق الذكي (تنبيه صحي)
      // NotificationModel(
      //   title: "نشاط عالي !",
      //   subtitle: "يبدو أن ماكس نشيط جداً اليوم، لقد حقق 10,000 خطوة!",
      //   time: "منذ 5 ساعات",
      //   type: NotificationType.collar,
      //   // isUnread: true,
      // ),
    ];

    return RafiqScaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.notificationsTitle),
      ),
      padding: EdgeInsets.zero,
      body: notifications.isEmpty
          ? const EmptyNotificationsBody()
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final item = notifications[index];
                return NotificationItemTile(
                  title: item.title,
                  subtitle: item.subtitle,
                  time: item.time,
                  icon: item.icon,
                  iconColor: item.iconColor,
                  iconBgColor: item.bgColor,
                  isUnread: item.isUnread,
                );
              },
            ),
    );
  }
}
