import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:rafiq/core/constants/app_colors.dart';
import 'package:rafiq/core/widgets/custom_text_field.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class CustomDatePicker extends StatefulWidget {
  final DateTime? initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  const CustomDatePicker({
    super.key,
    this.initialDate,
    required this.firstDate,
    required this.lastDate,
  });

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  late FixedExtentScrollController _monthController;
  late FixedExtentScrollController _dayController;
  late FixedExtentScrollController _yearController;

  late int _selectedMonth;
  late int _selectedDay;
  late int _selectedYear;

  late List<int> _years;
  final double _itemExtent = 50.0;
  final double _pickerHeight = 175.0;

  @override
  void initState() {
    super.initState();
    final DateTime targetDate = widget.initialDate ?? widget.lastDate;

    // لستة السنين تقف عند السنة المحددة في lastDate
    _years = List.generate(
      widget.lastDate.year - widget.firstDate.year + 1,
      (index) => widget.firstDate.year + index,
    );

    _selectedMonth = targetDate.month;
    _selectedDay = targetDate.day;
    _selectedYear = targetDate.year;

    _monthController = FixedExtentScrollController(
      initialItem: _selectedMonth - 1,
    );
    _dayController = FixedExtentScrollController(initialItem: _selectedDay - 1);

    int yearIndex = _years.indexOf(_selectedYear);
    _yearController = FixedExtentScrollController(
      initialItem: yearIndex != -1 ? yearIndex : 0,
    );
  }

  @override
  void dispose() {
    _monthController.dispose();
    _dayController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;

    // لستة الشهور دائمًا 12
    List<String> months = List.generate(12, (index) {
      return DateFormat.MMM(locale).format(DateTime(2024, index + 1, 1));
    });

    // لستة الأيام بناءً على الشهر والسنة المحددين
    int daysInMonth = DateTime(_selectedYear, _selectedMonth + 1, 0).day;
    List<int> days = List.generate(daysInMonth, (index) => index + 1);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        height: _pickerHeight + 140.h,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.set_date,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 30.h),
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: _itemExtent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildDividerBox(),
                        SizedBox(width: 10.w),
                        _buildDividerBox(),
                        SizedBox(width: 10.w),
                        _buildDividerBox(),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: _pickerHeight,
                    child: Row(
                      children: [
                        // بكرة الأيام
                        _buildPicker(
                          controller: _dayController,
                          items: days
                              .map((e) => e.toString().padLeft(2, '0'))
                              .toList(),
                          onChanged: (idx) => _selectedDay = days[idx],
                        ),
                        SizedBox(width: 10.w),
                        // بكرة الشهور
                        _buildPicker(
                          controller: _monthController,
                          items: months,
                          onChanged: (idx) {
                            setState(() {
                              _selectedMonth = idx + 1;
                              int daysInMonth = DateTime(
                                _selectedYear,
                                _selectedMonth + 1,
                                0,
                              ).day;
                              if (_selectedDay > daysInMonth) {
                                _selectedDay = daysInMonth;
                                _dayController.jumpToItem(daysInMonth - 1);
                              }
                            });
                          },
                        ),
                        SizedBox(width: 10.w),
                        // بكرة السنين
                        _buildPicker(
                          controller: _yearController,
                          items: _years.map((e) => e.toString()).toList(),
                          onChanged: (idx) {
                            setState(() {
                              _selectedYear = _years[idx];
                              int daysInMonth = DateTime(
                                _selectedYear,
                                _selectedMonth + 1,
                                0,
                              ).day;
                              if (_selectedDay > daysInMonth) {
                                _selectedDay = daysInMonth;
                                _dayController.jumpToItem(daysInMonth - 1);
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
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
                    final selectedDate = DateTime(
                      _selectedYear,
                      _selectedMonth,
                      _selectedDay,
                    );
                    Navigator.pop(context, selectedDate);
                  },
                  child: Text(AppLocalizations.of(context)!.set),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDividerBox() {
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColors.kBrandPrimary, width: 1.2),
            bottom: BorderSide(color: AppColors.kBrandPrimary, width: 1.2),
          ),
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
        magnification: 1.1,
        useMagnifier: true,
        selectionOverlay: null,
        onSelectedItemChanged: onChanged,
        children: items.map((item) {
          return Center(
            child: Text(item, style: Theme.of(context).textTheme.bodyLarge),
          );
        }).toList(),
      ),
    );
  }
}

class CustomDatePickerField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final DateTime? initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final String? Function(String?)? validator;
  final Function(DateTime) onDateSelected;
  final bool readOnly;

  const CustomDatePickerField({
    super.key,
    required this.controller,
    required this.hintText,
    this.initialDate,
    required this.firstDate,
    required this.lastDate,
    this.validator,
    required this.onDateSelected,
    this.readOnly = false,
  });

  @override
  State<CustomDatePickerField> createState() => _CustomDatePickerFieldState();
}

class _CustomDatePickerFieldState extends State<CustomDatePickerField> {
  Future<void> _selectDate() async {
    final DateTime? picked = await showDialog<DateTime>(
      context: context,
      builder: (context) => CustomDatePicker(
        initialDate: widget.initialDate,
        firstDate: widget.firstDate,
        lastDate: widget.lastDate,
      ),
    );

    if (picked != null && mounted) {
      widget.controller.text = DateFormat('dd/MM/yyyy').format(picked);
      widget.onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.readOnly ? null : _selectDate,
      child: AbsorbPointer(
        child: CustomTextField(
          controller: widget.controller,
          hintText: widget.hintText,
          readOnly: widget.readOnly,
          validator: widget.validator,
          prefixIcon: "assets/icons/calendar.svg",
        ),
      ),
    );
  }
}
