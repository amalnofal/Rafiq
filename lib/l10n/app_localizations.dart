import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// App name
  ///
  /// In en, this message translates to:
  /// **'Rafiq'**
  String get rafiq;

  /// Smart assistant for taking care of your pet
  ///
  /// In en, this message translates to:
  /// **'Smart assistant for taking care of your pet'**
  String get pet_care_assistant;

  /// Text asking the user if they don't have an account
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get no_account_question;

  /// Button label to create a new account
  ///
  /// In en, this message translates to:
  /// **'Create a new account'**
  String get create_new_account;

  /// Button label to log in using email
  ///
  /// In en, this message translates to:
  /// **'Log in with Email'**
  String get login_with_email;

  /// Button label to log in using Apple account
  ///
  /// In en, this message translates to:
  /// **'Log in with Apple'**
  String get login_with_apple;

  /// Button label to log in using Google account
  ///
  /// In en, this message translates to:
  /// **'Log in with Google'**
  String get login_with_google;

  /// Greeting message shown on home or login screen
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// Button or menu item for logging in
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Button or menu item for logging out
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Profile page title
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// Settings page title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Label for language selection
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Short name for English language
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get lan;

  /// Prompt to choose a language
  ///
  /// In en, this message translates to:
  /// **'Choose language'**
  String get choose_lan;

  /// Note about immediate language change
  ///
  /// In en, this message translates to:
  /// **'💡 The selected language will be applied immediately to all parts of the app.'**
  String get lan_note;

  /// Toggle for dark mode
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get dark_mode;

  /// General settings section title
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// Notifications section title
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Label for enabling notifications
  ///
  /// In en, this message translates to:
  /// **'Enable notifications'**
  String get enable_Notifications;

  /// Account section title
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// Account management section title
  ///
  /// In en, this message translates to:
  /// **'Account Management'**
  String get account_management;

  /// Account information section title
  ///
  /// In en, this message translates to:
  /// **'Account Information'**
  String get account_information;

  /// Personal information label
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personal_info;

  /// User's name label
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// User's email label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// User's phone number label
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// Full phone number label
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phone_number;

  /// Privacy and security section title
  ///
  /// In en, this message translates to:
  /// **'Privacy & Security'**
  String get privacy_security;

  /// Password label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Privacy label
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// User join date label
  ///
  /// In en, this message translates to:
  /// **'Join Date'**
  String get join_date;

  /// App version label
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// Last update label
  ///
  /// In en, this message translates to:
  /// **'Last update'**
  String get last_update;

  /// Danger zone section title
  ///
  /// In en, this message translates to:
  /// **'Danger Zone'**
  String get danger_zone;

  /// Button label to save changes
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get save_changes;

  /// Message shown when the user successfully saves changes
  ///
  /// In en, this message translates to:
  /// **'Changes saved successfully'**
  String get changes_saved;

  /// Button label to delete account
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get delete_account;

  /// Warning message for deleting account
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone'**
  String get warning_delete_account;

  /// Privacy info note shown to the user
  ///
  /// In en, this message translates to:
  /// **'🔒 We respect your privacy. You can control the information you share with the community at any time.'**
  String get privacy_note;

  /// Option to allow others to view user's profile
  ///
  /// In en, this message translates to:
  /// **'Public Profile'**
  String get profile_public;

  /// Subtitle for public profile option
  ///
  /// In en, this message translates to:
  /// **'Allow others to view your profile'**
  String get profile_public_sub;

  /// Option to show email in profile
  ///
  /// In en, this message translates to:
  /// **'Show Email'**
  String get show_email;

  /// Subtitle for email visibility option
  ///
  /// In en, this message translates to:
  /// **'Display your email on your profile'**
  String get show_email_sub;

  /// Option to show phone number in profile
  ///
  /// In en, this message translates to:
  /// **'Show Phone Number'**
  String get show_phone;

  /// Subtitle for phone number visibility option
  ///
  /// In en, this message translates to:
  /// **'Display your phone number on your profile'**
  String get show_phone_sub;

  /// Option to receive messages from users
  ///
  /// In en, this message translates to:
  /// **'Allow Messages'**
  String get allow_messages;

  /// Subtitle explaining the message receiving option
  ///
  /// In en, this message translates to:
  /// **'Receive messages from other users'**
  String get allow_messages_sub;

  /// Title for change password screen
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get change_password;

  /// Shows last password update time dynamically
  ///
  /// In en, this message translates to:
  /// **'Last updated: {time}'**
  String password_last_update(Object time);

  /// Action to log out
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get log_out;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
