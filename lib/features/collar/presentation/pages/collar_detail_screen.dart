import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/core/widgets/custom_container.dart';
import 'package:rafiq/core/widgets/rafiq_scaffold.dart';
import 'package:rafiq/core/controller/collar_provider.dart';
import 'package:rafiq/features/collar/presentation/widgets/ai_diagnosis_card.dart';
import 'package:rafiq/features/collar/presentation/widgets/collar_detail_header.dart';
import 'package:rafiq/features/home/presentation/widgets/dashboard/detailed_statistics/heart_rate_detailed_card.dart';
import 'package:rafiq/features/home/presentation/widgets/dashboard/detailed_statistics/location_detailed_card.dart';
import 'package:rafiq/features/home/presentation/widgets/dashboard/detailed_statistics/temperature_detailed_card.dart';

class CollarDetailScreen extends StatefulWidget {
  final Map<String, dynamic> collarData;

  const CollarDetailScreen({super.key, required this.collarData});

  @override
  State<CollarDetailScreen> createState() => _CollarDetailScreenState();
}

class _CollarDetailScreenState extends State<CollarDetailScreen> {
  late CollarProvider _collarProvider;

  @override
  void initState() {
    super.initState();
    _collarProvider = context.read<CollarProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 1. بنجيب الـ ID الحقيقي للحيوان
      final petId = int.tryParse(widget.collarData['petId'].toString()) ?? 0;

      // 2. بنبدأ سحب القراءات لايف
      _collarProvider.startPolling(petId);

      // 3. بنطلب تشخيص الذكاء الاصطناعي أوتوماتيك
      _collarProvider.fetchAiDiagnosis(petId);
    });
  }

  @override
  void dispose() {
    _collarProvider.stopPolling();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RafiqScaffold(
      padding: EdgeInsets.zero,
      body: Consumer<CollarProvider>(
        builder: (context, provider, child) {
          final reading = provider.latestReading;

          // نحدث وقت المزامنة لايف
          String liveSyncTime = widget.collarData['lastSync'] ?? '';
          if (reading != null) {
            liveSyncTime = reading.timestamp;
          }

          // نعمل نسخة جديدة من الداتا ونحط فيها الوقت الجديد
          final updatedCollarData = Map<String, dynamic>.from(
            widget.collarData,
          );
          updatedCollarData['lastSync'] = liveSyncTime;

          return Column(
            children: [
              CollarDetailHeader(
                collarData: updatedCollarData,
                onBackTap: () {
                  Navigator.pop(context);
                },
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    final petId =
                        int.tryParse(widget.collarData['petId'].toString()) ??
                        0;

                    _collarProvider.stopPolling();
                    _collarProvider.startPolling(petId);

                    await _collarProvider.fetchAiDiagnosis(petId);
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.all(AppDimensions.paddingS),
                      child: _buildStatsContent(provider),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // دالة مساعدة لعرض حالات (التحميل - الخطأ - الداتا الحقيقية)
  Widget _buildStatsContent(CollarProvider provider) {
    // حالة التحميل الأولية للقراءات
    if (provider.isLoading && provider.latestReading == null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(50.r),
          child: CircularProgressIndicator(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      );
    }

    // حالة وجود خطأ في جلب القراءات الأساسية
    if (provider.errorMessage != null && provider.latestReading == null) {
      return Center(child: Text(provider.errorMessage!));
    }

    final reading = provider.latestReading;

    return Column(
      children: [
        HeartRateDetailedCard(heartRate: reading?.heartRateBpm.round() ?? 0),
        TemperatureDetailedCard(
          temperature: reading?.temperatureCelsius ?? 0.0,
        ),
        LocationDetailedCard(
          latitude: reading?.latitude ?? 0.0,
          longitude: reading?.longitude ?? 0.0,
        ),

        if (provider.aiDiagnosis != null)
          AiDiagnosisCard(diagnosis: provider.aiDiagnosis!)
        else if (provider.isAiLoading)
          Padding(
            padding: EdgeInsets.all(30.r),
            child: const CircularProgressIndicator(),
          )
        else if (provider.aiErrorMessage != null)
          CustomContainer(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: SvgPicture.asset(
                  "assets/icons/ai_spark.svg",
                  width: 24.r,
                  height: 24.r,
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).colorScheme.primary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              title: Text(
                context.l10n.collectingDataForAnalysis,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              subtitle: Text(
                context.l10n.modelRequiresMinimumReadings,
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
          ),
      ],
    );
  }
}
