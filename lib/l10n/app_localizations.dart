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

  /// No description provided for @onboarding_title_1.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Rafiq !'**
  String get onboarding_title_1;

  /// No description provided for @onboarding_desc_1.
  ///
  /// In en, this message translates to:
  /// **'Your complete platform connecting pet owners and expert vets for ideal, comprehensive care.'**
  String get onboarding_desc_1;

  /// No description provided for @onboarding_title_2.
  ///
  /// In en, this message translates to:
  /// **'Smart Collar !'**
  String get onboarding_title_2;

  /// No description provided for @onboarding_desc_2.
  ///
  /// In en, this message translates to:
  /// **'Track location, monitor health metrics, and understand their condition, powered by AI.'**
  String get onboarding_desc_2;

  /// No description provided for @onboarding_title_3.
  ///
  /// In en, this message translates to:
  /// **'Vet Clinics !'**
  String get onboarding_title_3;

  /// No description provided for @onboarding_desc_3.
  ///
  /// In en, this message translates to:
  /// **'Browse available clinics, choose the right vet for your pet, and book smoothly.'**
  String get onboarding_desc_3;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// Smart assistant for taking care of your pet
  ///
  /// In en, this message translates to:
  /// **'Smart assistant for taking care of your pet'**
  String get pet_care_assistant;

  /// No description provided for @welcomeToRafiq.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Rafiq !'**
  String get welcomeToRafiq;

  /// Subtitle in the pet owner's home empty state
  ///
  /// In en, this message translates to:
  /// **'Start your pet care journey\nAdd your pet to start tracking its health'**
  String get welcomeSubtitle;

  /// Button to add the first pet
  ///
  /// In en, this message translates to:
  /// **'Add Your Pet'**
  String get addPetBtn;

  /// No description provided for @editPetTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Pet Details'**
  String get editPetTitle;

  /// No description provided for @removePetTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove Pet'**
  String get removePetTitle;

  /// No description provided for @removePetDesc.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove'**
  String get removePetDesc;

  /// No description provided for @actionCannotBeUndone.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get actionCannotBeUndone;

  /// No description provided for @removeBtn.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get removeBtn;

  /// No description provided for @tipTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick Tip'**
  String get tipTitle;

  /// No description provided for @ownerTipContent.
  ///
  /// In en, this message translates to:
  /// **'After adding your pet, you can order a smart collar for comprehensive monitoring of its health and activity in real-time!'**
  String get ownerTipContent;

  /// No description provided for @vetTipContent.
  ///
  /// In en, this message translates to:
  /// **'Complete your clinic profile by adding working hours and available services to make it easier for pet owners to contact you and book appointments!'**
  String get vetTipContent;

  /// No description provided for @healthTrackingTitle.
  ///
  /// In en, this message translates to:
  /// **'Health Tracker'**
  String get healthTrackingTitle;

  /// No description provided for @healthTrackingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Track pulse, activity, and temperature'**
  String get healthTrackingSubtitle;

  /// No description provided for @communityTitle.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get communityTitle;

  /// No description provided for @communitySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Connect with other pet lovers'**
  String get communitySubtitle;

  /// No description provided for @vetClinicsTitle.
  ///
  /// In en, this message translates to:
  /// **'Vet Clinics'**
  String get vetClinicsTitle;

  /// No description provided for @vetClinicsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Certified clinics and appointment management'**
  String get vetClinicsSubtitle;

  /// No description provided for @storeTitle.
  ///
  /// In en, this message translates to:
  /// **'Pet Shop'**
  String get storeTitle;

  /// No description provided for @storeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Everything your pet needs'**
  String get storeSubtitle;

  /// Text asking the user if they don't have an account
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get no_account_question;

  /// App bar title for sign up screen
  ///
  /// In en, this message translates to:
  /// **'Create New Account'**
  String get create_new_account;

  /// Title text in sign up screen
  ///
  /// In en, this message translates to:
  /// **'Join Rafiq Community'**
  String get joinRafiq;

  /// Subtitle text in sign up screen
  ///
  /// In en, this message translates to:
  /// **'Create your account to enjoy all features'**
  String get signUpSubtitle;

  /// first name label
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// last name label
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// Label for email text field
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get email;

  /// Full phone number label
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phone_number;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'(optional)'**
  String get optional;

  /// No description provided for @genderLabel.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get genderLabel;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @dateOfBirthLabel.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirthLabel;

  /// No description provided for @dobHint.
  ///
  /// In en, this message translates to:
  /// **'dd/mm/yyyy'**
  String get dobHint;

  /// No description provided for @set_date.
  ///
  /// In en, this message translates to:
  /// **'Set date'**
  String get set_date;

  /// No description provided for @set.
  ///
  /// In en, this message translates to:
  /// **'Set'**
  String get set;

  /// No description provided for @chooseAccountType.
  ///
  /// In en, this message translates to:
  /// **'Choose Account Type'**
  String get chooseAccountType;

  /// No description provided for @chooseAccountTypeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select how you want to use the app'**
  String get chooseAccountTypeSubtitle;

  /// No description provided for @adminTitle.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get adminTitle;

  /// No description provided for @petOwnerTitle.
  ///
  /// In en, this message translates to:
  /// **'Pet Owner'**
  String get petOwnerTitle;

  /// No description provided for @petOwnerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage your pets\' health and connect with the community'**
  String get petOwnerSubtitle;

  /// No description provided for @petInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Pet Information'**
  String get petInfoTitle;

  /// No description provided for @petInfoSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tell us a little about your little friend'**
  String get petInfoSubtitle;

  /// No description provided for @petNameHint.
  ///
  /// In en, this message translates to:
  /// **'Pet Name'**
  String get petNameHint;

  /// No description provided for @petTypeHint.
  ///
  /// In en, this message translates to:
  /// **'Type (e.g. Dog, Cat)'**
  String get petTypeHint;

  /// No description provided for @vetTitle.
  ///
  /// In en, this message translates to:
  /// **'Veterinarian'**
  String get vetTitle;

  /// No description provided for @vetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Offer your services as a licensed veterinarian'**
  String get vetSubtitle;

  /// No description provided for @professionalInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Professional Info'**
  String get professionalInfoTitle;

  /// No description provided for @professionalInfoSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Verify your professional identity'**
  String get professionalInfoSubtitle;

  /// No description provided for @specializationLabel.
  ///
  /// In en, this message translates to:
  /// **'Specialization'**
  String get specializationLabel;

  /// No description provided for @subSpecializationLabel.
  ///
  /// In en, this message translates to:
  /// **'Sub-specialization'**
  String get subSpecializationLabel;

  /// No description provided for @idFrontLabel.
  ///
  /// In en, this message translates to:
  /// **'National ID (Front Side)'**
  String get idFrontLabel;

  /// No description provided for @idBackLabel.
  ///
  /// In en, this message translates to:
  /// **'National ID (Back Side)'**
  String get idBackLabel;

  /// No description provided for @uploadIdText.
  ///
  /// In en, this message translates to:
  /// **'Tap to upload image'**
  String get uploadIdText;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @vetCardLabel.
  ///
  /// In en, this message translates to:
  /// **'Veterinary ID Card'**
  String get vetCardLabel;

  /// No description provided for @supportedFormats.
  ///
  /// In en, this message translates to:
  /// **'JPG, PNG or HEIC'**
  String get supportedFormats;

  /// No description provided for @reviewNote.
  ///
  /// In en, this message translates to:
  /// **'Your professional info will be reviewed by our team within 24-48 hours for verification'**
  String get reviewNote;

  /// No description provided for @shareInterests.
  ///
  /// In en, this message translates to:
  /// **'Share your interests'**
  String get shareInterests;

  /// No description provided for @communityWaiting.
  ///
  /// In en, this message translates to:
  /// **'Rafiq community is waiting for you'**
  String get communityWaiting;

  /// No description provided for @interestsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tell us what you care about so we can curate the perfect feed for you'**
  String get interestsSubtitle;

  /// No description provided for @selectMultiple.
  ///
  /// In en, this message translates to:
  /// **'(You can select multiple)'**
  String get selectMultiple;

  /// No description provided for @selectInterestError.
  ///
  /// In en, this message translates to:
  /// **'Please select at least one interest to continue'**
  String get selectInterestError;

  /// Password label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Label/Hint for current password field
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPassword;

  /// Label/Hint for new password field
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// Label for confirm password text field
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @invalidEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get invalidEmailAddress;

  /// No description provided for @invalidPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get invalidPhoneNumber;

  /// No description provided for @passwordRuleLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get passwordRuleLength;

  /// No description provided for @passwordTooLong.
  ///
  /// In en, this message translates to:
  /// **'Password is too long'**
  String get passwordTooLong;

  /// No description provided for @passwordRuleUpperCase.
  ///
  /// In en, this message translates to:
  /// **'Must contain an uppercase letter (A-Z)'**
  String get passwordRuleUpperCase;

  /// No description provided for @passwordRuleLowerCase.
  ///
  /// In en, this message translates to:
  /// **'Must contain a lowercase letter (a-z)'**
  String get passwordRuleLowerCase;

  /// No description provided for @passwordRuleNumber.
  ///
  /// In en, this message translates to:
  /// **'Must contain a number (0-9)'**
  String get passwordRuleNumber;

  /// No description provided for @passwordRuleSymbol.
  ///
  /// In en, this message translates to:
  /// **'Must contain a special character (!@#\$)'**
  String get passwordRuleSymbol;

  /// No description provided for @passwordRequirements.
  ///
  /// In en, this message translates to:
  /// **'Password Requirements:'**
  String get passwordRequirements;

  /// No description provided for @passwordRuleCase.
  ///
  /// In en, this message translates to:
  /// **'Uppercase and lowercase letters'**
  String get passwordRuleCase;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @ageTooYoung.
  ///
  /// In en, this message translates to:
  /// **'You must be at least 18 years old'**
  String get ageTooYoung;

  /// Error message when the name field is empty
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameRequired;

  /// Error message when the name is less than the required length
  ///
  /// In en, this message translates to:
  /// **'Name is too short'**
  String get nameTooShort;

  /// No description provided for @textTooShort3.
  ///
  /// In en, this message translates to:
  /// **'Must be at least 3 characters'**
  String get textTooShort3;

  /// No description provided for @nameTooLong.
  ///
  /// In en, this message translates to:
  /// **'Name must not exceed 50 characters'**
  String get nameTooLong;

  /// Error message when a field is empty
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get fieldRequired;

  /// No description provided for @invalidDate.
  ///
  /// In en, this message translates to:
  /// **'Please select a valid past date.'**
  String get invalidDate;

  /// No description provided for @genderRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Please select gender'**
  String get genderRequiredError;

  /// No description provided for @petTypeRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Please select type'**
  String get petTypeRequiredError;

  /// No description provided for @invalidData.
  ///
  /// In en, this message translates to:
  /// **'Invalid data provided'**
  String get invalidData;

  /// No description provided for @registrationFailed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed, please try again'**
  String get registrationFailed;

  /// No description provided for @registrationSuccess.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully!'**
  String get registrationSuccess;

  /// No description provided for @emailAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'This email is already registered, please log in.'**
  String get emailAlreadyExists;

  /// No description provided for @userNotFound.
  ///
  /// In en, this message translates to:
  /// **'User not found'**
  String get userNotFound;

  /// No description provided for @loginSuccess.
  ///
  /// In en, this message translates to:
  /// **'Login successful, welcome back!'**
  String get loginSuccess;

  /// No description provided for @connectionError.
  ///
  /// In en, this message translates to:
  /// **'Please check your internet connection and try again.'**
  String get connectionError;

  /// No description provided for @imageUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Sorry, photo update failed. Ensure the format is supported (jpg, png).'**
  String get imageUpdateFailed;

  /// No description provided for @sessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Session expired, please log in again.'**
  String get sessionExpired;

  /// No description provided for @serverError.
  ///
  /// In en, this message translates to:
  /// **'Server error occurred, please try again later.'**
  String get serverError;

  /// No description provided for @unexpectedError.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred, please try again later.'**
  String get unexpectedError;

  /// No description provided for @imageUpdated.
  ///
  /// In en, this message translates to:
  /// **'Image updated successfully!'**
  String get imageUpdated;

  /// No description provided for @wrongCredentials.
  ///
  /// In en, this message translates to:
  /// **'Wrong email or password'**
  String get wrongCredentials;

  /// First part of terms agreement text
  ///
  /// In en, this message translates to:
  /// **'By creating an account, you agree to '**
  String get termsAgreementStart;

  /// Link text for terms
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get termsAndConditions;

  /// Conjunction text
  ///
  /// In en, this message translates to:
  /// **' & '**
  String get and;

  /// Link text for privacy policy
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// Question shown at the bottom of sign in screen
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get dontHaveAccount;

  /// Divider text
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// Google sign up button text
  ///
  /// In en, this message translates to:
  /// **'Sign up with Google'**
  String get signUpWithGoogle;

  /// Apple sign up button text
  ///
  /// In en, this message translates to:
  /// **'Sign up with Apple'**
  String get signUpWithApple;

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

  /// Question shown at the bottom of sign up screen
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// Label for the back button in the app bar/header
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// Label for the next button in the app bar/header
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @submitForReviewBtn.
  ///
  /// In en, this message translates to:
  /// **'Submit for Review'**
  String get submitForReviewBtn;

  /// App bar title for sign in screen
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get login;

  /// No description provided for @startJourney.
  ///
  /// In en, this message translates to:
  /// **'Start Your Journey'**
  String get startJourney;

  /// Welcome message displayed in the auth header
  ///
  /// In en, this message translates to:
  /// **'Welcome back to Rafiq'**
  String get welcomeBack;

  /// Subtitle text in sign in screen
  ///
  /// In en, this message translates to:
  /// **'Log in to continue'**
  String get signInSubtitle;

  /// Forgot password text button
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @invalidCode.
  ///
  /// In en, this message translates to:
  /// **'Invalid or expired code'**
  String get invalidCode;

  /// No description provided for @codeSent.
  ///
  /// In en, this message translates to:
  /// **'Verification code sent to your email'**
  String get codeSent;

  /// No description provided for @passwordResetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password reset successfully, please login'**
  String get passwordResetSuccess;

  /// No description provided for @recoverPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get recoverPassword;

  /// No description provided for @enterEmailSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address'**
  String get enterEmailSubtitle;

  /// No description provided for @sendCode.
  ///
  /// In en, this message translates to:
  /// **'Send Verification Code'**
  String get sendCode;

  /// No description provided for @verificationCodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Verification Code'**
  String get verificationCodeTitle;

  /// Subtitle containing the user email
  ///
  /// In en, this message translates to:
  /// **'We sent a code to {email}'**
  String verificationCodeSubtitle(String email);

  /// No description provided for @resendCodeText.
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get resendCodeText;

  /// Just the seconds count with unit
  ///
  /// In en, this message translates to:
  /// **' {count}s'**
  String second(int count);

  /// No description provided for @verifyCodeButton.
  ///
  /// In en, this message translates to:
  /// **'Verify Code'**
  String get verifyCodeButton;

  /// Subtitle advising the user to pick a secure password
  ///
  /// In en, this message translates to:
  /// **'Choose a strong password'**
  String get chooseStrongPassword;

  /// Button text or title for the change password action
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// Button or menu item for logging out
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Bottom navigation bar item: Home
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Profile page title
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @noNotificationsYet.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get noNotificationsYet;

  /// No description provided for @notificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Stay updated on your pet\'s health,\n appointments, and more.'**
  String get notificationsSubtitle;

  /// No description provided for @followBtn.
  ///
  /// In en, this message translates to:
  /// **'Follow'**
  String get followBtn;

  /// No description provided for @unfollowBtn.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get unfollowBtn;

  /// No description provided for @noSearchResults.
  ///
  /// In en, this message translates to:
  /// **'No results found for \'\'{query}\'\''**
  String noSearchResults(String query);

  /// No description provided for @commentDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Comment deleted successfully'**
  String get commentDeletedSuccessfully;

  /// No description provided for @commentEditedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Comment edited successfully'**
  String get commentEditedSuccessfully;

  /// No description provided for @manageAppointmentsBtn.
  ///
  /// In en, this message translates to:
  /// **'Manage Appointments'**
  String get manageAppointmentsBtn;

  /// Button or title to add a new appointment
  ///
  /// In en, this message translates to:
  /// **'Add Appointment'**
  String get addAppointment;

  /// No description provided for @editAppointment.
  ///
  /// In en, this message translates to:
  /// **'Edit Appointment'**
  String get editAppointment;

  /// No description provided for @myAppointmentsTitle.
  ///
  /// In en, this message translates to:
  /// **'My Appointments'**
  String get myAppointmentsTitle;

  /// No description provided for @allAppointments.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allAppointments;

  /// Status for appointments waiting to be accepted
  ///
  /// In en, this message translates to:
  /// **'Pending Approval'**
  String get pendingApproval;

  /// No description provided for @confirmedAppointments.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get confirmedAppointments;

  /// No description provided for @completedAppointments.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completedAppointments;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @confirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get confirmed;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @markAsCompleted.
  ///
  /// In en, this message translates to:
  /// **'Mark as Completed'**
  String get markAsCompleted;

  /// No description provided for @todayAppointments.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Appointments'**
  String get todayAppointments;

  /// No description provided for @appointmentsOnDate.
  ///
  /// In en, this message translates to:
  /// **'Appointments on {date}'**
  String appointmentsOnDate(String date);

  /// Title for the delete confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Delete Appointment'**
  String get deleteAppointmentTitle;

  /// Message body for delete confirmation
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this appointment?'**
  String get deleteConfirmationMessage;

  /// Used as a prefix, e.g., Appointment for Max
  ///
  /// In en, this message translates to:
  /// **'Appointment for'**
  String get appointmentFor;

  /// No description provided for @petLabel.
  ///
  /// In en, this message translates to:
  /// **'Pet'**
  String get petLabel;

  /// No description provided for @clinicLabel.
  ///
  /// In en, this message translates to:
  /// **'Clinic'**
  String get clinicLabel;

  /// No description provided for @noPetsFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'No Pets Found'**
  String get noPetsFoundTitle;

  /// No description provided for @noPetsFoundDescription.
  ///
  /// In en, this message translates to:
  /// **'You must add a pet first to be able to book an appointment for it.'**
  String get noPetsFoundDescription;

  /// No description provided for @noClinicsFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'No Clinics Found'**
  String get noClinicsFoundTitle;

  /// No description provided for @noClinicsFoundDescription.
  ///
  /// In en, this message translates to:
  /// **'You must add a clinic first to be able to book a work appointment in it.'**
  String get noClinicsFoundDescription;

  /// No description provided for @okButton.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get okButton;

  /// No description provided for @noAppointmentsToday.
  ///
  /// In en, this message translates to:
  /// **'No appointments for this day'**
  String get noAppointmentsToday;

  /// No description provided for @appointmentAddedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Appointment added successfully!'**
  String get appointmentAddedSuccess;

  /// No description provided for @appointmentUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Appointment updated successfully!'**
  String get appointmentUpdatedSuccess;

  /// No description provided for @phoneNumberNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Phone number is not available.'**
  String get phoneNumberNotAvailable;

  /// No description provided for @appointmentBookingSuccess.
  ///
  /// In en, this message translates to:
  /// **'Booking request sent successfully and is awaiting doctor\'s confirmation.'**
  String get appointmentBookingSuccess;

  /// No description provided for @selectPetLabel.
  ///
  /// In en, this message translates to:
  /// **'Select Pet'**
  String get selectPetLabel;

  /// Label for the clinic selection section in appointment form
  ///
  /// In en, this message translates to:
  /// **'Select Clinic'**
  String get selectClinicLabel;

  /// No description provided for @visitReasonLabel.
  ///
  /// In en, this message translates to:
  /// **'Visit Reason'**
  String get visitReasonLabel;

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateLabel;

  /// No description provided for @timeLabel.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get timeLabel;

  /// No description provided for @additionalNotesLabel.
  ///
  /// In en, this message translates to:
  /// **'Additional Notes'**
  String get additionalNotesLabel;

  /// No description provided for @notesHint.
  ///
  /// In en, this message translates to:
  /// **'Add any notes here...'**
  String get notesHint;

  /// Hint text for the visit reason field
  ///
  /// In en, this message translates to:
  /// **'e.g., Annual checkup, vaccination...'**
  String get visitReasonHint;

  /// Hint showing the date format
  ///
  /// In en, this message translates to:
  /// **'DD/MM/YYYY'**
  String get dateHintText;

  /// Hint showing the time format
  ///
  /// In en, this message translates to:
  /// **'00:00'**
  String get timeHintText;

  /// No description provided for @privateAppointment.
  ///
  /// In en, this message translates to:
  /// **'Private Appointment'**
  String get privateAppointment;

  /// No description provided for @followingLabel.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get followingLabel;

  /// No description provided for @followersLabel.
  ///
  /// In en, this message translates to:
  /// **'Followers'**
  String get followersLabel;

  /// No description provided for @postsCountLabel.
  ///
  /// In en, this message translates to:
  /// **'Posts'**
  String get postsCountLabel;

  /// No description provided for @userPetsTitle.
  ///
  /// In en, this message translates to:
  /// **'Pets'**
  String get userPetsTitle;

  /// No description provided for @myPetsTitle.
  ///
  /// In en, this message translates to:
  /// **'My Pets'**
  String get myPetsTitle;

  /// Title for the screen or section to add a new pet
  ///
  /// In en, this message translates to:
  /// **'Add New Pet'**
  String get addNewPetTitle;

  /// No description provided for @addPetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Pet added successfully'**
  String get addPetSuccess;

  /// No description provided for @addNewClinicTitle.
  ///
  /// In en, this message translates to:
  /// **'Add New Clinic'**
  String get addNewClinicTitle;

  /// No description provided for @editClinicTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Clinic Details'**
  String get editClinicTitle;

  /// No description provided for @addClinicSuccess.
  ///
  /// In en, this message translates to:
  /// **'Clinic added successfully'**
  String get addClinicSuccess;

  /// Label for the image picker to add a photo of the pet
  ///
  /// In en, this message translates to:
  /// **'Add Pet Photo'**
  String get addPetPhoto;

  /// Header for the basic information section
  ///
  /// In en, this message translates to:
  /// **'Basic Info'**
  String get basicInfoSection;

  /// No description provided for @petTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Pet Type'**
  String get petTypeLabel;

  /// No description provided for @weightLabel.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weightLabel;

  /// No description provided for @kgLabel.
  ///
  /// In en, this message translates to:
  /// **'kg'**
  String get kgLabel;

  /// No description provided for @colorLabel.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get colorLabel;

  /// No description provided for @colorHint.
  ///
  /// In en, this message translates to:
  /// **'Brown, white..'**
  String get colorHint;

  /// No description provided for @cat.
  ///
  /// In en, this message translates to:
  /// **'Cat'**
  String get cat;

  /// No description provided for @dog.
  ///
  /// In en, this message translates to:
  /// **'Dog'**
  String get dog;

  /// No description provided for @rabbit.
  ///
  /// In en, this message translates to:
  /// **'Rabbit'**
  String get rabbit;

  /// No description provided for @bird.
  ///
  /// In en, this message translates to:
  /// **'Bird'**
  String get bird;

  /// No description provided for @turtle.
  ///
  /// In en, this message translates to:
  /// **'Turtle'**
  String get turtle;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @petAgeYears.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Less than a year} =1{1 year} other{{count} years}}'**
  String petAgeYears(int count);

  /// No description provided for @petAgeMonths.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Less than a month} =1{1 month} other{{count} months}}'**
  String petAgeMonths(int count);

  /// No description provided for @breedLabel.
  ///
  /// In en, this message translates to:
  /// **'Breed'**
  String get breedLabel;

  /// No description provided for @submitAddPetBtn.
  ///
  /// In en, this message translates to:
  /// **'Add Pet'**
  String get submitAddPetBtn;

  /// Success message when a pet is removed
  ///
  /// In en, this message translates to:
  /// **'Pet removed successfully'**
  String get removePetSuccess;

  /// Button to expand a list
  ///
  /// In en, this message translates to:
  /// **'Show More'**
  String get showMoreBtn;

  /// No description provided for @showLessBtn.
  ///
  /// In en, this message translates to:
  /// **'Show Less'**
  String get showLessBtn;

  /// Title for the vet's clinics section in profile
  ///
  /// In en, this message translates to:
  /// **'My Clinics'**
  String get myClinicsTitle;

  /// No description provided for @noPetsAdded.
  ///
  /// In en, this message translates to:
  /// **'No pets added.'**
  String get noPetsAdded;

  /// No description provided for @noClinicsAdded.
  ///
  /// In en, this message translates to:
  /// **'No clinics added.'**
  String get noClinicsAdded;

  /// No description provided for @clinicNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Clinic Name'**
  String get clinicNameLabel;

  /// No description provided for @clinicAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get clinicAddressLabel;

  /// No description provided for @clinicScheduleTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Clinic Schedule'**
  String get clinicScheduleTitle;

  /// No description provided for @selectAtLeastOneDay.
  ///
  /// In en, this message translates to:
  /// **'You must select at least one day'**
  String get selectAtLeastOneDay;

  /// No description provided for @saturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get saturday;

  /// No description provided for @sunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get sunday;

  /// No description provided for @monday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get friday;

  /// No description provided for @noAvailableSlots.
  ///
  /// In en, this message translates to:
  /// **'Sorry, there are no available slots on this day'**
  String get noAvailableSlots;

  /// No description provided for @daily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get daily;

  /// No description provided for @dailyExcept.
  ///
  /// In en, this message translates to:
  /// **'Daily except'**
  String get dailyExcept;

  /// No description provided for @startTime.
  ///
  /// In en, this message translates to:
  /// **'Start Time'**
  String get startTime;

  /// No description provided for @endTime.
  ///
  /// In en, this message translates to:
  /// **'End Time'**
  String get endTime;

  /// No description provided for @selectTimeError.
  ///
  /// In en, this message translates to:
  /// **'You must select start and end times'**
  String get selectTimeError;

  /// No description provided for @fromTime.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get fromTime;

  /// No description provided for @toTime.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get toTime;

  /// No description provided for @open24Hours.
  ///
  /// In en, this message translates to:
  /// **'Open 24 Hours'**
  String get open24Hours;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @clinicDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Write a brief description of the clinic and its services...'**
  String get clinicDescriptionHint;

  /// No description provided for @uploadClinicPhotoHint.
  ///
  /// In en, this message translates to:
  /// **'Upload your clinic\'s photo'**
  String get uploadClinicPhotoHint;

  /// No description provided for @addClinicBtn.
  ///
  /// In en, this message translates to:
  /// **'Add Your Clinic'**
  String get addClinicBtn;

  /// No description provided for @deletePetTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete \'{name}\''**
  String deletePetTitle(String name);

  /// No description provided for @deletePetWarning.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone. All associated appointments will be canceled'**
  String get deletePetWarning;

  /// No description provided for @clinicAddedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Clinic added successfully!'**
  String get clinicAddedSuccess;

  /// No description provided for @deleteClinicSuccess.
  ///
  /// In en, this message translates to:
  /// **'Clinic deleted successfully!'**
  String get deleteClinicSuccess;

  /// No description provided for @addressTooShort.
  ///
  /// In en, this message translates to:
  /// **'Address is too short, please provide more details'**
  String get addressTooShort;

  /// No description provided for @descTooShort.
  ///
  /// In en, this message translates to:
  /// **'Description is too short, must be at least 10 characters'**
  String get descTooShort;

  /// No description provided for @hoursTooShort.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid working hours'**
  String get hoursTooShort;

  /// No description provided for @specializationTooShort.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid specialization'**
  String get specializationTooShort;

  /// No description provided for @noPostsYet.
  ///
  /// In en, this message translates to:
  /// **'No posts yet.'**
  String get noPostsYet;

  /// No description provided for @userPostsTitle.
  ///
  /// In en, this message translates to:
  /// **'Posts'**
  String get userPostsTitle;

  /// No description provided for @myPostsTitle.
  ///
  /// In en, this message translates to:
  /// **'My Posts'**
  String get myPostsTitle;

  /// Button to view all items in a category
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAllBtn;

  /// Bottom navigation bar item: Clinics
  ///
  /// In en, this message translates to:
  /// **'Clinics'**
  String get clinics;

  /// Hint text for the clinic search field
  ///
  /// In en, this message translates to:
  /// **'Search by clinic name or area...'**
  String get searchClinicHint;

  /// Message shown when there are no clinics available in the vet clinics section
  ///
  /// In en, this message translates to:
  /// **'No clinics available at the moment'**
  String get noClinicsAvailable;

  /// No description provided for @bookAppointment.
  ///
  /// In en, this message translates to:
  /// **'Book Appointment'**
  String get bookAppointment;

  /// No description provided for @addReview.
  ///
  /// In en, this message translates to:
  /// **'Add Review'**
  String get addReview;

  /// No description provided for @reviewsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 Review} other{{count} Reviews}}'**
  String reviewsCount(int count);

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @availableSlots.
  ///
  /// In en, this message translates to:
  /// **'Available Slots'**
  String get availableSlots;

  /// No description provided for @booked.
  ///
  /// In en, this message translates to:
  /// **'Booked'**
  String get booked;

  /// No description provided for @clinicConfirmationNotice.
  ///
  /// In en, this message translates to:
  /// **'The appointment will be confirmed by the clinic'**
  String get clinicConfirmationNotice;

  /// No description provided for @confirmBooking.
  ///
  /// In en, this message translates to:
  /// **'Confirm Booking'**
  String get confirmBooking;

  /// No description provided for @appointmentConflictError.
  ///
  /// In en, this message translates to:
  /// **'You already have another appointment scheduled at this time.'**
  String get appointmentConflictError;

  /// Message shown when there are no posts in the community feed
  ///
  /// In en, this message translates to:
  /// **'Check back later for updates'**
  String get checkBackLater;

  /// No description provided for @noMatchingResults.
  ///
  /// In en, this message translates to:
  /// **'No matching results for \"{query}\"'**
  String noMatchingResults(String query);

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @editYourReview.
  ///
  /// In en, this message translates to:
  /// **'Edit Your Review'**
  String get editYourReview;

  /// No description provided for @yourClinicReview.
  ///
  /// In en, this message translates to:
  /// **'Your Clinic Review'**
  String get yourClinicReview;

  /// No description provided for @selectRating.
  ///
  /// In en, this message translates to:
  /// **'Select Rating *'**
  String get selectRating;

  /// No description provided for @writeCommentOptional.
  ///
  /// In en, this message translates to:
  /// **'Write your comment here (optional)'**
  String get writeCommentOptional;

  /// No description provided for @submitReview.
  ///
  /// In en, this message translates to:
  /// **'Submit Review'**
  String get submitReview;

  /// No description provided for @pleaseSelectRatingFirst.
  ///
  /// In en, this message translates to:
  /// **'Please select a rating first ⭐'**
  String get pleaseSelectRatingFirst;

  /// No description provided for @shareYourExperience.
  ///
  /// In en, this message translates to:
  /// **'Share your experience with the clinic...'**
  String get shareYourExperience;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @decline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get decline;

  /// Bottom navigation bar item: Smart Collar
  ///
  /// In en, this message translates to:
  /// **'Smart Collar'**
  String get smartCollar;

  /// Bottom navigation bar item: Community
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get community;

  /// Hint text shown in the post creation text field
  ///
  /// In en, this message translates to:
  /// **'What would you like to share?'**
  String get postContentHint;

  /// Message shown in the center of the search screen before the user starts searching
  ///
  /// In en, this message translates to:
  /// **'Search for a pet owner or a vet.. 🐾'**
  String get searchStartMessage;

  /// No description provided for @newPostTitle.
  ///
  /// In en, this message translates to:
  /// **'New Post'**
  String get newPostTitle;

  /// No description provided for @shareMomentHint.
  ///
  /// In en, this message translates to:
  /// **'Share a moment with your pet...'**
  String get shareMomentHint;

  /// No description provided for @postBtn.
  ///
  /// In en, this message translates to:
  /// **'Post'**
  String get postBtn;

  /// Label text for the add photo button
  ///
  /// In en, this message translates to:
  /// **'Add Photo'**
  String get addPhotoLabel;

  /// Success message shown after creating a new post
  ///
  /// In en, this message translates to:
  /// **'Posted!'**
  String get postCreatedSuccess;

  /// No description provided for @postsWithCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Posts'**
  String postsWithCount(int count);

  /// No description provided for @commentsWithCount.
  ///
  /// In en, this message translates to:
  /// **'Comments ({count})'**
  String commentsWithCount(int count);

  /// Label for the like button on a post
  ///
  /// In en, this message translates to:
  /// **'Like'**
  String get likeAction;

  /// Label for the delete button
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteAction;

  /// Label for the edit button
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editAction;

  /// Status text indicating a post or comment has been edited
  ///
  /// In en, this message translates to:
  /// **'Edited'**
  String get edited;

  /// Title or button label for editing a post
  ///
  /// In en, this message translates to:
  /// **'Edit Post'**
  String get editPost;

  /// Message shown when a post is edited successfully
  ///
  /// In en, this message translates to:
  /// **'Post updated successfully'**
  String get postEditedSuccessfully;

  /// Hint text shown when editing a comment
  ///
  /// In en, this message translates to:
  /// **'Editing comment...'**
  String get editingCommentHint;

  /// Hint text shown when replying to a user
  ///
  /// In en, this message translates to:
  /// **'Replying to'**
  String get replyingToHint;

  /// Title of the delete confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Delete Post?'**
  String get deletePostTitle;

  /// Content message of the delete confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Are you sure? This action cannot be undone.'**
  String get deleteDialogMessage;

  /// No description provided for @postDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Post deleted successfully'**
  String get postDeletedSuccessfully;

  /// Title of the delete comment confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Delete Comment?'**
  String get deleteCommentTitle;

  /// Content message of the delete comment confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'This comment will be permanently removed.'**
  String get deleteCommentMessage;

  /// Label for the comment button on a post
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get commentAction;

  /// Hint text shown in the comment input field
  ///
  /// In en, this message translates to:
  /// **'Write a comment...'**
  String get writeCommentHint;

  /// Placeholder text shown when a post has no comments
  ///
  /// In en, this message translates to:
  /// **'Be the first to comment!'**
  String get firstCommentPlaceholder;

  /// Text for the reply button on a comment
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get replyAction;

  /// Text shown when replying to a specific user (e.g., Replying to John)
  ///
  /// In en, this message translates to:
  /// **'Replying to'**
  String get replyingTo;

  /// No description provided for @selectPostCategoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Select relevant categories'**
  String get selectPostCategoriesTitle;

  /// No description provided for @selectCategoryError.
  ///
  /// In en, this message translates to:
  /// **'You must select at least one category'**
  String get selectCategoryError;

  /// No description provided for @categoryHealth.
  ///
  /// In en, this message translates to:
  /// **'Health & Care'**
  String get categoryHealth;

  /// No description provided for @categoryTraining.
  ///
  /// In en, this message translates to:
  /// **'Training & Behavior'**
  String get categoryTraining;

  /// No description provided for @categoryFood.
  ///
  /// In en, this message translates to:
  /// **'Nutrition & Food'**
  String get categoryFood;

  /// No description provided for @categoryGrooming.
  ///
  /// In en, this message translates to:
  /// **'Grooming'**
  String get categoryGrooming;

  /// No description provided for @categoryActivities.
  ///
  /// In en, this message translates to:
  /// **'Activities & Fun'**
  String get categoryActivities;

  /// No description provided for @categoryAdoption.
  ///
  /// In en, this message translates to:
  /// **'Adoption & Rescue'**
  String get categoryAdoption;

  /// No description provided for @categoryTravel.
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get categoryTravel;

  /// No description provided for @categoryStories.
  ///
  /// In en, this message translates to:
  /// **'Stories & Experiences'**
  String get categoryStories;

  /// Subtitle for Health & Care category
  ///
  /// In en, this message translates to:
  /// **'Health tips, vaccinations, and daily care'**
  String get healthSubtitle;

  /// Subtitle for Training & Behavior category
  ///
  /// In en, this message translates to:
  /// **'Training methods and behavioral solutions'**
  String get trainingSubtitle;

  /// Subtitle for Nutrition & Food category
  ///
  /// In en, this message translates to:
  /// **'Healthy recipes, diet plans, and product reviews'**
  String get foodSubtitle;

  /// Subtitle for Grooming category
  ///
  /// In en, this message translates to:
  /// **'Haircuts, bathing, and hygiene'**
  String get groomingSubtitle;

  /// Subtitle for Activities & Fun category
  ///
  /// In en, this message translates to:
  /// **'Games, outings, and fun activities'**
  String get activitiesSubtitle;

  /// Subtitle for Adoption & Rescue category
  ///
  /// In en, this message translates to:
  /// **'Adoption stories, rescue, and finding homes'**
  String get adoptionSubtitle;

  /// Subtitle for Travel category
  ///
  /// In en, this message translates to:
  /// **'Pet travel tips and pet-friendly places'**
  String get travelSubtitle;

  /// Subtitle for Stories & Experiences category
  ///
  /// In en, this message translates to:
  /// **'Inspiring stories, personal experiences, and moments'**
  String get storiesSubtitle;

  /// No description provided for @postingTipsTitle.
  ///
  /// In en, this message translates to:
  /// **'Posting Tips:'**
  String get postingTipsTitle;

  /// No description provided for @tipCategories.
  ///
  /// In en, this message translates to:
  /// **'Select relevant categories to reach the right audience'**
  String get tipCategories;

  /// No description provided for @tipMoments.
  ///
  /// In en, this message translates to:
  /// **'Share special moments with your pet'**
  String get tipMoments;

  /// No description provided for @tipPhotos.
  ///
  /// In en, this message translates to:
  /// **'Use clear and high-quality photos'**
  String get tipPhotos;

  /// No description provided for @tipRespect.
  ///
  /// In en, this message translates to:
  /// **'Be respectful and kind to the community'**
  String get tipRespect;

  /// No description provided for @addMedia.
  ///
  /// In en, this message translates to:
  /// **'Add media'**
  String get addMedia;

  /// No description provided for @fileTooLarge.
  ///
  /// In en, this message translates to:
  /// **'The selected file is too large! Please choose a file under 30 MB.'**
  String get fileTooLarge;

  /// No description provided for @uploadingPost.
  ///
  /// In en, this message translates to:
  /// **'Posting...'**
  String get uploadingPost;

  /// No description provided for @uploadPostFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to post. Check your connection.'**
  String get uploadPostFailed;

  /// No description provided for @retryBtn.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryBtn;

  /// No description provided for @cancelUploadBtn.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelUploadBtn;

  /// Bottom navigation bar item: Store
  ///
  /// In en, this message translates to:
  /// **'Store'**
  String get store;

  /// No description provided for @addProductTitle.
  ///
  /// In en, this message translates to:
  /// **'Add New Product'**
  String get addProductTitle;

  /// No description provided for @editProductTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Product'**
  String get editProductTitle;

  /// No description provided for @productNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Product Name'**
  String get productNameLabel;

  /// No description provided for @productDescLabel.
  ///
  /// In en, this message translates to:
  /// **'Product Description'**
  String get productDescLabel;

  /// No description provided for @quantityLabel.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantityLabel;

  /// No description provided for @priceLabel.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get priceLabel;

  /// No description provided for @currencyEGP.
  ///
  /// In en, this message translates to:
  /// **'EGP'**
  String get currencyEGP;

  /// No description provided for @searchProductHint.
  ///
  /// In en, this message translates to:
  /// **'Search for a product...'**
  String get searchProductHint;

  /// No description provided for @productDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Product deleted successfully'**
  String get productDeletedSuccessfully;

  /// No description provided for @productDetails.
  ///
  /// In en, this message translates to:
  /// **'Product details'**
  String get productDetails;

  /// No description provided for @inStock.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Only 1 piece left} other{In stock ({count} pieces)}}'**
  String inStock(int count);

  /// No description provided for @outOfStock.
  ///
  /// In en, this message translates to:
  /// **'Out of stock'**
  String get outOfStock;

  /// No description provided for @addToCart.
  ///
  /// In en, this message translates to:
  /// **'Add to cart'**
  String get addToCart;

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

  /// User's phone number label
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// Privacy and security section title
  ///
  /// In en, this message translates to:
  /// **'Privacy & Security'**
  String get privacy_security;

  /// Privacy label
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// Privacy settings section title
  ///
  /// In en, this message translates to:
  /// **'Privacy Settings'**
  String get privacy_settings;

  /// User join date label
  ///
  /// In en, this message translates to:
  /// **'Join Date'**
  String get join_date;

  /// Label for the user's account creation date
  ///
  /// In en, this message translates to:
  /// **'Joined'**
  String get joined;

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

  /// Title of the delete account confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Confirm Account Deletion'**
  String get confirmAccountDeletion;

  /// Warning message to confirm deletion
  ///
  /// In en, this message translates to:
  /// **'Your account will be permanently deleted.'**
  String get deleteAccountContent;

  /// Instruction asking the user to enter their password for confirmation
  ///
  /// In en, this message translates to:
  /// **'Please enter your password to confirm.'**
  String get enterPasswordToConfirm;

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

  /// Privacy disclaimer text showing user control over data
  ///
  /// In en, this message translates to:
  /// **'🔒 We respect your privacy and protect your data. You control who sees your information and pets.'**
  String get privacyNote;

  /// No description provided for @privacySettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy Settings'**
  String get privacySettingsTitle;

  /// No description provided for @publicProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Public Profile'**
  String get publicProfileTitle;

  /// No description provided for @publicProfileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Allow others to view profile'**
  String get publicProfileSubtitle;

  /// No description provided for @displayPetsTitle.
  ///
  /// In en, this message translates to:
  /// **'Display Pets'**
  String get displayPetsTitle;

  /// No description provided for @displayPetsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Show on your public profile'**
  String get displayPetsSubtitle;

  /// No description provided for @displayPhoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Display Phone Number'**
  String get displayPhoneTitle;

  /// No description provided for @displayPhoneSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Show on your public profile'**
  String get displayPhoneSubtitle;

  /// No description provided for @allowMessagesTitle.
  ///
  /// In en, this message translates to:
  /// **'Allow Messages'**
  String get allowMessagesTitle;

  /// No description provided for @allowMessagesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Receive messages from others'**
  String get allowMessagesSubtitle;

  /// Title for change password screen
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get change_password;

  /// Button label to save
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Button label to cancel
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Shows last password update time dynamically
  ///
  /// In en, this message translates to:
  /// **'Last updated: {time}'**
  String password_last_update(Object time);

  /// Header for the daily advice section
  ///
  /// In en, this message translates to:
  /// **'Daily Tip'**
  String get dailyTip;

  /// Label for body temperature metric
  ///
  /// In en, this message translates to:
  /// **'Temp'**
  String get temperature;

  /// No description provided for @temperatureDegree.
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get temperatureDegree;

  /// Label for physical activity metric
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get activity;

  /// Label for heart rate/pulse metric
  ///
  /// In en, this message translates to:
  /// **'Pulse'**
  String get pulse;

  /// No description provided for @heartRate.
  ///
  /// In en, this message translates to:
  /// **'Heart Rate'**
  String get heartRate;

  /// No description provided for @normal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get normal;

  /// No description provided for @currentLocation.
  ///
  /// In en, this message translates to:
  /// **'Current Location'**
  String get currentLocation;

  /// Button label to navigate to detailed statistics screen
  ///
  /// In en, this message translates to:
  /// **'View Detailed Statistics'**
  String get viewDetailedStatistics;

  /// No description provided for @hideStatistics.
  ///
  /// In en, this message translates to:
  /// **'Hide Statistics'**
  String get hideStatistics;

  /// Button label to view more details
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// Header showing the most recent health data entry
  ///
  /// In en, this message translates to:
  /// **'Latest Health Record'**
  String get latestHealthRecord;

  /// No description provided for @recordCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get recordCompleted;

  /// No description provided for @recordIncomplete.
  ///
  /// In en, this message translates to:
  /// **'Incomplete'**
  String get recordIncomplete;

  /// No description provided for @healthExcellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get healthExcellent;

  /// No description provided for @healthGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get healthGood;

  /// Section header for scheduled future appointments
  ///
  /// In en, this message translates to:
  /// **'Upcoming Appointments'**
  String get upcomingAppointments;

  /// No description provided for @noHealthRecord.
  ///
  /// In en, this message translates to:
  /// **'No medical record'**
  String get noHealthRecord;

  /// No description provided for @noUpcomingAppointments.
  ///
  /// In en, this message translates to:
  /// **'No upcoming appointments'**
  String get noUpcomingAppointments;

  /// No description provided for @noReminders.
  ///
  /// In en, this message translates to:
  /// **'No reminders'**
  String get noReminders;

  /// Title shown when no smart collar is paired
  ///
  /// In en, this message translates to:
  /// **'This pet has no smart collar'**
  String get noSmartCollarTitle;

  /// Number of connected collars
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No connected collars} =1{1 connected collar} other{{count} connected collars}}'**
  String connectedCollarsCount(int count);

  /// No description provided for @connected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get connected;

  /// No description provided for @disconnected.
  ///
  /// In en, this message translates to:
  /// **'Disconnected'**
  String get disconnected;

  /// No description provided for @lastSync.
  ///
  /// In en, this message translates to:
  /// **'Last sync'**
  String get lastSync;

  /// No description provided for @deviceStatus.
  ///
  /// In en, this message translates to:
  /// **'Device Status'**
  String get deviceStatus;

  /// No description provided for @battery.
  ///
  /// In en, this message translates to:
  /// **'Battery'**
  String get battery;

  /// No description provided for @conversationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Conversations'**
  String get conversationsTitle;

  /// No description provided for @noConversationsYet.
  ///
  /// In en, this message translates to:
  /// **'No conversations yet'**
  String get noConversationsYet;

  /// No description provided for @writeMessageHint.
  ///
  /// In en, this message translates to:
  /// **'Write a message...'**
  String get writeMessageHint;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// No description provided for @isTyping.
  ///
  /// In en, this message translates to:
  /// **'typing...'**
  String get isTyping;

  /// No description provided for @startConversationWith.
  ///
  /// In en, this message translates to:
  /// **'Start a conversation with {userName}...'**
  String startConversationWith(String userName);

  /// Promotional text to order a smart collar
  ///
  /// In en, this message translates to:
  /// **'Order a smart collar to track your pet\'s health.'**
  String get orderSmartCollarDescription;

  /// Error message shown when the user enters an incorrect password
  ///
  /// In en, this message translates to:
  /// **'Wrong password, please check and try again'**
  String get wrongPassword;

  /// Button label to order a product
  ///
  /// In en, this message translates to:
  /// **'Order Now'**
  String get orderNow;

  /// No description provided for @sessionExpiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Session Expired'**
  String get sessionExpiredTitle;

  /// No description provided for @sessionExpiredMessage.
  ///
  /// In en, this message translates to:
  /// **'Your login session has expired. Please log in again to continue.'**
  String get sessionExpiredMessage;
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
