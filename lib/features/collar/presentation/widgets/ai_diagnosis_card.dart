import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/core/widgets/custom_container.dart';
import 'package:rafiq/features/collar/data/models/ai_diagnosis_model.dart';
import 'package:rafiq/features/collar/presentation/widgets/semi_circle_gauge.dart';

class AiDiagnosisCard extends StatefulWidget {
  final AiDiagnosisModel diagnosis;

  const AiDiagnosisCard({super.key, required this.diagnosis});

  @override
  State<AiDiagnosisCard> createState() => _AiDiagnosisCardState();
}

class _AiDiagnosisCardState extends State<AiDiagnosisCard> {
  final GlobalKey _cardKey = GlobalKey();

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'healthy':
      case 'low':
        return const Color(0xFF00C950);
      case 'warning':
      case 'medium':
        return const Color(0xFFF5A623);
      case 'critical':
      case 'high':
        return const Color(0xFFD0021B);
      default:
        return Colors.grey;
    }
  }

  String _getLocalizedStatus(String status, BuildContext context) {
    switch (status.toLowerCase()) {
      case 'healthy':
        return context.l10n.statusHealthy;
      case 'warning':
        return context.l10n.statusWarning;
      case 'critical':
        return context.l10n.statusCritical;
      case 'low':
        return context.l10n.statusLow;
      case 'medium':
        return context.l10n.statusMedium;
      case 'high':
        return context.l10n.statusHigh;
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      key: _cardKey,
      margin: EdgeInsets.all(AppDimensions.paddingS),
      padding: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),

          onExpansionChanged: (isExpanded) {
            if (isExpanded) {
              Future.delayed(const Duration(milliseconds: 300), () {
                if (_cardKey.currentContext != null) {
                  Scrollable.ensureVisible(
                    _cardKey.currentContext!,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    alignment: 1.0,
                  );
                }
              });
            }
          },

          leading: Container(
            padding: EdgeInsets.all(8.r),
            decoration: const BoxDecoration(
              color: Colors.black87,
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              "assets/icons/ai_spark.svg",
              width: 16.r,
              height: 16.r,
            ),
          ),
          title: Text(
            context.l10n.aiDiagnosis,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w600),
          ),
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.w),
              child: Column(
                children: [
                  const Divider(),
                  SizedBox(height: 16.h),
                  _buildStatusGrid(context),
                  SizedBox(height: 16.h),
                  _buildSeverityScore(context),
                  SizedBox(height: 16.h),
                  _buildReasonRow(
                    context.l10n.motionLabel,
                    widget.diagnosis.motionReasons,
                    widget.diagnosis.motionStatus,
                    context,
                  ),
                  _buildReasonRow(
                    context.l10n.vitalsLabel,
                    widget.diagnosis.vitalReasons,
                    widget.diagnosis.vitalStatus,
                    context,
                  ),
                  _buildReasonRow(
                    context.l10n.summaryLabel,
                    widget.diagnosis.combinedReasons,
                    widget.diagnosis.finalStatus,
                    context,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusGrid(BuildContext context) => Column(
    children: [
      Row(
        children: [
          Expanded(
            child: _buildStatusBox(
              context.l10n.motionStatusLabel,
              widget.diagnosis.motionStatus,
              context,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: _buildStatusBox(
              context.l10n.vitalStatusLabel,
              widget.diagnosis.vitalStatus,
              context,
            ),
          ),
        ],
      ),
      SizedBox(height: 12.h),
      Row(
        children: [
          Expanded(
            child: _buildStatusBox(
              context.l10n.finalStatusLabel,
              widget.diagnosis.finalStatus,
              context,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: _buildStatusBox(
              context.l10n.alertLevelLabel,
              widget.diagnosis.alertLevel,
              context,
            ),
          ),
        ],
      ),
    ],
  );

  Widget _buildSeverityScore(BuildContext context) => Card(
    child: Padding(
      padding: EdgeInsets.all(12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.severityScoreLabel,
                  style: Theme.of(
                    context,
                  ).textTheme.labelSmall!.copyWith(fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 4.h),
                Text(
                  "${widget.diagnosis.severityScore} / 100",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: _getStatusColor(widget.diagnosis.finalStatus),
                    fontWeight: FontWeight.w500,
                    fontSize: 20.sp,
                  ),
                ),
              ],
            ),
          ),
          SemiCircleGauge(
            score: widget.diagnosis.severityScore,
            color: _getStatusColor(widget.diagnosis.finalStatus),
          ),
        ],
      ),
    ),
  );

  Widget _buildStatusBox(String title, String value, BuildContext context) =>
      Card(
        child: Padding(
          padding: EdgeInsets.all(12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.labelSmall!.copyWith(fontWeight: FontWeight.w500),
              ),
              Text(
                _getLocalizedStatus(value, context),
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: _getStatusColor(value),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildReasonRow(
    String title,
    List<String> reasons,
    String status,
    BuildContext context,
  ) {
    final bool isHealthy = status.toLowerCase() == 'healthy';
    final color = isHealthy ? const Color(0xFF00C950) : const Color(0xFFF5A623);
    return Card(
      margin: EdgeInsets.only(bottom: 8.h),
      child: Padding(
        padding: EdgeInsets.all(12.h),
        child: Row(
          children: [
            Icon(
              isHealthy ? Icons.check_circle : Icons.info_outline,
              color: color,
              size: 20.r,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    reasons.isNotEmpty
                        ? reasons.first
                        : context.l10n.noDataLabel,

                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
