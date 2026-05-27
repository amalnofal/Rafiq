import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class CustomTimePicker extends StatefulWidget {
  final String title;
  final TimeOfDay initialTime;

  const CustomTimePicker({
    super.key,
    required this.title,
    required this.initialTime,
  });

  @override
  State<CustomTimePicker> createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  late FixedExtentScrollController _hourController;
  late FixedExtentScrollController _minuteController;
  late FixedExtentScrollController _amPmController;

  late int _selectedHourIndex;
  late int _selectedMinuteIndex;
  late int _selectedAmPmIndex;

  final double _itemExtent = 50.0;
  final double _pickerHeight = 175.0;

  // الداتا بتاعة البكرات
  final List<String> _hours = List.generate(
    12,
    (index) => (index + 1).toString().padLeft(2, '0'),
  ); // 01 إلى 12
  // الدقائق كل ربع ساعة
  final List<String> _minutes = ['00', '15', '30', '45'];
  final List<String> _amPm = ['AM', 'PM'];

  @override
  void initState() {
    super.initState();

    // تحويل الوقت من 24 (TimeOfDay) إلى 12 (AM/PM) عشان نعرضه صح لليوزر
    int currentHour24 = widget.initialTime.hour;
    int currentMinute = widget.initialTime.minute >= 30 ? 30 : 0;
    bool isPM = currentHour24 >= 12;

    int currentHour12 = currentHour24 % 12;
    if (currentHour12 == 0) currentHour12 = 12; // الصفر في نظام 24 هو 12 AM

    // تحديد الـ index لكل بكرة
    _selectedHourIndex = currentHour12 - 1;
    _selectedMinuteIndex = currentMinute == 0 ? 0 : 1;
    _selectedAmPmIndex = isPM ? 1 : 0;

    _hourController = FixedExtentScrollController(
      initialItem: _selectedHourIndex,
    );
    _minuteController = FixedExtentScrollController(
      initialItem: _selectedMinuteIndex,
    );
    _amPmController = FixedExtentScrollController(
      initialItem: _selectedAmPmIndex,
    );
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    _amPmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        height: _pickerHeight + 140.h,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // العنوان
            Text(
              widget.title,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 30.h),
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: _itemExtent + 8.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.05),
                      border: Border(
                        top: BorderSide(
                          color: Theme.of(context).dividerColor,
                          width: 1.w,
                        ),
                        bottom: BorderSide(
                          color: Theme.of(context).dividerColor,
                          width: 1.w,
                        ),
                      ),
                    ),
                  ),

                  // 2. البكرات
                  SizedBox(
                    height: _pickerHeight,
                    child: Row(
                      children: [
                        // بكرة الساعات
                        _buildPicker(
                          controller: _hourController,
                          items: _hours,
                          onChanged: (idx) => _selectedHourIndex = idx,
                        ),

                        // النقطتين :
                        Padding(
                          padding: EdgeInsets.only(bottom: 4.h),
                          child: Text(
                            ":",
                            style: Theme.of(context).textTheme.bodyLarge!
                                .copyWith(
                                  fontSize: 32.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ),

                        // بكرة الدقائق
                        _buildPicker(
                          controller: _minuteController,
                          items: _minutes,
                          onChanged: (idx) => _selectedMinuteIndex = idx,
                        ),

                        // بكرة AM/PM
                        _buildPicker(
                          controller: _amPmController,
                          items: _amPm,
                          onChanged: (idx) => _selectedAmPmIndex = idx,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),

            // زراير الإلغاء والتأكيد
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context, null),
                  child: Text(AppLocalizations.of(context)!.cancel),
                ),
                SizedBox(width: 20.w),
                TextButton(
                  onPressed: () {
                    int selectedHour12 = int.parse(_hours[_selectedHourIndex]);
                    int finalMinute = int.parse(_minutes[_selectedMinuteIndex]);
                    String amPm = _amPm[_selectedAmPmIndex];

                    int finalHour24 = selectedHour12;
                    if (amPm == "PM" && finalHour24 != 12) {
                      finalHour24 += 12;
                    } else if (amPm == "AM" && finalHour24 == 12) {
                      finalHour24 = 0;
                    }

                    Navigator.pop(
                      context,
                      TimeOfDay(hour: finalHour24, minute: finalMinute),
                    );
                  },
                  child: const Text(
                    "OK",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPicker({
    required FixedExtentScrollController controller,
    required List<String> items,
    required Function(int) onChanged,
  }) {
    return Expanded(
      child: CupertinoPicker(
        scrollController: controller,
        itemExtent: _itemExtent,
        backgroundColor: Colors.transparent,
        diameterRatio: 1.5,
        squeeze: 1,
        magnification: 1.2,
        useMagnifier: true,
        selectionOverlay: null,
        onSelectedItemChanged: onChanged,
        children: items.map((item) {
          return Center(
            child: Text(
              item,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

Future<TimeOfDay?> showCustomTimePickerDialog({
  required BuildContext context,
  required String title,
  required TimeOfDay initialTime,
}) async {
  return await showDialog<TimeOfDay>(
    context: context,
    builder: (context) =>
        CustomTimePicker(title: title, initialTime: initialTime),
  );
}
