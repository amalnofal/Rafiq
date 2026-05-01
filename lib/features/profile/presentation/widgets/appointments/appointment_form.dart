import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/core/widgets/custom_text_field.dart';
import 'package:rafiq/features/profile/data/models/appointment_model.dart';

class AppointmentForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final Function(Map<String, dynamic> data) onDataReady;
  final AppointmentModel? appointment;

  final Widget selectorWidget;
  final String? selectedId;
  final String idKey;
    final Widget? middleContent; 

  const AppointmentForm({
    super.key,
    required this.formKey,
    required this.onDataReady,
    required this.selectorWidget,
    required this.idKey,
    this.selectedId,
    this.appointment,
    this.middleContent, 
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
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();

    if (widget.appointment != null) {
      _reasonController.text = widget.appointment!.visitReason;
      _notesController.text = widget.appointment!.notes ?? "";
      _dateController.text = widget.appointment!.date;
      _timeController.text = widget.appointment!.time;

      _selectedDate = DateTime.tryParse(widget.appointment!.date);

      try {
        List<String> timeParts = widget.appointment!.time.split(':');
        _selectedTime = TimeOfDay(
          hour: int.parse(timeParts[0]),
          minute: int.parse(timeParts[1]),
        );
      } catch (_) {
        _selectedTime = null;
      }
    }
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

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = "${picked.year}/${picked.month}/${picked.day}";
      });
      collectData();
    }
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.input,
      builder: (BuildContext context, Widget? child) {
        return Localizations.override(
          context: context,
          locale: const Locale('en', 'US'),
          child: Theme(
            data: Theme.of(context).copyWith(
              timePickerTheme: TimePickerThemeData(
                hourMinuteTextColor: Theme.of(context).colorScheme.onSurface,
                hourMinuteColor: Theme.of(context).scaffoldBackgroundColor,
                entryModeIconColor: Theme.of(context).colorScheme.primary,
              ),
              inputDecorationTheme: InputDecorationTheme(
                fillColor: Colors.grey.shade200,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            child: child!,
          ),
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
        _timeController.text = picked.format(context);
      });
      collectData();
    }
  }

  void collectData() {
    if (widget.selectedId == null ||
        _selectedDate == null ||
        _selectedTime == null) {
      return;
    }

    final dateStr =
        "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}";
    final timeStr =
        "${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}:00";

    widget.onDataReady({
      widget.idKey: int.tryParse(widget.selectedId!) ?? 0,
      "Date": dateStr,
      "Time": timeStr,
      "VisitReason": _reasonController.text.trim(),
      "Notes": _notesController.text.trim(),
    });
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
            hintText: context.l10n.visitReasonHint,
            onChanged: (_) => collectData(),
          ),
          SizedBox(height: 8.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.dateLabel,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    SizedBox(height: 4.h),
                    InkWell(
                      onTap: _pickDate,
                      child: AbsorbPointer(
                        child: CustomTextField(
                          controller: _dateController,
                          enabled: true,
                          hintText: context.l10n.dateHintText,
                          prefixIcon: "assets/icons/calendar.svg",
                          borderColor: Theme.of(context).dividerColor,
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.timeLabel,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    SizedBox(height: 4.h),
                    InkWell(
                      onTap: _pickTime,
                      child: AbsorbPointer(
                        child: CustomTextField(
                          controller: _timeController,
                          enabled: true,
                          hintText: context.l10n.timeHintText,
                          borderColor: Theme.of(context).dividerColor,
                          prefixIcon: "assets/icons/time.svg",
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          if (widget.middleContent != null) 
            widget.middleContent!,

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
        ],
      ),
    );
  }
}