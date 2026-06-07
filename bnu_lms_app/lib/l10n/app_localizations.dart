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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'BNU LMS'**
  String get appTitle;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @forums.
  ///
  /// In en, this message translates to:
  /// **'Forums'**
  String get forums;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @on.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get on;

  /// No description provided for @off.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get off;

  /// No description provided for @quickAccess.
  ///
  /// In en, this message translates to:
  /// **'Quick Access'**
  String get quickAccess;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @courses.
  ///
  /// In en, this message translates to:
  /// **'Courses'**
  String get courses;

  /// No description provided for @calendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendar;

  /// No description provided for @quizzes.
  ///
  /// In en, this message translates to:
  /// **'Quizzes'**
  String get quizzes;

  /// No description provided for @grades.
  ///
  /// In en, this message translates to:
  /// **'Grades'**
  String get grades;

  /// No description provided for @attendance.
  ///
  /// In en, this message translates to:
  /// **'Attendance'**
  String get attendance;

  /// No description provided for @entrance.
  ///
  /// In en, this message translates to:
  /// **'Entrance'**
  String get entrance;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back,'**
  String get welcomeBack;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @searchForums.
  ///
  /// In en, this message translates to:
  /// **'search forums'**
  String get searchForums;

  /// No description provided for @quizDetails.
  ///
  /// In en, this message translates to:
  /// **'Quiz Details'**
  String get quizDetails;

  /// No description provided for @quizQuestions.
  ///
  /// In en, this message translates to:
  /// **'Quiz Questions'**
  String get quizQuestions;

  /// No description provided for @quizResults.
  ///
  /// In en, this message translates to:
  /// **'Quiz Results'**
  String get quizResults;

  /// No description provided for @tuitionPayments.
  ///
  /// In en, this message translates to:
  /// **'Tuition Payments'**
  String get tuitionPayments;

  /// No description provided for @tuitionPaymentsDesc.
  ///
  /// In en, this message translates to:
  /// **'View payment history and upcoming fees'**
  String get tuitionPaymentsDesc;

  /// No description provided for @advisingSessions.
  ///
  /// In en, this message translates to:
  /// **'Advising Sessions'**
  String get advisingSessions;

  /// No description provided for @advisingSessionsDesc.
  ///
  /// In en, this message translates to:
  /// **'Schedule and manage academic advising'**
  String get advisingSessionsDesc;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @helpCenter.
  ///
  /// In en, this message translates to:
  /// **'Help Center'**
  String get helpCenter;

  /// No description provided for @contactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get contactSupport;

  /// No description provided for @computerScience.
  ///
  /// In en, this message translates to:
  /// **'Computer Science'**
  String get computerScience;

  /// No description provided for @advancedProgramming.
  ///
  /// In en, this message translates to:
  /// **'Advanced Programming'**
  String get advancedProgramming;

  /// No description provided for @dataStructuresAlgorithms.
  ///
  /// In en, this message translates to:
  /// **'Data Structures & Algorithms'**
  String get dataStructuresAlgorithms;

  /// No description provided for @webDevelopment.
  ///
  /// In en, this message translates to:
  /// **'Web Development'**
  String get webDevelopment;

  /// No description provided for @databaseManagement.
  ///
  /// In en, this message translates to:
  /// **'Database Management Systems'**
  String get databaseManagement;

  /// No description provided for @artificialIntelligence.
  ///
  /// In en, this message translates to:
  /// **'Artificial Intelligence'**
  String get artificialIntelligence;

  /// No description provided for @mobileAppDevelopment.
  ///
  /// In en, this message translates to:
  /// **'Mobile App Development'**
  String get mobileAppDevelopment;

  /// No description provided for @drAngelaYu.
  ///
  /// In en, this message translates to:
  /// **'Dr. Angela Yu'**
  String get drAngelaYu;

  /// No description provided for @drRobertMartin.
  ///
  /// In en, this message translates to:
  /// **'Dr. Robert Martin'**
  String get drRobertMartin;

  /// No description provided for @profSarahJohnson.
  ///
  /// In en, this message translates to:
  /// **'Prof. Sarah Johnson'**
  String get profSarahJohnson;

  /// No description provided for @drMichaelChen.
  ///
  /// In en, this message translates to:
  /// **'Dr. Michael Chen'**
  String get drMichaelChen;

  /// No description provided for @profEmilyWatson.
  ///
  /// In en, this message translates to:
  /// **'Prof. Emily Watson'**
  String get profEmilyWatson;

  /// No description provided for @drAhmedHassan.
  ///
  /// In en, this message translates to:
  /// **'Dr. Ahmed Hassan'**
  String get drAhmedHassan;

  /// No description provided for @fall2024.
  ///
  /// In en, this message translates to:
  /// **'Fall 2024'**
  String get fall2024;

  /// No description provided for @introEngineering.
  ///
  /// In en, this message translates to:
  /// **'Introduction to Engineering'**
  String get introEngineering;

  /// No description provided for @calculusOne.
  ///
  /// In en, this message translates to:
  /// **'Calculus I'**
  String get calculusOne;

  /// No description provided for @physicsForEngineers.
  ///
  /// In en, this message translates to:
  /// **'Physics for Engineers'**
  String get physicsForEngineers;

  /// No description provided for @campusLife.
  ///
  /// In en, this message translates to:
  /// **'Campus Life'**
  String get campusLife;

  /// No description provided for @studyGroups.
  ///
  /// In en, this message translates to:
  /// **'Study Groups'**
  String get studyGroups;

  /// No description provided for @postsParticipants_12_5.
  ///
  /// In en, this message translates to:
  /// **'12 posts, 5 participants'**
  String get postsParticipants_12_5;

  /// No description provided for @postsParticipants_8_3.
  ///
  /// In en, this message translates to:
  /// **'8 posts, 3 participants'**
  String get postsParticipants_8_3;

  /// No description provided for @postsParticipants_15_7.
  ///
  /// In en, this message translates to:
  /// **'15 posts, 7 participants'**
  String get postsParticipants_15_7;

  /// No description provided for @postsParticipants_20_10.
  ///
  /// In en, this message translates to:
  /// **'20 posts, 10 participants'**
  String get postsParticipants_20_10;

  /// No description provided for @postsParticipants_5_2.
  ///
  /// In en, this message translates to:
  /// **'5 posts, 2 participants'**
  String get postsParticipants_5_2;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
