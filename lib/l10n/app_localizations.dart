import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

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
    Locale('en'),
    Locale('pt')
  ];

  /// Section title for progress and statistics
  ///
  /// In en, this message translates to:
  /// **'Progress & Statistics'**
  String get progressStats;

  /// Label for edit button
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Label for delete button
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Instruction to select or create a new table
  ///
  /// In en, this message translates to:
  /// **'Select a table or create one'**
  String get selectOrCreateTable;

  /// Button to create a new table
  ///
  /// In en, this message translates to:
  /// **'Create new table'**
  String get createNewTable;

  /// Instruction to select an existing table
  ///
  /// In en, this message translates to:
  /// **'Select a table'**
  String get selectTable;

  /// Success message after adding
  ///
  /// In en, this message translates to:
  /// **'Added successfully!'**
  String get addedSuccess;

  /// Error message when adding fails
  ///
  /// In en, this message translates to:
  /// **'Failed to add!'**
  String get addError;

  /// Success message after deleting
  ///
  /// In en, this message translates to:
  /// **'Deleted successfully'**
  String get deletedSuccess;

  /// Error message when deletion fails
  ///
  /// In en, this message translates to:
  /// **'Failed to delete'**
  String get deleteError;

  /// Success message after removing
  ///
  /// In en, this message translates to:
  /// **'Removed successfully!'**
  String get removedSuccess;

  /// Error message when removal fails
  ///
  /// In en, this message translates to:
  /// **'Failed to remove!'**
  String get removeError;

  /// Label for the timer screen or feature
  ///
  /// In en, this message translates to:
  /// **'Timer'**
  String get timer;

  /// Button label to reset the timer
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// Button label to start the timer
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// Button label to resume the paused timer
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resume;

  /// Button label to pause the timer
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// Title for the exercise list screen
  ///
  /// In en, this message translates to:
  /// **'Exercise List'**
  String get exerciseList;

  /// Label for the search input or button
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// Success message after editing
  ///
  /// In en, this message translates to:
  /// **'Edited successfully!'**
  String get editedSuccess;

  /// Error message shown when edit fails
  ///
  /// In en, this message translates to:
  /// **'Error while editing!'**
  String get editError;

  /// Title for the workout plan creation screen
  ///
  /// In en, this message translates to:
  /// **'Workout plan creation'**
  String get createPlan;

  /// Button or title for creating a workout
  ///
  /// In en, this message translates to:
  /// **'Create workout'**
  String get createWorkout;

  /// Button or title for editing a workout
  ///
  /// In en, this message translates to:
  /// **'Edit workout'**
  String get editWorkout;

  /// Instruction to select exercises for a workout
  ///
  /// In en, this message translates to:
  /// **'Select exercises'**
  String get selectExercises;

  /// Label for a name input field
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// Validation message when a name is not acceptable
  ///
  /// In en, this message translates to:
  /// **'Invalid name'**
  String get invalidName;

  /// Theme option: dark mode
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// Theme option: light mode
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// Theme option that follows system settings
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// Label for theme selection section
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @defaultOption.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get defaultOption;

  /// Label for development tools section
  ///
  /// In en, this message translates to:
  /// **'Dev tools'**
  String get devTools;

  /// Button to delete all user data
  ///
  /// In en, this message translates to:
  /// **'Clear ALL data'**
  String get clearAllData;

  /// Button to generate fake/demo data
  ///
  /// In en, this message translates to:
  /// **'Generate demonstration data'**
  String get generateDemoData;

  /// Error message when a workout fails to load
  ///
  /// In en, this message translates to:
  /// **'Error loading workout'**
  String get loadWorkoutError;

  /// Label or title for a workout
  ///
  /// In en, this message translates to:
  /// **'Workout'**
  String get workout;

  /// Button to start creating a workout plan
  ///
  /// In en, this message translates to:
  /// **'Create plan'**
  String get createPlanButton;

  /// Button to finalize a workout plan
  ///
  /// In en, this message translates to:
  /// **'Finish plan'**
  String get finishPlan;

  /// Message shown when no workout plans exist
  ///
  /// In en, this message translates to:
  /// **'You don’t have any workout plans yet.\nTap \'Create plan\' to get started.'**
  String get noPlansMessage;

  /// Title or label for the settings section
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Label for data section or menu
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get data;

  /// Button or option to export user data
  ///
  /// In en, this message translates to:
  /// **'Export data'**
  String get exportData;

  /// Label or filename used for FitTracker backups
  ///
  /// In en, this message translates to:
  /// **'fittracker backup'**
  String get fittrackerBackup;

  /// Label for weight input or display
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// Unit for kilograms
  ///
  /// In en, this message translates to:
  /// **'Kg'**
  String get kg;

  /// Validation message for invalid input value
  ///
  /// In en, this message translates to:
  /// **'Invalid value'**
  String get invalidValue;

  /// Label for duration in minutes
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get minutes;

  /// Prefix label before listing exercises
  ///
  /// In en, this message translates to:
  /// **'Exercises: '**
  String get exercisesLabel;

  /// Message shown when a list has no items
  ///
  /// In en, this message translates to:
  /// **'Empty list'**
  String get emptyList;

  /// Title for the exercise creation screen
  ///
  /// In en, this message translates to:
  /// **'Exercise creation'**
  String get createExercise;

  /// Title for editing an exercise
  ///
  /// In en, this message translates to:
  /// **'Edit exercise'**
  String get editExercise;

  /// Category: strength/muscle training
  ///
  /// In en, this message translates to:
  /// **'Strength training'**
  String get strength;

  /// Category: cardio exercises
  ///
  /// In en, this message translates to:
  /// **'Cardio'**
  String get cardio;

  /// Label for weight/load used in exercise
  ///
  /// In en, this message translates to:
  /// **'Load'**
  String get weightLoad;

  /// Label for time-based exercises
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// Label for the number of repetitions in a set
  ///
  /// In en, this message translates to:
  /// **'Number of repetitions'**
  String get reps;

  /// Label for the number of sets
  ///
  /// In en, this message translates to:
  /// **'Number of sets'**
  String get sets;

  /// Label for add button
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// Label for viewing the full data table
  ///
  /// In en, this message translates to:
  /// **'Full table'**
  String get fullTable;

  /// Hint that selected data items are used in chart visualization
  ///
  /// In en, this message translates to:
  /// **'Selected items will be shown on the chart'**
  String get chartSelectionInfo;

  /// Label for date field
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// Hint for when the measurement was taken
  ///
  /// In en, this message translates to:
  /// **'Date when the value was recorded'**
  String get dateHint;

  /// Label for a recorded numeric value
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get value;

  /// Hint text for what the value represents
  ///
  /// In en, this message translates to:
  /// **'Recorded value'**
  String get valueHint;

  /// Label for user note or comment
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// Hint for optional notes added by user
  ///
  /// In en, this message translates to:
  /// **'User-added observation'**
  String get noteHint;

  /// Button or action to delete a report entry
  ///
  /// In en, this message translates to:
  /// **'Delete report'**
  String get deleteReport;

  /// Label to view or expand full user note
  ///
  /// In en, this message translates to:
  /// **'Full note'**
  String get fullNote;

  /// Button to close dialog or modal
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Label for reporting a new measurement or value
  ///
  /// In en, this message translates to:
  /// **'Report value'**
  String get reportValue;

  /// Label for a notes section or field
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// Validation message when a note is invalid
  ///
  /// In en, this message translates to:
  /// **'Invalid note'**
  String get invalidNote;

  /// Button or title for creating a new progress table
  ///
  /// In en, this message translates to:
  /// **'Create progress table'**
  String get createProgressTable;

  /// Label for a description field
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// Validation message when description is invalid
  ///
  /// In en, this message translates to:
  /// **'Invalid description'**
  String get invalidDescription;

  /// Label or hint for the unit suffix of a value
  ///
  /// In en, this message translates to:
  /// **'Value suffix example: (15 Kg)'**
  String get valueSuffix;

  /// Validation message when the value suffix is invalid
  ///
  /// In en, this message translates to:
  /// **'Invalid suffix'**
  String get invalidSuffix;

  /// Label for interactive data chart
  ///
  /// In en, this message translates to:
  /// **'Interactive chart'**
  String get interactiveChart;

  /// Option to filter data for the last 7 days
  ///
  /// In en, this message translates to:
  /// **'Last 7 days'**
  String get last7Days;

  /// Option to filter data for the last 30 days
  ///
  /// In en, this message translates to:
  /// **'Last 30 days'**
  String get last30Days;

  /// Option to filter data from the beginning
  ///
  /// In en, this message translates to:
  /// **'Since the beginning'**
  String get sinceBeginning;

  /// Error message shown when import fails
  ///
  /// In en, this message translates to:
  /// **'Error while trying to import data'**
  String get importError;

  /// Label for importing user data
  ///
  /// In en, this message translates to:
  /// **'Import data'**
  String get importData;

  /// Success message after importing data
  ///
  /// In en, this message translates to:
  /// **'Data loaded successfully!\n\n'**
  String get dataLoadedSuccess;

  /// Prefix message indicating the total data count
  ///
  /// In en, this message translates to:
  /// **'Total data:\n'**
  String get totalData;

  /// Option to replace existing data with imported data
  ///
  /// In en, this message translates to:
  /// **'Import and replace'**
  String get importReplace;

  /// Option to merge imported data with existing data
  ///
  /// In en, this message translates to:
  /// **'Import and add'**
  String get importMerge;

  /// Button to cancel an action
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Label for the home screen
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeNavBar;

  /// Label for the home app bar
  ///
  /// In en, this message translates to:
  /// **'Home page'**
  String get homeAppBar;

  /// Label for the timer screen
  ///
  /// In en, this message translates to:
  /// **'Timer'**
  String get timerNavBar;

  /// Label for training/workout action
  ///
  /// In en, this message translates to:
  /// **'Train'**
  String get trainNavBar;

  /// Label for the exercises section
  ///
  /// In en, this message translates to:
  /// **'Exercises'**
  String get exercisesNavBar;

  /// Label for progress tracking section
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progressNavBar;

  /// Label for settings/config screen
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get configNavBar;

  /// Summary of how many data items were imported
  ///
  /// In en, this message translates to:
  /// **'• Exercises: {exercises}\n• Plans: {plans}\n• Tables: {tables}\n• Reports: {reports}'**
  String importSummary(Object exercises, Object plans, Object tables, Object reports);

  /// Label for language selection screen
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageTitle;

  /// Option to select Portuguese language
  ///
  /// In en, this message translates to:
  /// **'Portuguese'**
  String get portugueseLanguage;

  /// Option to select English language
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get englishLanguage;

  /// Label shown when there is an active training plan
  ///
  /// In en, this message translates to:
  /// **'Active training'**
  String get activeTraining;

  /// Label shown when there is no active training plan
  ///
  /// In en, this message translates to:
  /// **'No active training'**
  String get inactiveTraining;

  /// Message shown when training finishes and history is saved successfully
  ///
  /// In en, this message translates to:
  /// **'Training finished, history saved'**
  String get trainingFinishedHistorySaved;

  /// Message shown when training finishes but there is an error saving history
  ///
  /// In en, this message translates to:
  /// **'Training finished, error saving history'**
  String get trainingFinishedHistorySaveError;

  /// Message shown when there is no recorded training history
  ///
  /// In en, this message translates to:
  /// **'No training recorded'**
  String get noTrainingRecorded;

  /// Title for the training history section
  ///
  /// In en, this message translates to:
  /// **'Training history'**
  String get trainingHistory;

  /// Label for Google account login
  ///
  /// In en, this message translates to:
  /// **'Google Account'**
  String get googleAccount;

  /// Instruction to log in with Google to store data in the cloud
  ///
  /// In en, this message translates to:
  /// **'Log in with your Google account to save your data to the cloud'**
  String get loginWithGoogle;

  /// Label for anonymous user
  ///
  /// In en, this message translates to:
  /// **'Anonymous'**
  String get anonymous;

  /// Label for login action
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Label for logout action
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Error message when login fails
  ///
  /// In en, this message translates to:
  /// **'Failed to log in'**
  String get loginFailed;

  /// Message shown when the user logs out
  ///
  /// In en, this message translates to:
  /// **'User logged out'**
  String get userLoggedOut;

  /// Message showing the currently logged in user's name
  ///
  /// In en, this message translates to:
  /// **'Logged in as: {userName}'**
  String loggedInAs(Object userName);

  /// Error message shown when logout fails
  ///
  /// In en, this message translates to:
  /// **'Failed to log out'**
  String get logoutFailed;

  /// Status message shown when saving has not started yet
  ///
  /// In en, this message translates to:
  /// **'Not started'**
  String get notStarted;

  /// Status message shown when sync is successful
  ///
  /// In en, this message translates to:
  /// **'Sync completed at {time}'**
  String syncCompleted(Object time);

  /// Status message when data is desynchronized
  ///
  /// In en, this message translates to:
  /// **'Data out of sync. Tap for sync options'**
  String get outOfSync;

  /// Status message when saving fails
  ///
  /// In en, this message translates to:
  /// **'Error saving. Retrying soon… Tap to try now'**
  String get saveError;

  /// Status message when user is disconnected
  ///
  /// In en, this message translates to:
  /// **'User disconnected'**
  String get userDisconnected;

  /// Title of the dialog when a data conflict is detected
  ///
  /// In en, this message translates to:
  /// **'Conflict Detected'**
  String get conflictDetectedTitle;

  /// Message explaining the conflict and prompting the user to choose
  ///
  /// In en, this message translates to:
  /// **'We detected a conflict between local data and cloud data. Choose which version you want to keep:'**
  String get conflictDetectedMessage;

  /// Label showing the last cloud save time
  ///
  /// In en, this message translates to:
  /// **'Last save in the cloud:\n {time}'**
  String lastCloudSave(Object time);

  /// Label showing the last local save time
  ///
  /// In en, this message translates to:
  /// **'Last local save:\n {time}'**
  String lastLocalSave(Object time);

  /// Shown when the date cannot be determined
  ///
  /// In en, this message translates to:
  /// **'Unable to determine the date'**
  String get unableToDetermineDate;

  /// Button label to use local data
  ///
  /// In en, this message translates to:
  /// **'Use local data'**
  String get useLocalData;

  /// Button label to use cloud data
  ///
  /// In en, this message translates to:
  /// **'Use cloud data'**
  String get useCloudData;

  /// Abbreviation for Sunday
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get sun;

  /// Abbreviation for Monday
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get mon;

  /// Abbreviation for Tuesday
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get tue;

  /// Abbreviation for Wednesday
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get wed;

  /// Abbreviation for Thursday
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get thu;

  /// Abbreviation for Friday
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get fri;

  /// Abbreviation for Saturday
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get sat;

  /// Label for button or link to show more information
  ///
  /// In en, this message translates to:
  /// **'More information'**
  String get moreInfo;

  /// Message showing the current streak of completed days
  ///
  /// In en, this message translates to:
  /// **'Current streak: {days} days'**
  String currentStreak(Object days);

  /// Instruction asking the user to choose their training days
  ///
  /// In en, this message translates to:
  /// **'Select your training days'**
  String get selectTrainingDays;

  /// Label for the save button
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Explanation that selected days are used to calculate the user's training streak
  ///
  /// In en, this message translates to:
  /// **'The selected days will be used to calculate your training streak'**
  String get selectedDaysInfo;

  /// Message shown when the user rejects the terms of service
  ///
  /// In en, this message translates to:
  /// **'Terms of service rejected'**
  String get termsRejected;

  /// Title for terms of use and privacy policy section
  ///
  /// In en, this message translates to:
  /// **'Terms of Use & Privacy Policy'**
  String get termsAndPrivacy;

  /// Instruction asking the user to read and accept terms
  ///
  /// In en, this message translates to:
  /// **'Read and accept the terms of service to continue.'**
  String get acceptTermsMessage;

  /// Button label to reject the terms
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// Button label to accept the terms
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// Message showing countdown seconds left
  ///
  /// In en, this message translates to:
  /// **'{seconds} seconds'**
  String secondsLeft(Object seconds);

  /// Title for the FitTracker terms of use and privacy policy
  ///
  /// In en, this message translates to:
  /// **'FitTracker — Terms of Use & Privacy Policy'**
  String get fitTrackerTermsTitle;

  /// Information about the public document version and last update
  ///
  /// In en, this message translates to:
  /// **'Public document for use in the Play Store / App Store — Last updated: 09/11/2025'**
  String get publicDocumentInfo;

  /// Specifies the login method used by the app
  ///
  /// In en, this message translates to:
  /// **'Login: Google Sign-In'**
  String get loginMethod;

  /// Specifies the storage method used by the app
  ///
  /// In en, this message translates to:
  /// **'Storage: Firebase (Google Cloud)'**
  String get storageMethod;

  /// Indicates the minimum age required to use the app
  ///
  /// In en, this message translates to:
  /// **'Minimum age: 13+'**
  String get minimumAge;

  /// Label for terms of use section
  ///
  /// In en, this message translates to:
  /// **'Terms of Use'**
  String get termsOfUse;

  /// Instruction explaining that using the app implies acceptance of terms
  ///
  /// In en, this message translates to:
  /// **'Read carefully — using the app implies acceptance of these terms.'**
  String get readCarefully;

  /// Title for acceptance of terms section
  ///
  /// In en, this message translates to:
  /// **'Acceptance of Terms'**
  String get termsAcceptance;

  /// Message explaining that using the app implies agreement with terms
  ///
  /// In en, this message translates to:
  /// **'By using FitTracker, you agree to these Terms. If you do not agree, do not use the app.'**
  String get termsAcceptanceMessage;

  /// Title for app purpose section
  ///
  /// In en, this message translates to:
  /// **'Purpose of the App'**
  String get appPurpose;

  /// Explanation of the purpose of the app
  ///
  /// In en, this message translates to:
  /// **'FitTracker is a tool for tracking workouts and physical progress. It does not replace medical or professional fitness guidance.'**
  String get appPurposeMessage;

  /// Title for login and account section
  ///
  /// In en, this message translates to:
  /// **'Login and Account'**
  String get loginAndAccount;

  /// Explanation of login method and responsibility
  ///
  /// In en, this message translates to:
  /// **'Login in FitTracker is done exclusively through your Google account. We do not require creating an account within the app. Access to your Google account is your sole responsibility.'**
  String get loginAndAccountMessage;

  /// Title for responsible use section
  ///
  /// In en, this message translates to:
  /// **'Responsible Use'**
  String get responsibleUse;

  /// Message about responsible use of the app
  ///
  /// In en, this message translates to:
  /// **'You are responsible for the information and data entered in the app. Do not use FitTracker for illegal practices or anything that may compromise your health.'**
  String get responsibleUseMessage;

  /// Title for minimum age section
  ///
  /// In en, this message translates to:
  /// **'Minimum Age'**
  String get minimumAgeTitle;

  /// Message about minimum age requirement
  ///
  /// In en, this message translates to:
  /// **'FitTracker is intended for users aged 13 or older.'**
  String get minimumAgeMessage;

  /// Title for limitation of liability section
  ///
  /// In en, this message translates to:
  /// **'Limitation of Liability'**
  String get liabilityLimitation;

  /// Message explaining limitation of liability
  ///
  /// In en, this message translates to:
  /// **'FitTracker does not guarantee health or fitness results. It only serves as a tracking and logging tool.'**
  String get liabilityLimitationMessage;

  /// Title for modifications section
  ///
  /// In en, this message translates to:
  /// **'Modifications'**
  String get modifications;

  /// Message about updates to terms
  ///
  /// In en, this message translates to:
  /// **'We may update these Terms at any time. Continued use of the app means you accept the changes.'**
  String get modificationsMessage;

  /// Title for the section listing the app's library licenses
  ///
  /// In en, this message translates to:
  /// **'Library Licenses'**
  String get libraryLicenses;

  /// Label for MIT License
  ///
  /// In en, this message translates to:
  /// **'MIT License'**
  String get mitLicense;

  /// Label for BSD 2-Clause License
  ///
  /// In en, this message translates to:
  /// **'BSD 2-Clause License'**
  String get bsd2ClauseLicense;

  /// Label for BSD 3-Clause License
  ///
  /// In en, this message translates to:
  /// **'BSD 3-Clause License'**
  String get bsd3ClauseLicense;

  /// Label for Apache 2.0 License
  ///
  /// In en, this message translates to:
  /// **'Apache 2.0 License'**
  String get apacheLicense;

  /// Title for the privacy policy section
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// Short description of the privacy policy
  ///
  /// In en, this message translates to:
  /// **'Transparency about what data we collect and how it is used.'**
  String get privacyPolicyDescription;

  /// Title for section about data collected
  ///
  /// In en, this message translates to:
  /// **'Collected Data'**
  String get collectedData;

  /// Title for section about how collected information is used
  ///
  /// In en, this message translates to:
  /// **'Use of Information'**
  String get useOfInformation;

  /// Title for section about third-party services
  ///
  /// In en, this message translates to:
  /// **'Third-Party Services'**
  String get thirdPartyServices;

  /// Title for section about data sharing practices
  ///
  /// In en, this message translates to:
  /// **'Data Sharing'**
  String get dataSharing;

  /// Title for section about data storage and security measures
  ///
  /// In en, this message translates to:
  /// **'Storage and Security'**
  String get storageAndSecurity;

  /// Title for section about deleting user account and data
  ///
  /// In en, this message translates to:
  /// **'Account and Data Deletion'**
  String get accountAndDataDeletion;

  /// Title for section about policy updates
  ///
  /// In en, this message translates to:
  /// **'Changes to this Policy'**
  String get policyChanges;

  /// Title for contact section
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact;

  /// Statement about data not being sold or shared
  ///
  /// In en, this message translates to:
  /// **'Data is not sold or shared with third parties, except when required by law or to comply with legal orders.'**
  String get dataNotSold;

  /// Information about data storage and security
  ///
  /// In en, this message translates to:
  /// **'Information is stored on Firebase (Google Cloud) servers. We employ technical and organizational measures to protect data, but no system is 100% secure.'**
  String get dataStorageSecurity;

  /// Instructions for users on how to request account and data deletion
  ///
  /// In en, this message translates to:
  /// **'You may request deletion of your account and data at any time. To do this, send an email to:'**
  String get accountDeletionInstructions;

  /// Explanation of the timeframe for data deletion
  ///
  /// In en, this message translates to:
  /// **'After the request, it may take up to 30 days to remove backups and replicas, according to technical and legal practices.'**
  String get deletionTimeframe;

  /// Information about updates to the privacy policy
  ///
  /// In en, this message translates to:
  /// **'We may update this Policy. Users will be notified via the app or email when relevant changes occur.'**
  String get policyUpdates;

  /// Contact email placeholder for privacy inquiries
  ///
  /// In en, this message translates to:
  /// **'Questions or requests about privacy: {email}'**
  String privacyQuestions(Object email);

  /// Explanation about the third-party services used by the app
  ///
  /// In en, this message translates to:
  /// **'FitTracker uses Google services for authentication and storage:\n\n• Google Sign-In — used only for authentication.\n• Firebase (Google Cloud) — used to store app data.\n\nUse of these services is subject to Google\'s Privacy Policy.'**
  String get thirdPartyServicesDescription;

  /// Explanation of how collected information is used
  ///
  /// In en, this message translates to:
  /// **'• Identify your account within the app.\n• Save and sync your workouts and progress across devices.\n• Improve the experience and fix technical issues.'**
  String get useOfInformationDescription;

  /// Explanation of the data collected by the app
  ///
  /// In en, this message translates to:
  /// **'FitTracker only collects the following data:\n\n• Google user ID (provided via Google Sign-In).\n• Data generated by app usage (e.g., workouts, goals, progress, in-app usage statistics).\n\nWe do not collect name, email, phone, or other personal data directly.'**
  String get collectedDataDescription;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'pt': return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
