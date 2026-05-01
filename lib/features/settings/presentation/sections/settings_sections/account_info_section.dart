import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/controller/user_provider.dart';
import 'package:rafiq/core/helper/date_helper.dart';
import 'package:rafiq/core/widgets/custom_container.dart';
import 'package:rafiq/features/settings/presentation/Widgets/account_info_row.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class AccountInfoSection extends StatelessWidget {
  const AccountInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        final user = userProvider.user;

        // 1. حماية: لو اليوزر مش موجود (لسه بيحمل أو حصل خطأ)، نعرض لودينج أو لا شيء
        if (user == null) {
          return const SizedBox();
        }

        return CustomContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.account_information,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: AppDimensions.paddingM),

              // 2. الاسم
              AccountInfoRow(
                label: AppLocalizations.of(context)!.name,
                value: "${user.firstName} ${user.lastName}",
              ),
              const Divider(),

              // 3. الإيميل
              AccountInfoRow(
                label: AppLocalizations.of(context)!.email,
                value: user.email,
              ),
              const Divider(),

              // 4. رقم الهاتف
              AccountInfoRow(
                label: AppLocalizations.of(context)!.phone_number,
                value: user.phone ?? "",
                direction: TextDirection.ltr,
              ),
              const Divider(),

              // 5. تاريخ الانضمام
              AccountInfoRow(
                label: AppLocalizations.of(context)!.join_date,
                value: DateHelper.formatYearMonth(
                  user.joinedAt ?? DateTime.now(),
                  context,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
