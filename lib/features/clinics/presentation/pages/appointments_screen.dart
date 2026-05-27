import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/controller/appointment_provider.dart';
import 'package:rafiq/core/controller/clinic_provider.dart';
import 'package:rafiq/core/controller/pet_provider.dart';
import 'package:rafiq/core/controller/user_provider.dart';
import 'package:rafiq/core/helper/date_helper.dart';
import 'package:rafiq/core/helper/dialog_helper.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/core/models/user_model.dart';
import 'package:rafiq/core/widgets/circle_icon_button.dart';
import 'package:rafiq/core/widgets/custom_button.dart';
import 'package:rafiq/core/widgets/custom_container.dart';
import 'package:rafiq/core/widgets/rafiq_scaffold.dart';
import 'package:rafiq/features/clinics/presentation/widgets/appointments/add_clinic_apppointment_dialog.dart';
import 'package:rafiq/features/clinics/presentation/widgets/appointments/add_pet_appointment_dialog.dart';
import 'package:rafiq/features/clinics/presentation/widgets/appointments/appointment_card.dart';
import 'package:rafiq/features/clinics/presentation/widgets/appointments/appointment_type_selector.dart';
import 'package:rafiq/features/clinics/presentation/widgets/appointments/available_slots_dialog.dart';
import 'package:table_calendar/table_calendar.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  int _selectedFilterIndex = 0;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<AppointmentProvider>().fetchMyAppointments();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final provider = context.watch<AppointmentProvider>();

    // تجهيز الداتا لليوم المحدد
    final selectedDateStr =
        "${_selectedDay!.year}-${_selectedDay!.month.toString().padLeft(2, '0')}-${_selectedDay!.day.toString().padLeft(2, '0')}";

    final dayAppointments = provider.appointments.where((app) {
      return app.date.startsWith(selectedDateStr);
    }).toList();

    // حساب أرقام الفلاتر لليوم ده بس
    final pendingCount = dayAppointments.where((app) {
      final s = app.status.toLowerCase();
      return s == 'pending' || s == 'pendingapproval';
    }).length;
    final confirmedCount = dayAppointments
        .where((app) => app.status.toLowerCase() == 'confirmed')
        .length;
    final completedCount = dayAppointments
        .where((app) => app.status.toLowerCase() == 'completed')
        .length;

    final bool isDark = theme.brightness == Brightness.dark;

    final List<Map<String, dynamic>> filters = [
      {
        'title': '${context.l10n.allAppointments} (${dayAppointments.length})',
        'activeColor': primaryColor,
        'inactiveBg': theme.cardColor,
        'inactiveText': isDark ? Colors.grey[400] : Colors.grey[600],
      },
      {
        'title': '${context.l10n.pendingApproval} ($pendingCount)',
        'activeColor': primaryColor,
        'inactiveBg': isDark
            ? const Color(0xFFE87E41).withValues(alpha: 0.15)
            : const Color(0xFFFFF3EB),
        'inactiveText': const Color(0xFFE87E41),
      },
      {
        'title': '${context.l10n.confirmedAppointments} ($confirmedCount)',
        'activeColor': primaryColor,
        'inactiveBg': isDark
            ? const Color(0xFF155DFC).withValues(alpha: 0.15)
            : const Color(0xFFE0EFFF),
        'inactiveText': const Color(0xFF155DFC),
      },
      {
        'title': '${context.l10n.completedAppointments} ($completedCount)',
        'activeColor': primaryColor,
        'inactiveBg': isDark
            ? const Color(0xFF34C759).withValues(alpha: 0.15)
            : const Color(0xFFE0FBE8),
        'inactiveText': const Color(0xFF34C759),
      },
    ];

    // تطبيق الفلتر على المواعيد بتاعة اليوم
    final filteredAppointments = dayAppointments.where((app) {
      final s = app.status.toLowerCase();
      if (_selectedFilterIndex == 1) {
        return s == 'pending' || s == 'pendingapproval';
      }
      if (_selectedFilterIndex == 2) {
        return app.status.toLowerCase() == 'confirmed';
      }
      if (_selectedFilterIndex == 3) {
        return app.status.toLowerCase() == 'completed';
      }
      return true;
    }).toList();

    return RafiqScaffold(
      padding: EdgeInsets.zero,
      appBar: AppBar(
        title: Text(context.l10n.myAppointmentsTitle),
        centerTitle: false,
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: CircleIconButton(
              "assets/icons/add.svg",
              size: 38.h,
              iconSize: 18.h,
              bgColor: theme.colorScheme.primary,
              color: theme.colorScheme.onPrimary,
              onTap: () {
                final userProvider = context.read<UserProvider>();
                final petProvider = context.read<PetProvider>();
                final clinicProvider = context.read<ClinicProvider>();

                final isDoctor = userProvider.user?.role == UserType.vet;

                void showEmptyAlert({
                  required String title,
                  required String description,
                  required String buttonText,
                  required VoidCallback onAction,
                }) {
                  showDialog(
                    context: context,
                    builder: (alertContext) => CustomInfoDialog(
                      title: title,
                      description: description,
                      confirmBtnText: buttonText,
                      mainColor: theme.colorScheme.primary,
                      onConfirm: () {
                        Navigator.pop(alertContext);
                        onAction();
                      },
                    ),
                  );
                }

                if (isDoctor) {
                  showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (dialogContext) => AppointmentTypeSelector(
                      onPetAppointmentTap: () {
                        Navigator.pop(dialogContext);

                        if (petProvider.pets.isEmpty) {
                          showEmptyAlert(
                            title: context.l10n.noPetsFoundTitle,
                            description: context.l10n.noPetsFoundDescription,
                            buttonText: context.l10n.addPetBtn,
                            onAction: () {
                              Navigator.pushNamed(context, '/add_pet_screen');
                            },
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (_) => const AddPetAppointmentDialog(),
                          );
                        }
                      },
                      onClinicAppointmentTap: () {
                        Navigator.pop(dialogContext);

                        if (clinicProvider.clinics.isEmpty) {
                          showEmptyAlert(
                            title: context.l10n.noClinicsFoundTitle,
                            description: context.l10n.noClinicsFoundDescription,
                            buttonText: context.l10n.addClinicBtn,
                            onAction: () {
                              Navigator.pushNamed(
                                context,
                                '/add_clinic_screen',
                              );
                            },
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (_) => const AddClinicApppointmentDialog(),
                          );
                        }
                      },
                    ),
                  );
                } else {
                  if (petProvider.pets.isEmpty) {
                    showEmptyAlert(
                      title: context.l10n.noPetsFoundTitle,
                      description: context.l10n.noPetsFoundDescription,
                      buttonText: context.l10n.addPetBtn,
                      onAction: () {
                        Navigator.pushNamed(context, '/add_pet_screen');
                      },
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => const AddPetAppointmentDialog(),
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
      body: provider.isLoading && provider.appointments.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                await context.read<AppointmentProvider>().fetchMyAppointments();
              },
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  // 1. التقويم (Calendar)
                  SliverToBoxAdapter(
                    child: CustomContainer(
                      margin: EdgeInsets.all(AppDimensions.padding),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      child: TableCalendar(
                        availableGestures: AvailableGestures.horizontalSwipe,
                        firstDay: DateTime.utc(2020, 1, 1),
                        lastDay: DateTime.utc(2030, 12, 31),
                        focusedDay: _focusedDay,
                        selectedDayPredicate: (day) =>
                            isSameDay(_selectedDay, day),
                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {
                            _selectedDay = selectedDay;
                            _focusedDay = focusedDay;
                            _selectedFilterIndex = 0;
                          });
                        },
                        eventLoader: (day) {
                          final dayStr =
                              "${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}";

                          final hasActiveAppointments = provider.appointments
                              .any(
                                (app) =>
                                    app.date.startsWith(dayStr) &&
                                    app.status.toLowerCase() != 'completed' &&
                                    app.status.toLowerCase() != 'cancelled',
                              );
                          return hasActiveAppointments ? ['event'] : [];
                        },
                        headerStyle: HeaderStyle(
                          formatButtonVisible: false,
                          titleCentered: true,
                          titleTextStyle: theme.textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                          leftChevronIcon: _buildChevron(Icons.chevron_left),
                          rightChevronIcon: _buildChevron(Icons.chevron_right),
                        ),
                        calendarStyle: _buildCalendarStyle(theme),
                        calendarBuilders: CalendarBuilders(
                          markerBuilder: (context, day, events) =>
                              _buildMarker(day, events),
                        ),
                      ),
                    ),
                  ),

                  // 2. عنوان التاريخ وزرار المتاح
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDimensions.padding,
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            "assets/icons/calendar.svg",
                            height: 20.h,
                            colorFilter: ColorFilter.mode(
                              theme.colorScheme.primary,
                              BlendMode.srcIn,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Padding(
                            padding: EdgeInsets.only(top: 4.h),
                            child: Text(
                              isSameDay(_selectedDay, DateTime.now())
                                  ? context.l10n.todayAppointments
                                  : context.l10n.appointmentsOnDate(
                                      DateHelper.formatDayMonth(
                                        _selectedDay!,
                                        context,
                                      ),
                                    ),
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const Spacer(),

                          // 🚨 زرار "المواعيد المتاحة" للدكتور
                          if (context.read<UserProvider>().user?.role ==
                              UserType.vet)
                            CustomButton(
                              width: 80.w,
                              height: 40.h,
                              title: context.l10n.available,
                              onPressed: () {
                                final clinics = context
                                    .read<ClinicProvider>()
                                    .clinics;
                                final doctorClinic = clinics.isNotEmpty
                                    ? clinics.first
                                    : null;

                                showDialog(
                                  context: context,
                                  builder: (context) => AvailableSlotsDialog(
                                    selectedDate:
                                        _selectedDay ?? DateTime.now(),
                                    dayAppointments: dayAppointments,
                                    clinic: doctorClinic,
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(child: SizedBox(height: 16.h)),

                  // 3. الفلاتر
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 38.h,
                      child: ListView.separated(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimensions.padding,
                        ),
                        scrollDirection: Axis.horizontal,
                        itemCount: filters.length,
                        separatorBuilder: (_, _) => SizedBox(width: 8.w),
                        itemBuilder: (context, index) {
                          final filter = filters[index];
                          final isSelected = _selectedFilterIndex == index;
                          return GestureDetector(
                            onTap: () =>
                                setState(() => _selectedFilterIndex = index),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? filter['activeColor']
                                    : filter['inactiveBg'],
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                filter['title'],
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: isSelected
                                      ? Colors.white
                                      : filter['inactiveText'],
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(child: SizedBox(height: 16.h)),

                  // 4. لستة المواعيد
                  if (filteredAppointments.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody:
                          false, // لضمان إن المساحة الفاضية تتسحب عادي
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(30.h),
                          child: Text(
                            context.l10n.noAppointmentsToday,
                            style: theme.textTheme.labelMedium,
                          ),
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: EdgeInsets.only(
                        left: AppDimensions.padding,
                        right: AppDimensions.padding,
                        bottom: 40.h,
                      ),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => AppointmentCard(
                            appointment: filteredAppointments[index],
                          ),
                          childCount: filteredAppointments.length,
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }

  Widget _buildChevron(IconData icon) {
    return Container(
      padding: EdgeInsets.all(6.r),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 22.r),
    );
  }

  CalendarStyle _buildCalendarStyle(ThemeData theme) {
    return CalendarStyle(
      outsideDaysVisible: false,
      defaultTextStyle: theme.textTheme.bodyMedium!,
      weekendTextStyle: theme.textTheme.bodyMedium!,
      selectedDecoration: BoxDecoration(
        color: theme.colorScheme.primary,
        shape: BoxShape.circle,
      ),
      selectedTextStyle: theme.textTheme.bodyMedium!.copyWith(
        color: theme.colorScheme.onPrimary,
        fontWeight: FontWeight.bold,
      ),
      todayDecoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.15),
        shape: BoxShape.circle,
      ),
      todayTextStyle: theme.textTheme.bodyMedium!,
    );
  }

  Widget? _buildMarker(DateTime day, List events) {
    if (events.isEmpty) return null;
    final isSelected = isSameDay(_selectedDay, day);
    return Positioned(
      bottom: 6.h,
      child: Container(
        width: 6.r,
        height: 6.r,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected
              ? Theme.of(context).colorScheme.onPrimary
              : Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
