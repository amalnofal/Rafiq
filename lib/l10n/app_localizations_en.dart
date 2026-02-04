// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get rafiq => 'Rafiq';

  @override
  String get pet_care_assistant => 'Smart assistant for taking care of your pet';

  @override
  String get no_account_question => 'Don\'t have an account? ';

  @override
  String get create_new_account => 'Create New Account';

  @override
  String get joinRafiq => 'Join Rafiq Community';

  @override
  String get signUpSubtitle => 'Create your account to enjoy all features';

  @override
  String get firstName => 'First Name';

  @override
  String get lastName => 'Last Name';

  @override
  String get email => 'Email Address';

  @override
  String get phone_number => 'Phone number';

  @override
  String get optional => '(optional)';

  @override
  String get genderLabel => 'Gender';

  @override
  String get male => 'Male';

  @override
  String get female => 'Female';

  @override
  String get dateOfBirthLabel => 'Date of Birth';

  @override
  String get dobHint => 'mm/dd/yyyy';

  @override
  String get chooseAccountType => 'Choose Account Type';

  @override
  String get chooseAccountTypeSubtitle => 'Select how you want to use the app';

  @override
  String get petOwnerTitle => 'Pet Owner';

  @override
  String get petOwnerSubtitle => 'Manage your pets\' health and connect with the community';

  @override
  String get petInfoTitle => 'Pet Information';

  @override
  String get petInfoSubtitle => 'Tell us a little about your little friend';

  @override
  String get petNameHint => 'Pet Name';

  @override
  String get petTypeHint => 'Type (e.g. Dog, Cat)';

  @override
  String get vetTitle => 'Veterinarian';

  @override
  String get vetSubtitle => 'Offer your services as a licensed veterinarian';

  @override
  String get professionalInfoTitle => 'Professional Info';

  @override
  String get professionalInfoSubtitle => 'Verify your professional identity';

  @override
  String get specializationLabel => 'Specialization';

  @override
  String get subSpecializationLabel => 'Sub-specialization';

  @override
  String get idFrontLabel => 'National ID (Front Side)';

  @override
  String get idBackLabel => 'National ID (Back Side)';

  @override
  String get uploadIdText => 'Tap to upload image';

  @override
  String get camera => 'Camera';

  @override
  String get gallery => 'Gallery';

  @override
  String get vetCardLabel => 'Veterinary ID Card';

  @override
  String get supportedFormats => 'JPG, PNG or HEIC';

  @override
  String get reviewNote => 'Your professional info will be reviewed by our team within 24-48 hours for verification';

  @override
  String get shareInterests => 'Share your interests';

  @override
  String get communityWaiting => 'Rafiq community is waiting for you';

  @override
  String get interestsSubtitle => 'Tell us what you care about so we can curate the perfect feed for you';

  @override
  String get selectMultiple => '(You can select multiple)';

  @override
  String get selectInterestError => 'Please select at least one interest to continue';

  @override
  String get password => 'Password';

  @override
  String get currentPassword => 'Current Password';

  @override
  String get newPassword => 'New Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get passwordRequirements => 'Password Requirements:';

  @override
  String get passwordRuleLength => 'At least 8 characters';

  @override
  String get passwordRuleCase => 'Uppercase and lowercase letters';

  @override
  String get passwordRuleNumber => 'At least one number';

  @override
  String get passwordRuleUpperCase => 'At least one uppercase letter';

  @override
  String get passwordRuleLowerCase => 'At least one lowercase letter';

  @override
  String get phoneRuleLength => 'Phone number must be at least 11 digits';

  @override
  String get invalidEmailAddress => 'Invalid email address';

  @override
  String get nameRequired => 'Name is required';

  @override
  String get nameTooShort => 'Name is too short';

  @override
  String get fieldRequired => 'This field is required';

  @override
  String get termsAgreementStart => 'By creating an account, you agree to ';

  @override
  String get termsAndConditions => 'Terms and Conditions';

  @override
  String get and => ' & ';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get dontHaveAccount => 'Don\'t have an account? ';

  @override
  String get or => 'OR';

  @override
  String get signUpWithGoogle => 'Sign up with Google';

  @override
  String get signUpWithApple => 'Sign up with Apple';

  @override
  String get login_with_email => 'Log in with Email';

  @override
  String get login_with_apple => 'Log in with Apple';

  @override
  String get login_with_google => 'Log in with Google';

  @override
  String get welcome => 'Welcome';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get back => 'Back';

  @override
  String get next => 'Next';

  @override
  String get submitForReviewBtn => 'Submit for Review';

  @override
  String get login => 'Log In';

  @override
  String get startJourney => 'Start Your Journey';

  @override
  String get welcomeBack => 'Welcome back to Rafiq';

  @override
  String get signInSubtitle => 'Log in to continue';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get recoverPassword => 'Reset Password';

  @override
  String get enterEmailSubtitle => 'Enter your email address';

  @override
  String get sendCode => 'Send Verification Code';

  @override
  String get verificationCodeTitle => 'Verification Code';

  @override
  String verificationCodeSubtitle(String email) {
    return 'We sent a code to $email';
  }

  @override
  String get resendCodeText => 'Resend Code';

  @override
  String second(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count seconds',
      one: '1 second',
    );
    return ' $_temp0';
  }

  @override
  String get verifyCodeButton => 'Verify Code';

  @override
  String get chooseStrongPassword => 'Choose a strong password';

  @override
  String get changePassword => 'Change Password';

  @override
  String get logout => 'Logout';

  @override
  String get profile => 'Profile';

  @override
  String get home => 'Home';

  @override
  String get clinics => 'Clinics';

  @override
  String get vetClinicsTitle => 'Vet Clinics';

  @override
  String get smartCollar => 'Smart Collar';

  @override
  String get community => 'Community';

  @override
  String get postContentHint => 'What would you like to share?';

  @override
  String get emptyCommunityText => 'No posts yet';

  @override
  String get newPostTitle => 'New Post';

  @override
  String get shareMomentHint => 'Share a moment with your pet...';

  @override
  String get postBtn => 'Post';

  @override
  String get addPhotoLabel => 'Add Photo';

  @override
  String get postCreatedSuccess => 'Posted!';

  @override
  String get likeAction => 'Like';

  @override
  String get deleteAction => 'Delete';

  @override
  String get editAction => 'Edit';

  @override
  String get edited => 'Edited';

  @override
  String get editPost => 'Edit Post';

  @override
  String get editingCommentHint => 'Editing comment...';

  @override
  String get replyingToHint => 'Replying to';

  @override
  String get deletePostTitle => 'Delete Post?';

  @override
  String get deleteDialogMessage => 'Are you sure? This action cannot be undone.';

  @override
  String get deleteCommentTitle => 'Delete Comment?';

  @override
  String get deleteCommentMessage => 'This comment will be permanently removed.';

  @override
  String get commentAction => 'Comment';

  @override
  String get writeCommentHint => 'Write a comment...';

  @override
  String get firstCommentPlaceholder => 'Be the first to comment!';

  @override
  String get replyAction => 'Reply';

  @override
  String get replyingTo => 'Replying to';

  @override
  String get selectPostCategoriesTitle => 'Select relevant categories';

  @override
  String get selectCategoryError => 'You must select at least one category';

  @override
  String get categoryHealth => 'Health & Care';

  @override
  String get categoryTraining => 'Training & Behavior';

  @override
  String get categoryFood => 'Nutrition & Food';

  @override
  String get categoryGrooming => 'Grooming';

  @override
  String get categoryActivities => 'Activities & Fun';

  @override
  String get categoryAdoption => 'Adoption & Rescue';

  @override
  String get categoryTravel => 'Travel';

  @override
  String get categoryStories => 'Stories & Experiences';

  @override
  String get healthSubtitle => 'Health tips, vaccinations, and daily care';

  @override
  String get trainingSubtitle => 'Training methods and behavioral solutions';

  @override
  String get foodSubtitle => 'Healthy recipes, diet plans, and product reviews';

  @override
  String get groomingSubtitle => 'Haircuts, bathing, and hygiene';

  @override
  String get activitiesSubtitle => 'Games, outings, and fun activities';

  @override
  String get adoptionSubtitle => 'Adoption stories, rescue, and finding homes';

  @override
  String get travelSubtitle => 'Pet travel tips and pet-friendly places';

  @override
  String get storiesSubtitle => 'Inspiring stories, personal experiences, and moments';

  @override
  String get postingTipsTitle => 'Posting Tips:';

  @override
  String get tipCategories => 'Select relevant categories to reach the right audience';

  @override
  String get tipMoments => 'Share special moments with your pet';

  @override
  String get tipPhotos => 'Use clear and high-quality photos';

  @override
  String get tipRespect => 'Be respectful and kind to the community';

  @override
  String get store => 'Store';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get lan => 'English';

  @override
  String get choose_lan => 'Choose language';

  @override
  String get lan_note => '💡 The selected language will be applied immediately to all parts of the app.';

  @override
  String get dark_mode => 'Dark Mode';

  @override
  String get general => 'General';

  @override
  String get notifications => 'Notifications';

  @override
  String get account => 'Account';

  @override
  String get account_management => 'Account Management';

  @override
  String get account_information => 'Account Information';

  @override
  String get personal_info => 'Personal Information';

  @override
  String get name => 'Name';

  @override
  String get phone => 'Phone';

  @override
  String get privacy_security => 'Privacy & Security';

  @override
  String get privacy => 'Privacy';

  @override
  String get privacy_settings => 'Privacy Settings';

  @override
  String get join_date => 'Join Date';

  @override
  String get version => 'Version';

  @override
  String get last_update => 'Last update';

  @override
  String get danger_zone => 'Danger Zone';

  @override
  String get save_changes => 'Save Changes';

  @override
  String get changes_saved => 'Changes saved successfully';

  @override
  String get confirmAccountDeletion => 'Confirm Account Deletion';

  @override
  String get deleteAccountContent => 'Your account will be permanently deleted.';

  @override
  String get enterPasswordToConfirm => 'Please enter your password to confirm.';

  @override
  String get delete_account => 'Delete Account';

  @override
  String get warning_delete_account => 'This action cannot be undone';

  @override
  String get privacyNote => '🔒 We respect your privacy and protect your data. You control who sees your information and pets.';

  @override
  String get privacySettingsTitle => 'Privacy Settings';

  @override
  String get publicProfileTitle => 'Public Profile';

  @override
  String get publicProfileSubtitle => 'Allow others to view profile';

  @override
  String get displayPetsTitle => 'Display Pets';

  @override
  String get displayPetsSubtitle => 'Show on your public profile';

  @override
  String get displayPhoneTitle => 'Display Phone Number';

  @override
  String get displayPhoneSubtitle => 'Show on your public profile';

  @override
  String get allowMessagesTitle => 'Allow Messages';

  @override
  String get allowMessagesSubtitle => 'Receive messages from others';

  @override
  String get change_password => 'Change Password';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String password_last_update(Object time) {
    return 'Last updated: $time';
  }

  @override
  String get dailyTip => 'Daily Tip';

  @override
  String get temperature => 'Temp';

  @override
  String get activity => 'Activity';

  @override
  String get pulse => 'Pulse';

  @override
  String get viewDetailedStatistics => 'View Detailed Statistics';

  @override
  String get details => 'Details';

  @override
  String get latestHealthRecord => 'Latest Health Record';

  @override
  String get recordCompleted => 'Completed';

  @override
  String get recordIncomplete => 'Incomplete';

  @override
  String get healthExcellent => 'Excellent';

  @override
  String get healthGood => 'Good';

  @override
  String get upcomingAppointments => 'Upcoming Appointments';

  @override
  String get noSmartCollarTitle => 'This pet has no smart collar';

  @override
  String get orderSmartCollarDescription => 'Order a smart collar to track your pet\'s health.';

  @override
  String get orderNow => 'Order Now';
}
