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
  /// **'Phone number'**
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
  /// **'mm/dd/yyyy'**
  String get dobHint;

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

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @passwordRequirements.
  ///
  /// In en, this message translates to:
  /// **'Password Requirements:'**
  String get passwordRequirements;

  /// No description provided for @passwordRuleLength.
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters'**
  String get passwordRuleLength;

  /// No description provided for @passwordRuleCase.
  ///
  /// In en, this message translates to:
  /// **'Uppercase and lowercase letters'**
  String get passwordRuleCase;

  /// No description provided for @passwordRuleNumber.
  ///
  /// In en, this message translates to:
  /// **'At least one number'**
  String get passwordRuleNumber;

  /// Validation rule requiring at least one uppercase letter
  ///
  /// In en, this message translates to:
  /// **'At least one uppercase letter'**
  String get passwordRuleUpperCase;

  /// Validation rule requiring at least one lowercase letter
  ///
  /// In en, this message translates to:
  /// **'At least one lowercase letter'**
  String get passwordRuleLowerCase;

  /// Validation rule for phone number length
  ///
  /// In en, this message translates to:
  /// **'Phone number must be at least 11 digits'**
  String get phoneRuleLength;

  /// Error message shown when the email format is incorrect
  ///
  /// In en, this message translates to:
  /// **'Invalid email address'**
  String get invalidEmailAddress;

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

  /// Error message when a field is empty
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get fieldRequired;

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
  /// **' {count, plural, =1{1 second} other{{count} seconds}}'**
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

  /// Profile page title
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// Bottom navigation bar item: Home
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Bottom navigation bar item: Clinics
  ///
  /// In en, this message translates to:
  /// **'Clinics'**
  String get clinics;

  /// No description provided for @vetClinicsTitle.
  ///
  /// In en, this message translates to:
  /// **'Vet Clinics'**
  String get vetClinicsTitle;

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

  /// Text shown when community feed is empty
  ///
  /// In en, this message translates to:
  /// **'No posts yet'**
  String get emptyCommunityText;

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

  /// No description provided for @tagPetTitle.
  ///
  /// In en, this message translates to:
  /// **'Tag your pet (Optional)'**
  String get tagPetTitle;

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

  /// Bottom navigation bar item: Store
  ///
  /// In en, this message translates to:
  /// **'Store'**
  String get store;

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

  /// Button label to navigate to detailed statistics screen
  ///
  /// In en, this message translates to:
  /// **'View Detailed Statistics'**
  String get viewDetailedStatistics;

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

  /// Title shown when no smart collar is paired
  ///
  /// In en, this message translates to:
  /// **'This pet has no smart collar'**
  String get noSmartCollarTitle;

  /// Promotional text to order a smart collar
  ///
  /// In en, this message translates to:
  /// **'Order a smart collar to track your pet\'s health.'**
  String get orderSmartCollarDescription;

  /// Button label to order a product
  ///
  /// In en, this message translates to:
  /// **'Order Now'**
  String get orderNow;
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
