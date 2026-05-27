import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/controller/appointment_provider.dart';
import 'package:rafiq/core/helper/date_helper.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/core/widgets/custom_text_field.dart';
import 'package:rafiq/core/widgets/custom_time_picker.dart';
import 'package:rafiq/core/widgets/selection_chip.dart';
import 'package:rafiq/features/clinics/data/models/appointment_model.dart';

class AppointmentForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final Function(Map<String, dynamic> data) onDataReady;
  final AppointmentModel? appointment;
  final bool isClinicBooking;

  final Widget selectorWidget;
  final dynamic selectedId;
  final String idKey;
  final Widget? middleContent;
  final int? clinicId;

  const AppointmentForm({
    super.key,
    required this.formKey,
    required this.onDataReady,
    required this.selectorWidget,
    required this.idKey,
    this.clinicId,
    this.selectedId,
    this.appointment,
    this.middleContent,
    required this.isClinicBooking,
  });

  @override
  State<AppointmentForm> createState() => _AppointmentFormState();
}

class _AppointmentFormState extends State<AppointmentForm> {
  final _reasonController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime? _selectedDate;
  String _apiDate = "";
  bool _showAllSlots = false;

  @override
  void initState() {
    super.initState();

    if (widget.appointment != null) {
      _reasonController.text = widget.appointment!.visitReason;
      _timeController.text = widget.appointment!.time;
      _notesController.text = widget.appointment!.notes ?? "";

      _selectedDate = DateTime.tryParse(widget.appointment!.date);
      if (_selectedDate != null) {
        _apiDate = widget.appointment!.date;

        _dateController.text =
            "${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.year}";
      }
    } else {
      _selectedDate = DateTime.now();
      _apiDate =
          "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}";

      _dateController.text =
          "${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.year}";
    }

    if (widget.isClinicBooking && widget.clinicId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<AppointmentProvider>().fetchAvailableSlots(
          widget.clinicId!,
          _apiDate,
        );
      });
    }

    collectData();
  }

  @override
  void didUpdateWidget(covariant AppointmentForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedId != widget.selectedId) {
      collectData();
    }
  }

  @override
  void dispose() {
    _reasonController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _updateDate(DateTime pickedDate) {
    setState(() {
      _selectedDate = pickedDate;

      _apiDate =
          "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";

      _dateController.text =
          "${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}";

      _timeController.clear();
      _showAllSlots = false;
    });

    if (widget.isClinicBooking && widget.clinicId != null) {
      context.read<AppointmentProvider>().fetchAvailableSlots(
        widget.clinicId!,
        _apiDate,
      );
    }
    collectData();
  }

  void collectData() {
    final Map<String, dynamic> data = {
      "VisitReason": _reasonController.text.trim(),
      "Date": _apiDate,
      "StartTime": _timeController.text,
      "DurationInMinutes": 30,
      widget.idKey: widget.selectedId,
    };

    if (_notesController.text.trim().isNotEmpty) {
      data["Notes"] = _notesController.text.trim();
    }

    widget.onDataReady(data);
  }

  Future<void> _pickTime() async {
    TimeOfDay? pickedTime = await showCustomTimePickerDialog(
      context: context,
      title: context.l10n.timeLabel,
      initialTime: _timeController.text.isNotEmpty
          ? TimeOfDay(
              hour: int.parse(_timeController.text.split(':')[0]),
              minute: int.parse(_timeController.text.split(':')[1]),
            )
          : TimeOfDay.now(),
    );

    if (pickedTime != null) {
      if (!mounted) return;
      setState(() {
        // بنخزن الوقت في الـ Controller بصيغة HH:mm عشان يتبعت للباك إند صح
        _timeController.text =
            "${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}";
      });
      collectData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.selectorWidget,
          SizedBox(height: 16.h),

          Text(
            context.l10n.visitReasonLabel,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          CustomTextField(
            controller: _reasonController,
            onChanged: (_) => collectData(),
            hintText: context.l10n.visitReasonHint,
            validator: (value) => value == null || value.isEmpty
                ? context.l10n.fieldRequired
                : null,
          ),
          SizedBox(height: 16.h),

          Text(
            context.l10n.dateLabel,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Stack(
            children: [
              CustomTextField(
                controller: _dateController,
                prefixIcon: "assets/icons/calendar.svg",
              ),
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 30)),
                      );

                      if (!mounted) return;

                      if (pickedDate != null) {
                        _updateDate(pickedDate);
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          Text(
            context.l10n.timeLabel,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(height: 4.h),

          if (!widget.isClinicBooking)
            Stack(
              children: [
                CustomTextField(
                  controller: TextEditingController(
                    text: _timeController.text.isNotEmpty
                        ? DateHelper.formatTime(_timeController.text, context)
                        : "",
                  ),
                  hintText: "00:00",
                  prefixIcon: "assets/icons/clock.svg",
                ),
                Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(onTap: _pickTime),
                  ),
                ),
              ],
            )
          else
            Consumer<AppointmentProvider>(
              builder: (context, provider, child) {
                if (provider.isLoadingSlots) {
                  return const Center(child: CircularProgressIndicator());
                }

                List<String> allSlots = List.from(provider.availableSlots);

                // 🚨 1. الفلترة الذكية المنيعة
                if (_selectedDate != null) {
                  DateTime now = DateTime.now();
                  bool isToday =
                      _selectedDate!.year == now.year &&
                      _selectedDate!.month == now.month &&
                      _selectedDate!.day == now.day;

                  if (isToday) {
                    allSlots = allSlots.where((slot) {
                      try {
                        String cleanSlot = slot.trim().toLowerCase();

                        // دعم الـ AM/PM بالإنجليزي والعربي
                        bool isPM =
                            cleanSlot.contains('pm') || cleanSlot.contains('م');
                        bool isAM =
                            cleanSlot.contains('am') || cleanSlot.contains('ص');

                        // استخراج الأرقام والنقطتين فقط بـ Regex قوي (مثال: "11:30")
                        String timeOnly = cleanSlot.replaceAll(
                          RegExp(r'[^0-9:]'),
                          '',
                        );
                        List<String> parts = timeOnly.split(':');

                        if (parts.isNotEmpty) {
                          int hour = int.tryParse(parts[0]) ?? 0;
                          int minute = parts.length > 1
                              ? (int.tryParse(parts[1]) ?? 0)
                              : 0;

                          // التحويل لنظام 24 ساعة إذا لزم الأمر
                          if (isPM && hour < 12) {
                            hour += 12;
                          } else if (isAM && hour == 12) {
                            hour = 0;
                          }

                          DateTime slotTime = DateTime(
                            now.year,
                            now.month,
                            now.day,
                            hour,
                            minute,
                          );

                          return slotTime.isAfter(now);
                        }
                        return true;
                      } catch (e) {
                        return true;
                      }
                    }).toList();
                  }
                }

                // 🚨 2. التأكد من وجود الموعد القديم في حالة التعديل
                if (widget.appointment != null &&
                    _timeController.text.isNotEmpty) {
                  final currentTime = _timeController.text;

                  // مقارنة ذكية تتجاهل الثواني عشان تتوافق مع الباك إند
                  bool exists = allSlots.any((s) {
                    String sPrefix = s.length >= 5 ? s.substring(0, 5) : s;
                    String cPrefix = currentTime.length >= 5
                        ? currentTime.substring(0, 5)
                        : currentTime;
                    return sPrefix == cPrefix;
                  });

                  if (!exists) {
                    allSlots.insert(0, currentTime);
                  }
                }

                // 🚨 3. في حالة عدم وجود مواعيد
                if (allSlots.isEmpty) {
                  return Text(
                    context.l10n.noAvailableSlots,
                    style: Theme.of(
                      context,
                    ).textTheme.labelMedium?.copyWith(color: Colors.red),
                  );
                }

                final bool hasMoreSlots = allSlots.length > 9;
                final displaySlots = (_showAllSlots || !hasMoreSlots)
                    ? allSlots
                    : allSlots.take(9).toList();

                return Wrap(
                  spacing: 8.w,
                  runSpacing: 12.h,
                  children: [
                    ...displaySlots.map((slot) {
                      // مقارنة نظيفة تتجاهل الثواني والـ AM/PM لو موجودة
                      String slotPrefix = slot.length >= 5
                          ? slot.substring(0, 5)
                          : slot;
                      String controllerPrefix = _timeController.text.length >= 5
                          ? _timeController.text.substring(0, 5)
                          : _timeController.text;

                      final isSelected = slotPrefix == controllerPrefix;
                      final displayTime = DateHelper.formatTime(slot, context);

                      return SelectionChip(
                        label: displayTime,
                        isSelected: isSelected,
                        onTap: () {
                          // هنا بنحتفظ بقيمة الباك إند الأصلية (سواء كانت 24 ساعة أو 12)
                          setState(() => _timeController.text = slot);
                          collectData();
                        },
                      );
                    }),

                    if (hasMoreSlots && !_showAllSlots)
                      GestureDetector(
                        onTap: () {
                          setState(() => _showAllSlots = true);
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 8.h),
                          width: double.infinity,
                          child: Center(
                            child: Text(
                              "${context.l10n.showMoreBtn} (+${allSlots.length - 9})",
                              style: Theme.of(context).textTheme.titleMedium!
                                  .copyWith(fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),

          if (widget.middleContent != null) widget.middleContent!,
          SizedBox(height: 16.h),

          Text(
            context.l10n.additionalNotesLabel,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          CustomTextField(
            controller: _notesController,
            maxLines: 3,
            onChanged: (_) => collectData(),
            hintText: context.l10n.notesHint,
            validator: (value) => null,
          ),

          if (widget.isClinicBooking)
            Padding(
              padding: EdgeInsets.only(top: 12.h),
              child: Text(
                context.l10n.clinicConfirmationNotice,
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
        ],
      ),
    );
  }
}
