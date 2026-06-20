import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/core/controller/user_provider.dart';
import 'package:rafiq/core/widgets/loading_overlay.dart';
import 'package:rafiq/core/widgets/rafiq_scaffold.dart';
import 'package:rafiq/features/settings/presentation/sections/acc_manage_sections/danger_zone.dart';
import 'package:rafiq/features/settings/presentation/sections/acc_manage_sections/personal_info.dart';
import 'package:rafiq/features/settings/presentation/sections/acc_manage_sections/save_button.dart';
import 'package:rafiq/l10n/app_localizations.dart';

class AccountManagement extends StatefulWidget {
  const AccountManagement({super.key});

  @override
  State<AccountManagement> createState() => _AccountManagementState();
}

class _AccountManagementState extends State<AccountManagement> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();

    _fetchFreshData();
  }

  Future<void> _fetchFreshData() async {
    try {
      final data = await context.read<UserProvider>().fetchProfileForEdit();
      if (mounted) {
        setState(() {
          firstNameController.text =
              data['firstName'] ?? data['FirstName'] ?? '';
          lastNameController.text = data['lastName'] ?? data['LastName'] ?? '';

          emailController.text =
              data['newEmail'] ?? data['email'] ?? data['Email'] ?? '';
          phoneController.text =
              data['newPhoneNumber'] ??
              data['phoneNumber'] ??
              data['PhoneNumber'] ??
              '';

          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        final user = context.read<UserProvider>().user;
        setState(() {
          if (user != null) {
            firstNameController.text = user.firstName;
            lastNameController.text = user.lastName;
            emailController.text = user.email;
            phoneController.text = user.phone ?? '';
          }
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RafiqScaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.account_management),
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, _) {
          return Stack(
            children: [
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          PersonalInfo(
                            firstNameController: firstNameController,
                            lastNameController: lastNameController,
                            emailController: emailController,
                            phoneController: phoneController,
                          ),
                          SaveButton(
                            firstNameController: firstNameController,
                            lastNameController: lastNameController,
                            emailController: emailController,
                            phoneController: phoneController,
                          ),
                          SizedBox(height: AppDimensions.paddingXL),
                          const DangerZone(),
                        ],
                      ),
                    ),

              if (userProvider.isLoading) const LoadingOverlay(),
            ],
          );
        },
      ),
    );
  }

}
