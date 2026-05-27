import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/helper/date_helper.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/features/clinics/data/models/appointment_model.dart';
import 'package:rafiq/features/clinics/data/models/clinic_model.dart';
import 'package:rafiq/features/clinics/presentation/widgets/appointments/dialog_header.dart';

class AvailableSlotsDialog extends StatelessWidget {
  final DateTime selectedDate;
  final List<AppointmentModel> dayAppointments;
  final ClinicModel? clinic;

  const AvailableSlotsDialog({
    super.key,
    required this.selectedDate,
    required this.dayAppointments,
    this.clinic,
  });

  // دالة توليد المواعيد (كل 30 دقيقة)
  List<DateTime> _generateAllSlots() {
    String openTime = clinic?.openingTime ?? "08:00";
    String closeTime = clinic?.closingTime ?? "22:00";

    int openHour = int.tryParse(openTime.split(':')[0]) ?? 8;
    int openMin = int.tryParse(openTime.split(':')[1]) ?? 0;
    int closeHour = int.tryParse(closeTime.split(':')[0]) ?? 22;
    int closeMin = int.tryParse(closeTime.split(':')[1]) ?? 0;

    DateTime start = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      openHour,
      openMin,
    );
    DateTime end = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      closeHour,
      closeMin,
    );

    if (end.isBefore(start) || end.isAtSameMomentAs(start)) {
      end = end.add(const Duration(days: 1));
    }

    List<DateTime> slots = [];
    DateTime current = start;
    while (current.isBefore(end)) {
      slots.add(current);
      current = current.add(const Duration(minutes: 30));
    }
    return slots;
  }

  @override
  Widget build(BuildContext context) {
    final slots = _generateAllSlots();
    // عرض التاريخ زي الفيجما (مثال: 2 مارس)
    final dateFormatted = DateHelper.formatDayMonth(selectedDate, context);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DialogHeader(
              title: "${context.l10n.availableSlots} - $dateFormatted",
            ),
            //=====================================
            // 2. شبكة المواعيد (للعرض فقط)
            // =====================================
            Flexible(
              child: Padding(
                padding: EdgeInsets.all(20.w),
                // استخدمنا GridView عشان يطلعوا 3 أعمدة متساوية بالظبط
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: slots.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // 3 أعمدة
                    crossAxisSpacing: 10.w, // المسافة الأفقية
                    mainAxisSpacing: 12.h, // المسافة الرأسية
                    childAspectRatio:
                        2.0, // نسبة العرض للطول عشان المستطيل يطلع مظبوط
                  ),
                  itemBuilder: (context, index) {
                    final slotTime = slots[index];
                    String slotTimeStr =
                        "${slotTime.hour.toString().padLeft(2, '0')}:${slotTime.minute.toString().padLeft(2, '0')}";

                    bool isBooked = dayAppointments.any((app) {
                      if (app.time.isEmpty) return false;
                      String appPrefix = app.time.length >= 5
                          ? app.time.substring(0, 5)
                          : app.time;
                      return appPrefix == slotTimeStr &&
                          app.status.toLowerCase() != 'cancelled';
                    });

                    String displayTime = DateHelper.formatTime(
                      slotTimeStr,
                      context,
                    );

                    // المربعات هنا Container للعرض فقط (بدون أي أزرار)
                    return Card(
                      elevation: 0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            displayTime,
                            style: Theme.of(context).textTheme.bodyMedium!
                                .copyWith(
                                  color: isBooked
                                      ? const Color(0xFFFF4B4B)
                                      : null,
                                ),
                          ),
                          if (isBooked) ...[
                            SizedBox(height: 2.h),
                            Text(
                              context.l10n.booked,
                              style: TextStyle(
                                color: const Color(0xFFFF4B4B),
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
