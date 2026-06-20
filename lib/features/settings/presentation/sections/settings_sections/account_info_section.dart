import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/controller/user_provider.dart';
import 'package:rafiq/core/helper/date_helper.dart';
import 'package:rafiq/core/helper/l10n_extension.dart';
import 'package:rafiq/core/widgets/custom_container.dart';
import 'package:rafiq/features/settings/presentation/Widgets/account_info_row.dart';

class AccountInfoSection extends StatefulWidget {
  const AccountInfoSection({super.key});

  @override
  State<AccountInfoSection> createState() => _AccountInfoSectionState();
}

class _AccountInfoSectionState extends State<AccountInfoSection> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().refreshBasicInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        final user = userProvider.user;

        if (user == null) {
          return const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final firstName = user.firstName;
        final lastName = user.lastName;
        final email = user.email;
        final phone = user.phone ?? "";
        DateTime joinedDate = user.joinedAt ?? DateTime.now();

        return CustomContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.account_information,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: AppDimensions.paddingM),

              // الاسم
              AccountInfoRow(
                label: context.l10n.name,
                value: "$firstName $lastName",
              ),
              const Divider(),

              // الإيميل
              AccountInfoRow(label: context.l10n.email, value: email),
              const Divider(),

              // رقم الهاتف
              AccountInfoRow(
                label: context.l10n.phone_number,
                value: phone.isEmpty ? "-" : phone,
                direction: TextDirection.ltr,
              ),
              const Divider(),

              // تاريخ الانضمام
              AccountInfoRow(
                label: context.l10n.join_date,
                value: DateHelper.formatYearMonth(joinedDate, context),
              ),
            ],
          ),
        );
      },
    );
  }
}
