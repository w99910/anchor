import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_it.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_th.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
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
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('it'),
    Locale('pt'),
    Locale('th'),
  ];

  /// The name of the application
  ///
  /// In en, this message translates to:
  /// **'Anchor'**
  String get appName;

  /// Chat page title
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// Journal page title
  ///
  /// In en, this message translates to:
  /// **'Journal'**
  String get journal;

  /// Home page title
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Settings page title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Help page title
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// Friend mode in chat
  ///
  /// In en, this message translates to:
  /// **'Friend'**
  String get friend;

  /// Therapist label
  ///
  /// In en, this message translates to:
  /// **'Therapist'**
  String get therapist;

  /// Empty state title for friend mode
  ///
  /// In en, this message translates to:
  /// **'Chat with a friend'**
  String get chatWithFriend;

  /// Empty state title for therapist mode
  ///
  /// In en, this message translates to:
  /// **'Guided conversation'**
  String get guidedConversation;

  /// Empty state description for friend mode
  ///
  /// In en, this message translates to:
  /// **'I\'m here to listen. Share anything on your mind.'**
  String get friendEmptyStateDescription;

  /// Empty state description for therapist mode
  ///
  /// In en, this message translates to:
  /// **'Explore your thoughts with guided therapeutic dialogue.'**
  String get therapistEmptyStateDescription;

  /// Input placeholder
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get typeMessage;

  /// Shown while AI is generating
  ///
  /// In en, this message translates to:
  /// **'Thinking...'**
  String get thinking;

  /// Shown while model is loading
  ///
  /// In en, this message translates to:
  /// **'Loading model...'**
  String get loadingModel;

  /// Download model button
  ///
  /// In en, this message translates to:
  /// **'Download Model'**
  String get downloadModel;

  /// Download AI model title
  ///
  /// In en, this message translates to:
  /// **'Download AI Model'**
  String get downloadAiModel;

  /// Advanced AI model name
  ///
  /// In en, this message translates to:
  /// **'Advanced AI'**
  String get advancedAi;

  /// Compact AI model name
  ///
  /// In en, this message translates to:
  /// **'Compact AI'**
  String get compactAi;

  /// On-device AI chat title
  ///
  /// In en, this message translates to:
  /// **'On-Device AI Chat'**
  String get onDeviceAiChat;

  /// Select model section title
  ///
  /// In en, this message translates to:
  /// **'Select Model'**
  String get selectModel;

  /// Recommended badge
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get recommended;

  /// Current badge for downloaded model
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get current;

  /// Label for currently used model
  ///
  /// In en, this message translates to:
  /// **'Currently in use'**
  String get currentlyInUse;

  /// Advanced model description
  ///
  /// In en, this message translates to:
  /// **'More capable • Better responses'**
  String get moreCapableBetterResponses;

  /// Compact model description
  ///
  /// In en, this message translates to:
  /// **'Lightweight • Fast responses'**
  String get lightweightFastResponses;

  /// Download size label
  ///
  /// In en, this message translates to:
  /// **'~{size} download'**
  String downloadSize(String size);

  /// Model ready status
  ///
  /// In en, this message translates to:
  /// **'Model Ready'**
  String get modelReady;

  /// Start chatting button
  ///
  /// In en, this message translates to:
  /// **'Start Chatting'**
  String get startChatting;

  /// Switch model button
  ///
  /// In en, this message translates to:
  /// **'Switch to Different Model'**
  String get switchToDifferentModel;

  /// Appearance settings section
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// Language settings section
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Select language title
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// AI provider settings section
  ///
  /// In en, this message translates to:
  /// **'AI Provider'**
  String get aiProvider;

  /// Security settings section
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// Notifications settings section
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Data settings section
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get data;

  /// App lock setting
  ///
  /// In en, this message translates to:
  /// **'App lock'**
  String get appLock;

  /// Push notifications setting
  ///
  /// In en, this message translates to:
  /// **'Push notifications'**
  String get pushNotifications;

  /// Clear history option
  ///
  /// In en, this message translates to:
  /// **'Clear history'**
  String get clearHistory;

  /// Export data option
  ///
  /// In en, this message translates to:
  /// **'Export data'**
  String get exportData;

  /// Skip button
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// Next button
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Get started button
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// Continue button
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueText;

  /// Onboarding feature 1 title
  ///
  /// In en, this message translates to:
  /// **'Journal your thoughts'**
  String get journalYourThoughts;

  /// Onboarding feature 1 description
  ///
  /// In en, this message translates to:
  /// **'Express yourself freely and track your emotional journey over time.'**
  String get journalDescription;

  /// Onboarding feature 2 title
  ///
  /// In en, this message translates to:
  /// **'Talk to AI companion'**
  String get talkToAiCompanion;

  /// Onboarding feature 2 description
  ///
  /// In en, this message translates to:
  /// **'Chat anytime with a supportive AI friend or therapist.'**
  String get talkToAiDescription;

  /// Onboarding feature 3 title
  ///
  /// In en, this message translates to:
  /// **'Track your progress'**
  String get trackYourProgress;

  /// Onboarding feature 3 description
  ///
  /// In en, this message translates to:
  /// **'Understand your mental patterns with insights and evaluations.'**
  String get trackProgressDescription;

  /// Language selection page title
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get chooseYourLanguage;

  /// Language selection page description
  ///
  /// In en, this message translates to:
  /// **'Select your preferred language for the app. You can change this later in settings.'**
  String get languageDescription;

  /// English language name
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Thai language name
  ///
  /// In en, this message translates to:
  /// **'ไทย'**
  String get thai;

  /// German language name
  ///
  /// In en, this message translates to:
  /// **'Deutsch'**
  String get german;

  /// French language name
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get french;

  /// Italian language name
  ///
  /// In en, this message translates to:
  /// **'Italiano'**
  String get italian;

  /// Portuguese language name
  ///
  /// In en, this message translates to:
  /// **'Português'**
  String get portuguese;

  /// Hindi language name
  ///
  /// In en, this message translates to:
  /// **'हिन्दी'**
  String get hindi;

  /// Spanish language name
  ///
  /// In en, this message translates to:
  /// **'Español'**
  String get spanish;

  /// On-device AI option
  ///
  /// In en, this message translates to:
  /// **'On-device'**
  String get onDevice;

  /// Cloud AI option
  ///
  /// In en, this message translates to:
  /// **'Cloud'**
  String get cloud;

  /// Privacy label for on-device
  ///
  /// In en, this message translates to:
  /// **'100% on-device'**
  String get privateOnDevice;

  /// Cloud AI status
  ///
  /// In en, this message translates to:
  /// **'Using Cloud AI'**
  String get usingCloudAi;

  /// Offline mode label
  ///
  /// In en, this message translates to:
  /// **'Offline mode'**
  String get offlineMode;

  /// AI ready status
  ///
  /// In en, this message translates to:
  /// **'AI Ready'**
  String get aiReady;

  /// Native AI backend
  ///
  /// In en, this message translates to:
  /// **'Native AI'**
  String get nativeAi;

  /// Demo mode status
  ///
  /// In en, this message translates to:
  /// **'Demo mode'**
  String get demoMode;

  /// Checking model status
  ///
  /// In en, this message translates to:
  /// **'Checking model...'**
  String get checkingModel;

  /// Loading AI model status
  ///
  /// In en, this message translates to:
  /// **'Loading AI model...'**
  String get loadingAiModel;

  /// Preparing model description
  ///
  /// In en, this message translates to:
  /// **'Preparing the model for chat'**
  String get preparingModelForChat;

  /// Model download description
  ///
  /// In en, this message translates to:
  /// **'Get the {modelName} model for private, on-device AI chat'**
  String getModelForPrivateChat(String modelName);

  /// Load model button
  ///
  /// In en, this message translates to:
  /// **'Load Model'**
  String get loadModel;

  /// AI model ready status
  ///
  /// In en, this message translates to:
  /// **'AI model ready'**
  String get aiModelReady;

  /// Load model description
  ///
  /// In en, this message translates to:
  /// **'Load the model to start chatting'**
  String get loadModelToStartChatting;

  /// Device RAM message
  ///
  /// In en, this message translates to:
  /// **'Your device has enough RAM for both models'**
  String get deviceHasEnoughRam;

  /// Wi-Fi recommendation message
  ///
  /// In en, this message translates to:
  /// **'Requires Wi-Fi recommended. Download size: ~{size}'**
  String wifiRecommended(String size);

  /// Checking model status message
  ///
  /// In en, this message translates to:
  /// **'Checking model status...'**
  String get checkingModelStatus;

  /// Download failed title
  ///
  /// In en, this message translates to:
  /// **'Download Failed'**
  String get downloadFailed;

  /// Retry download button
  ///
  /// In en, this message translates to:
  /// **'Retry Download'**
  String get retryDownload;

  /// Keep app open message
  ///
  /// In en, this message translates to:
  /// **'Please keep the app open during download'**
  String get keepAppOpen;

  /// Keep app open during download message
  ///
  /// In en, this message translates to:
  /// **'Please keep the app open during download'**
  String get keepAppOpenDuringDownload;

  /// Switch button text
  ///
  /// In en, this message translates to:
  /// **'Switch'**
  String get switchText;

  /// Change button
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// Downloading status
  ///
  /// In en, this message translates to:
  /// **'Downloading...'**
  String get downloading;

  /// Change model tooltip
  ///
  /// In en, this message translates to:
  /// **'Change model'**
  String get changeModel;

  /// Error message in chat
  ///
  /// In en, this message translates to:
  /// **'I\'m sorry, I encountered an issue. Please try again.'**
  String get errorOccurred;

  /// Size label
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get size;

  /// Privacy label
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// Download model page description
  ///
  /// In en, this message translates to:
  /// **'Download the AI model to enable private, on-device conversations.'**
  String get downloadModelDescription;

  /// Choose AI model page description
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred AI model for private, on-device conversations.'**
  String get choosePreferredAiModel;

  /// Wi-Fi recommendation with download size
  ///
  /// In en, this message translates to:
  /// **'Requires Wi-Fi recommended. Download size: ~{size}'**
  String requiresWifiDownloadSize(String size);

  /// Choose model page description
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred AI model for private, on-device conversations.'**
  String get chooseModelDescription;

  /// User info page title
  ///
  /// In en, this message translates to:
  /// **'About you'**
  String get aboutYou;

  /// User info page subtitle
  ///
  /// In en, this message translates to:
  /// **'Help us personalize your experience'**
  String get helpPersonalizeExperience;

  /// Name field label
  ///
  /// In en, this message translates to:
  /// **'What should we call you?'**
  String get whatShouldWeCallYou;

  /// Name field placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter your name or nickname'**
  String get enterNameOrNickname;

  /// Birth year field label
  ///
  /// In en, this message translates to:
  /// **'Birth year'**
  String get birthYear;

  /// Year selector placeholder
  ///
  /// In en, this message translates to:
  /// **'Select year'**
  String get selectYear;

  /// Year picker title
  ///
  /// In en, this message translates to:
  /// **'Select birth year'**
  String get selectBirthYear;

  /// Gender field label
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// Male gender option
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// Female gender option
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// Non-binary gender option
  ///
  /// In en, this message translates to:
  /// **'Non-binary'**
  String get nonBinary;

  /// Prefer not to say gender option
  ///
  /// In en, this message translates to:
  /// **'Prefer not to say'**
  String get preferNotToSay;

  /// First personalized question
  ///
  /// In en, this message translates to:
  /// **'What brings you here?'**
  String get whatBringsYouHere;

  /// Answer option
  ///
  /// In en, this message translates to:
  /// **'Manage stress'**
  String get manageStress;

  /// Answer option
  ///
  /// In en, this message translates to:
  /// **'Track mood'**
  String get trackMood;

  /// Answer option
  ///
  /// In en, this message translates to:
  /// **'Build habits'**
  String get buildHabits;

  /// Answer option
  ///
  /// In en, this message translates to:
  /// **'Self-reflection'**
  String get selfReflection;

  /// Answer option
  ///
  /// In en, this message translates to:
  /// **'Just exploring'**
  String get justExploring;

  /// Second personalized question
  ///
  /// In en, this message translates to:
  /// **'How often would you like to journal?'**
  String get howOftenJournal;

  /// Answer option
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get daily;

  /// Answer option
  ///
  /// In en, this message translates to:
  /// **'Few times a week'**
  String get fewTimesWeek;

  /// Answer option
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weekly;

  /// Answer option
  ///
  /// In en, this message translates to:
  /// **'When I feel like it'**
  String get whenIFeelLikeIt;

  /// Third personalized question
  ///
  /// In en, this message translates to:
  /// **'What time works best for check-ins?'**
  String get bestTimeForCheckIns;

  /// Answer option
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get morning;

  /// Answer option
  ///
  /// In en, this message translates to:
  /// **'Afternoon'**
  String get afternoon;

  /// Answer option
  ///
  /// In en, this message translates to:
  /// **'Evening'**
  String get evening;

  /// Answer option
  ///
  /// In en, this message translates to:
  /// **'Flexible'**
  String get flexible;

  /// Question progress indicator
  ///
  /// In en, this message translates to:
  /// **'{current} of {total}'**
  String questionOf(int current, int total);

  /// Download model page title
  ///
  /// In en, this message translates to:
  /// **'Choose your AI'**
  String get chooseYourAi;

  /// Download model page subtitle
  ///
  /// In en, this message translates to:
  /// **'Select how you want to power your AI assistant'**
  String get selectHowToPowerAi;

  /// On-device AI option title
  ///
  /// In en, this message translates to:
  /// **'On-Device AI'**
  String get onDeviceAi;

  /// On-device AI subtitle
  ///
  /// In en, this message translates to:
  /// **'Maximum privacy'**
  String get maximumPrivacy;

  /// On-device AI description
  ///
  /// In en, this message translates to:
  /// **'Runs entirely on your device. Your data never leaves your phone.'**
  String get onDeviceDescription;

  /// On-device benefit
  ///
  /// In en, this message translates to:
  /// **'Complete privacy'**
  String get completePrivacy;

  /// On-device benefit
  ///
  /// In en, this message translates to:
  /// **'Works offline'**
  String get worksOffline;

  /// On-device benefit
  ///
  /// In en, this message translates to:
  /// **'No subscription needed'**
  String get noSubscriptionNeeded;

  /// On-device drawback
  ///
  /// In en, this message translates to:
  /// **'Requires ~2GB download'**
  String get requires2GBDownload;

  /// On-device drawback
  ///
  /// In en, this message translates to:
  /// **'Uses device resources'**
  String get usesDeviceResources;

  /// Cloud AI option title
  ///
  /// In en, this message translates to:
  /// **'Cloud AI'**
  String get cloudAi;

  /// Cloud AI subtitle
  ///
  /// In en, this message translates to:
  /// **'More powerful'**
  String get morePowerful;

  /// Cloud AI description
  ///
  /// In en, this message translates to:
  /// **'Powered by cloud providers for faster, smarter responses.'**
  String get cloudDescription;

  /// Cloud benefit
  ///
  /// In en, this message translates to:
  /// **'More capable models'**
  String get moreCapableModels;

  /// Cloud benefit
  ///
  /// In en, this message translates to:
  /// **'Faster responses'**
  String get fasterResponses;

  /// Cloud benefit
  ///
  /// In en, this message translates to:
  /// **'No storage needed'**
  String get noStorageNeeded;

  /// Cloud drawback
  ///
  /// In en, this message translates to:
  /// **'Requires internet'**
  String get requiresInternet;

  /// Cloud drawback
  ///
  /// In en, this message translates to:
  /// **'Data sent to cloud'**
  String get dataSentToCloud;

  /// Downloading model progress
  ///
  /// In en, this message translates to:
  /// **'Downloading model... {progress}%'**
  String downloadingModel(int progress);

  /// Setting up progress
  ///
  /// In en, this message translates to:
  /// **'Setting up... {progress}%'**
  String settingUp(int progress);

  /// Setup failed error message
  ///
  /// In en, this message translates to:
  /// **'Setup failed. Please try again.'**
  String get setupFailed;

  /// Insights page title
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get insights;

  /// Morning greeting
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get goodMorning;

  /// Morning greeting with name
  ///
  /// In en, this message translates to:
  /// **'Good morning, {name}'**
  String goodMorningName(String name);

  /// Afternoon greeting
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get goodAfternoon;

  /// Afternoon greeting with name
  ///
  /// In en, this message translates to:
  /// **'Good afternoon, {name}'**
  String goodAfternoonName(String name);

  /// Evening greeting
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get goodEvening;

  /// Evening greeting with name
  ///
  /// In en, this message translates to:
  /// **'Good evening, {name}'**
  String goodEveningName(String name);

  /// Greeting question
  ///
  /// In en, this message translates to:
  /// **'How are you today?'**
  String get howAreYouToday;

  /// Great mood label
  ///
  /// In en, this message translates to:
  /// **'Great'**
  String get moodGreat;

  /// Good mood label
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get moodGood;

  /// Okay mood label
  ///
  /// In en, this message translates to:
  /// **'Okay'**
  String get moodOkay;

  /// Low mood label
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get moodLow;

  /// Sad mood label
  ///
  /// In en, this message translates to:
  /// **'Sad'**
  String get moodSad;

  /// This week section title
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get thisWeek;

  /// Upcoming appointments section title
  ///
  /// In en, this message translates to:
  /// **'Upcoming Appointments'**
  String get upcomingAppointments;

  /// Average mood stat label
  ///
  /// In en, this message translates to:
  /// **'Avg. Mood'**
  String get avgMood;

  /// Journal entries stat label
  ///
  /// In en, this message translates to:
  /// **'Journal Entries'**
  String get journalEntries;

  /// Chat sessions stat label
  ///
  /// In en, this message translates to:
  /// **'Chat Sessions'**
  String get chatSessions;

  /// Stress level stat label
  ///
  /// In en, this message translates to:
  /// **'Stress Level'**
  String get stressLevel;

  /// Start streak prompt
  ///
  /// In en, this message translates to:
  /// **'Start your streak!'**
  String get startYourStreak;

  /// Start streak description
  ///
  /// In en, this message translates to:
  /// **'Write a journal entry to begin'**
  String get writeJournalToBegin;

  /// Streak count message
  ///
  /// In en, this message translates to:
  /// **'{count} day streak!'**
  String dayStreak(int count);

  /// Long streak encouragement
  ///
  /// In en, this message translates to:
  /// **'Amazing consistency! Keep it up!'**
  String get amazingConsistency;

  /// Short streak encouragement
  ///
  /// In en, this message translates to:
  /// **'Keep the momentum going'**
  String get keepMomentumGoing;

  /// Today label
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// Tomorrow label
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get tomorrow;

  /// New entry button
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get newEntry;

  /// Empty journal state title
  ///
  /// In en, this message translates to:
  /// **'No journal entries yet'**
  String get noJournalEntriesYet;

  /// Empty journal state description
  ///
  /// In en, this message translates to:
  /// **'Tap the + button to create your first entry'**
  String get tapToCreateFirstEntry;

  /// Draft status label
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get draft;

  /// Finalized status label
  ///
  /// In en, this message translates to:
  /// **'Finalized'**
  String get finalized;

  /// Help page title
  ///
  /// In en, this message translates to:
  /// **'Get help'**
  String get getHelp;

  /// Help page subtitle
  ///
  /// In en, this message translates to:
  /// **'Connect with licensed professionals'**
  String get connectWithProfessionals;

  /// Your appointments section title
  ///
  /// In en, this message translates to:
  /// **'Your Appointments'**
  String get yourAppointments;

  /// Crisis card title
  ///
  /// In en, this message translates to:
  /// **'In crisis?'**
  String get inCrisis;

  /// Crisis card description
  ///
  /// In en, this message translates to:
  /// **'Call emergency services immediately'**
  String get callEmergencyServices;

  /// Call button
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get call;

  /// Services section title
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get services;

  /// Resources section title
  ///
  /// In en, this message translates to:
  /// **'Resources'**
  String get resources;

  /// Therapist session service title
  ///
  /// In en, this message translates to:
  /// **'Therapist session'**
  String get therapistSession;

  /// Therapist session description
  ///
  /// In en, this message translates to:
  /// **'One-on-one with a licensed therapist'**
  String get oneOnOneWithTherapist;

  /// Consultation service title
  ///
  /// In en, this message translates to:
  /// **'Mental health consultation'**
  String get mentalHealthConsultation;

  /// Consultation service description
  ///
  /// In en, this message translates to:
  /// **'General wellness guidance'**
  String get generalWellnessGuidance;

  /// Articles resource
  ///
  /// In en, this message translates to:
  /// **'Articles'**
  String get articles;

  /// Meditations resource
  ///
  /// In en, this message translates to:
  /// **'Guided meditations'**
  String get guidedMeditations;

  /// Hotlines resource
  ///
  /// In en, this message translates to:
  /// **'Crisis hotlines'**
  String get crisisHotlines;

  /// Join button for appointments
  ///
  /// In en, this message translates to:
  /// **'Join'**
  String get join;

  /// Insights page subtitle
  ///
  /// In en, this message translates to:
  /// **'Track and understand your mental wellness'**
  String get trackMentalWellness;

  /// Assessment section title
  ///
  /// In en, this message translates to:
  /// **'Take an assessment'**
  String get takeAssessment;

  /// Emotional assessment title
  ///
  /// In en, this message translates to:
  /// **'Emotional check-in'**
  String get emotionalCheckIn;

  /// Emotional assessment description
  ///
  /// In en, this message translates to:
  /// **'Understand your current emotional state'**
  String get understandEmotionalState;

  /// Stress assessment title
  ///
  /// In en, this message translates to:
  /// **'Stress assessment'**
  String get stressAssessment;

  /// Stress assessment description
  ///
  /// In en, this message translates to:
  /// **'Measure your stress levels'**
  String get measureStressLevels;

  /// Recent results section title
  ///
  /// In en, this message translates to:
  /// **'Recent results'**
  String get recentResults;

  /// Check-in label
  ///
  /// In en, this message translates to:
  /// **'check-in'**
  String get checkIn;

  /// Cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Progress indicator
  ///
  /// In en, this message translates to:
  /// **'{current} of {total}'**
  String nOfTotal(int current, int total);

  /// Emotional well-being title
  ///
  /// In en, this message translates to:
  /// **'Emotional well-being'**
  String get emotionalWellbeing;

  /// Stress management title
  ///
  /// In en, this message translates to:
  /// **'Stress management'**
  String get stressManagement;

  /// Suggestions section title
  ///
  /// In en, this message translates to:
  /// **'Suggestions'**
  String get suggestions;

  /// Done button
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// Talk to professional button
  ///
  /// In en, this message translates to:
  /// **'Talk to a professional'**
  String get talkToProfessional;

  /// AI Model page title
  ///
  /// In en, this message translates to:
  /// **'AI Model'**
  String get aiModel;

  /// Empty content warning
  ///
  /// In en, this message translates to:
  /// **'Please write something first'**
  String get pleaseWriteSomethingFirst;

  /// Cloud AI dialog title
  ///
  /// In en, this message translates to:
  /// **'Use Cloud AI?'**
  String get useCloudAi;

  /// Cloud AI switch warning
  ///
  /// In en, this message translates to:
  /// **'You are about to switch to a cloud AI provider (Gemini).'**
  String get aboutToSwitchToCloud;

  /// Cloud AI privacy warning
  ///
  /// In en, this message translates to:
  /// **'Your conversations will be sent to Google servers. We cannot guarantee data privacy when using cloud AI.'**
  String get cloudPrivacyWarning;

  /// On-device privacy recommendation
  ///
  /// In en, this message translates to:
  /// **'For maximum privacy, use the on-device AI option.'**
  String get forMaxPrivacy;

  /// Understand confirmation button
  ///
  /// In en, this message translates to:
  /// **'I Understand'**
  String get iUnderstand;

  /// Cloud AI switched message
  ///
  /// In en, this message translates to:
  /// **'Switched to Cloud AI (Gemini)'**
  String get switchedToCloudAi;

  /// On-device AI switched message
  ///
  /// In en, this message translates to:
  /// **'Switched to On-Device AI'**
  String get switchedToOnDeviceAi;

  /// Language changed message
  ///
  /// In en, this message translates to:
  /// **'Language changed to {language}'**
  String languageChangedTo(String language);

  /// Clear history dialog title
  ///
  /// In en, this message translates to:
  /// **'Clear history?'**
  String get clearHistoryQuestion;

  /// Clear history warning
  ///
  /// In en, this message translates to:
  /// **'This will delete all your data. This cannot be undone.'**
  String get clearHistoryWarning;

  /// Clear button
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// History cleared message
  ///
  /// In en, this message translates to:
  /// **'History cleared'**
  String get historyCleared;

  /// About Anchor menu item
  ///
  /// In en, this message translates to:
  /// **'About Anchor'**
  String get aboutAnchor;

  /// Privacy policy menu item
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacyPolicy;

  /// Help and support menu item
  ///
  /// In en, this message translates to:
  /// **'Help & support'**
  String get helpAndSupport;

  /// Version label
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String version(String version);

  /// App description
  ///
  /// In en, this message translates to:
  /// **'Your mental wellness companion.'**
  String get yourWellnessCompanion;

  /// System theme option
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// Light theme option
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// Dark theme option
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// On-device AI provider option
  ///
  /// In en, this message translates to:
  /// **'On-Device'**
  String get onDeviceProvider;

  /// On-device description
  ///
  /// In en, this message translates to:
  /// **'Private, runs locally'**
  String get privateRunsLocally;

  /// Cloud Gemini provider option
  ///
  /// In en, this message translates to:
  /// **'Cloud (Gemini)'**
  String get cloudGemini;

  /// Cloud provider description
  ///
  /// In en, this message translates to:
  /// **'Faster, requires internet'**
  String get fasterRequiresInternet;

  /// API key not configured message
  ///
  /// In en, this message translates to:
  /// **'API key not configured'**
  String get apiKeyNotConfigured;

  /// About section title
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// Find therapist page title
  ///
  /// In en, this message translates to:
  /// **'Find a therapist'**
  String get findTherapist;

  /// Search placeholder
  ///
  /// In en, this message translates to:
  /// **'Search by name or specialty...'**
  String get searchByNameOrSpecialty;

  /// Therapists count
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} therapist available} other{{count} therapists available}}'**
  String therapistsAvailable(int count);

  /// Switch button
  ///
  /// In en, this message translates to:
  /// **'Switch'**
  String get switchLabel;

  /// Change model tooltip
  ///
  /// In en, this message translates to:
  /// **'Change model ({modelName})'**
  String changeModelTooltip(String modelName);

  /// Offline status
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// Model error label
  ///
  /// In en, this message translates to:
  /// **'Model error'**
  String get modelError;

  /// Cloud AI label
  ///
  /// In en, this message translates to:
  /// **'Cloud AI'**
  String get cloudAiLabel;

  /// Using Cloud AI badge label
  ///
  /// In en, this message translates to:
  /// **'Using Cloud AI'**
  String get usingCloudAiLabel;

  /// From price label
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// Per session price suffix
  ///
  /// In en, this message translates to:
  /// **'/session'**
  String get perSession;

  /// Unavailable status
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get unavailable;

  /// Book session button
  ///
  /// In en, this message translates to:
  /// **'Book session'**
  String get bookSession;

  /// View profile button
  ///
  /// In en, this message translates to:
  /// **'View profile'**
  String get viewProfile;

  /// Time selection validation message
  ///
  /// In en, this message translates to:
  /// **'Please select a time'**
  String get pleaseSelectTime;

  /// Date label
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// Time label
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// Urgency label
  ///
  /// In en, this message translates to:
  /// **'Urgency'**
  String get urgency;

  /// Normal urgency option
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get normal;

  /// Regular scheduling description
  ///
  /// In en, this message translates to:
  /// **'Regular scheduling'**
  String get regularScheduling;

  /// Urgent option
  ///
  /// In en, this message translates to:
  /// **'Urgent'**
  String get urgent;

  /// Priority description with price
  ///
  /// In en, this message translates to:
  /// **'Priority (+\$20)'**
  String get priority;

  /// Checkout page title
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkout;

  /// Summary section title
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get summary;

  /// Type label
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// Price label
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// Session label
  ///
  /// In en, this message translates to:
  /// **'Session'**
  String get session;

  /// Urgency fee label
  ///
  /// In en, this message translates to:
  /// **'Urgency fee'**
  String get urgencyFee;

  /// Total label
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// Test mode warning message
  ///
  /// In en, this message translates to:
  /// **'Test mode: Using \$1 amount on Sepolia testnet'**
  String get testModeMessage;

  /// Cancellation policy message
  ///
  /// In en, this message translates to:
  /// **'Free cancellation up to 24 hours before'**
  String get freeCancellation;

  /// Pay button with amount
  ///
  /// In en, this message translates to:
  /// **'Pay \${amount}'**
  String payAmount(int amount);

  /// Payment page title
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// Payment method section title
  ///
  /// In en, this message translates to:
  /// **'Payment method'**
  String get paymentMethod;

  /// Credit/Debit card option
  ///
  /// In en, this message translates to:
  /// **'Credit / Debit Card'**
  String get creditDebitCard;

  /// Card brands
  ///
  /// In en, this message translates to:
  /// **'Visa, Mastercard, Amex'**
  String get visaMastercardAmex;

  /// PayPal option description
  ///
  /// In en, this message translates to:
  /// **'Pay with your PayPal account'**
  String get payWithPaypal;

  /// Card number field label
  ///
  /// In en, this message translates to:
  /// **'Card number'**
  String get cardNumber;

  /// Wallet connected status
  ///
  /// In en, this message translates to:
  /// **'Wallet connected'**
  String get walletConnected;

  /// Blockchain security badge
  ///
  /// In en, this message translates to:
  /// **'Secured by blockchain'**
  String get securedByBlockchain;

  /// Secure payment badge
  ///
  /// In en, this message translates to:
  /// **'Secure payment'**
  String get securePayment;

  /// Connect wallet button
  ///
  /// In en, this message translates to:
  /// **'Connect wallet to pay'**
  String get connectWalletToPay;

  /// Reviews count label
  ///
  /// In en, this message translates to:
  /// **'{count} reviews'**
  String reviewsCount(int count);

  /// Per session label
  ///
  /// In en, this message translates to:
  /// **'per session'**
  String get perSessionLabel;

  /// Minutes label
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get minutes;

  /// Available status
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// Currently unavailable status
  ///
  /// In en, this message translates to:
  /// **'Currently unavailable'**
  String get currentlyUnavailable;

  /// Next available slot
  ///
  /// In en, this message translates to:
  /// **'Next slot: {time}'**
  String nextSlot(String time);

  /// Specializations section title
  ///
  /// In en, this message translates to:
  /// **'Specializations'**
  String get specializations;

  /// Languages section title
  ///
  /// In en, this message translates to:
  /// **'Languages'**
  String get languages;

  /// Reviews section title
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviews;

  /// See all button
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// Book session button with price
  ///
  /// In en, this message translates to:
  /// **'Book session - \${price}'**
  String bookSessionWithPrice(int price);

  /// Unsaved changes indicator
  ///
  /// In en, this message translates to:
  /// **'Unsaved changes'**
  String get unsavedChanges;

  /// Journal entry placeholder text
  ///
  /// In en, this message translates to:
  /// **'What\'s on your mind?'**
  String get whatsOnYourMind;

  /// Analyzing entry status
  ///
  /// In en, this message translates to:
  /// **'Analyzing your entry...'**
  String get analyzingEntry;

  /// Finalizing status
  ///
  /// In en, this message translates to:
  /// **'Finalizing...'**
  String get finalizing;

  /// Status message for loading
  ///
  /// In en, this message translates to:
  /// **'This may take a moment'**
  String get thisMayTakeAMoment;

  /// AI generating insights status
  ///
  /// In en, this message translates to:
  /// **'AI is generating insights'**
  String get aiGeneratingInsights;

  /// Error when trying to save empty journal
  ///
  /// In en, this message translates to:
  /// **'Please write something first'**
  String get pleaseWriteSomething;

  /// Failed to save error message
  ///
  /// In en, this message translates to:
  /// **'Failed to save: {error}'**
  String failedToSave(String error);

  /// Failed to finalize error message
  ///
  /// In en, this message translates to:
  /// **'Failed to finalize: {error}'**
  String failedToFinalize(String error);

  /// Save options sheet title
  ///
  /// In en, this message translates to:
  /// **'What would you like to do?'**
  String get whatWouldYouLikeToDo;

  /// Save as draft option
  ///
  /// In en, this message translates to:
  /// **'Save as Draft'**
  String get saveAsDraft;

  /// Draft description
  ///
  /// In en, this message translates to:
  /// **'Keep editing for up to 3 days'**
  String get keepEditingForDays;

  /// Finalize with on-device AI
  ///
  /// In en, this message translates to:
  /// **'Finalize with AI'**
  String get finalizeWithAi;

  /// Finalize with cloud AI
  ///
  /// In en, this message translates to:
  /// **'Finalize with Cloud AI'**
  String get finalizeWithCloudAi;

  /// Finalize entry without AI
  ///
  /// In en, this message translates to:
  /// **'Finalize Entry'**
  String get finalizeEntry;

  /// Cloud AI finalize description
  ///
  /// In en, this message translates to:
  /// **'Get summary & analysis (uses Gemini)'**
  String get getSummaryAndAnalysisGemini;

  /// On-device AI finalize description
  ///
  /// In en, this message translates to:
  /// **'Get summary, emotion analysis & risk assessment'**
  String get getSummaryEmotionRisk;

  /// No AI finalize description
  ///
  /// In en, this message translates to:
  /// **'Lock entry and stop editing'**
  String get lockEntryAndStopEditing;

  /// Entry finalized title
  ///
  /// In en, this message translates to:
  /// **'Entry Finalized'**
  String get entryFinalized;

  /// Entry saved title
  ///
  /// In en, this message translates to:
  /// **'Entry Saved'**
  String get entrySaved;

  /// Entry analyzed subtitle
  ///
  /// In en, this message translates to:
  /// **'Your journal entry has been analyzed'**
  String get entryAnalyzed;

  /// Draft saved subtitle
  ///
  /// In en, this message translates to:
  /// **'Your draft has been saved'**
  String get draftSaved;

  /// Risk assessment card title
  ///
  /// In en, this message translates to:
  /// **'Risk Assessment'**
  String get riskAssessment;

  /// Emotional state card title
  ///
  /// In en, this message translates to:
  /// **'Emotional State'**
  String get emotionalState;

  /// AI summary card title
  ///
  /// In en, this message translates to:
  /// **'AI Summary'**
  String get aiSummary;

  /// Suggested actions card title
  ///
  /// In en, this message translates to:
  /// **'Suggested Actions'**
  String get suggestedActions;

  /// Draft mode indicator
  ///
  /// In en, this message translates to:
  /// **'Draft Mode'**
  String get draftMode;

  /// Draft mode description
  ///
  /// In en, this message translates to:
  /// **'You can continue editing this entry for up to 3 days. When ready, finalize it to get AI-powered insights.'**
  String get draftModeDescription;

  /// EthStorage stored label
  ///
  /// In en, this message translates to:
  /// **'Stored on EthStorage'**
  String get storedOnEthStorage;

  /// EthStorage configuration required title
  ///
  /// In en, this message translates to:
  /// **'EthStorage Configuration Required'**
  String get ethStorageConfigRequired;

  /// Retry button
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// View button
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// Uploading status
  ///
  /// In en, this message translates to:
  /// **'Uploading to EthStorage...'**
  String get uploadingToEthStorage;

  /// Store on EthStorage button
  ///
  /// In en, this message translates to:
  /// **'Store on EthStorage (Testnet)'**
  String get storeOnEthStorage;

  /// Success message for EthStorage upload
  ///
  /// In en, this message translates to:
  /// **'Successfully uploaded to EthStorage!'**
  String get successfullyUploaded;

  /// Browser open error message
  ///
  /// In en, this message translates to:
  /// **'Could not open browser. URL: {url}'**
  String couldNotOpenBrowser(String url);

  /// URL open error message
  ///
  /// In en, this message translates to:
  /// **'Error opening URL: {error}'**
  String errorOpeningUrl(String error);

  /// High risk description
  ///
  /// In en, this message translates to:
  /// **'Consider reaching out to a mental health professional'**
  String get riskHighDesc;

  /// Medium risk description
  ///
  /// In en, this message translates to:
  /// **'Some concerns detected - monitor your wellbeing'**
  String get riskMediumDesc;

  /// Low risk description
  ///
  /// In en, this message translates to:
  /// **'No significant concerns detected'**
  String get riskLowDesc;

  /// Booking confirmed title
  ///
  /// In en, this message translates to:
  /// **'Booked!'**
  String get booked;

  /// Session confirmed message
  ///
  /// In en, this message translates to:
  /// **'Your session with {therapistName} is confirmed.'**
  String sessionConfirmed(String therapistName);

  /// To be determined
  ///
  /// In en, this message translates to:
  /// **'TBD'**
  String get tbd;

  /// Digital wallet payment indicator
  ///
  /// In en, this message translates to:
  /// **'Paid with Digital Wallet'**
  String get paidWithDigitalWallet;

  /// View appointments button
  ///
  /// In en, this message translates to:
  /// **'View my appointments'**
  String get viewMyAppointments;

  /// Payment failed error message
  ///
  /// In en, this message translates to:
  /// **'Payment failed: {error}'**
  String paymentFailed(String error);

  /// Wallet connection error message
  ///
  /// In en, this message translates to:
  /// **'Failed to connect wallet: {error}'**
  String failedToConnectWallet(String error);

  /// Connect wallet button
  ///
  /// In en, this message translates to:
  /// **'Connect wallet'**
  String get connectWallet;

  /// Disconnect button
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get disconnect;

  /// View on Etherscan button
  ///
  /// In en, this message translates to:
  /// **'View on Etherscan'**
  String get viewOnEtherscan;

  /// Continue button
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// See results button
  ///
  /// In en, this message translates to:
  /// **'See Results'**
  String get seeResults;

  /// Original entry section title
  ///
  /// In en, this message translates to:
  /// **'Original Entry'**
  String get originalEntry;

  /// Blockchain storage section title
  ///
  /// In en, this message translates to:
  /// **'Stored on Blockchain'**
  String get storedOnBlockchain;

  /// Low stress level
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get stressLow;

  /// Medium stress level
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get stressMedium;

  /// High stress level
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get stressHigh;

  /// Unknown stress level
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get stressUnknown;

  /// New trend indicator
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get trendNew;

  /// Stable trend indicator
  ///
  /// In en, this message translates to:
  /// **'Stable'**
  String get trendStable;

  /// Improved trend indicator
  ///
  /// In en, this message translates to:
  /// **'Improved'**
  String get trendImproved;

  /// Worsened trend indicator
  ///
  /// In en, this message translates to:
  /// **'Worsened'**
  String get trendWorsened;

  /// Error message when wrong network is selected
  ///
  /// In en, this message translates to:
  /// **'Please switch to Sepolia testnet in your wallet'**
  String get pleaseSelectSepoliaNetwork;

  /// Button to switch blockchain network
  ///
  /// In en, this message translates to:
  /// **'Switch Network'**
  String get switchNetwork;

  /// Biometric prompt reason
  ///
  /// In en, this message translates to:
  /// **'Unlock Anchor'**
  String get unlockAnchor;

  /// Lock screen title
  ///
  /// In en, this message translates to:
  /// **'Enter your PIN'**
  String get enterYourPin;

  /// Lock screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Enter your PIN to unlock the app'**
  String get enterPinToUnlock;

  /// Error when PIN is wrong
  ///
  /// In en, this message translates to:
  /// **'Incorrect PIN'**
  String get incorrectPin;

  /// Error with remaining attempts
  ///
  /// In en, this message translates to:
  /// **'Incorrect PIN. {attempts} attempts remaining'**
  String incorrectPinAttempts(int attempts);

  /// Lockout message
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Try again in {seconds} seconds'**
  String tooManyAttempts(int seconds);

  /// App lock setup page title
  ///
  /// In en, this message translates to:
  /// **'Set Up App Lock'**
  String get setUpAppLock;

  /// Change PIN page title
  ///
  /// In en, this message translates to:
  /// **'Change PIN'**
  String get changePin;

  /// Disable app lock page title
  ///
  /// In en, this message translates to:
  /// **'Disable App Lock'**
  String get disableAppLock;

  /// Step title for current PIN
  ///
  /// In en, this message translates to:
  /// **'Enter current PIN'**
  String get enterCurrentPin;

  /// Step title for new PIN
  ///
  /// In en, this message translates to:
  /// **'Create new PIN'**
  String get createNewPin;

  /// Step title for confirm PIN
  ///
  /// In en, this message translates to:
  /// **'Confirm your PIN'**
  String get confirmYourPin;

  /// Subtitle for disable lock
  ///
  /// In en, this message translates to:
  /// **'Enter your PIN to disable app lock'**
  String get enterPinToDisableLock;

  /// Subtitle for current PIN step
  ///
  /// In en, this message translates to:
  /// **'Enter your current PIN to continue'**
  String get enterCurrentPinToContinue;

  /// Subtitle for new PIN step
  ///
  /// In en, this message translates to:
  /// **'Choose a 4 digit PIN'**
  String get choosePinDigits;

  /// Subtitle for confirm step
  ///
  /// In en, this message translates to:
  /// **'Re-enter your PIN to confirm'**
  String get reenterPinToConfirm;

  /// Error for too short PIN
  ///
  /// In en, this message translates to:
  /// **'PIN must be at least 4 digits'**
  String get pinMustBeDigits;

  /// Error when PINs don't match
  ///
  /// In en, this message translates to:
  /// **'PINs do not match. Try again'**
  String get pinsDoNotMatch;

  /// Error when PIN setup fails
  ///
  /// In en, this message translates to:
  /// **'Failed to set PIN. Please try again'**
  String get failedToSetPin;

  /// Success message for enabling lock
  ///
  /// In en, this message translates to:
  /// **'App lock enabled'**
  String get appLockEnabled;

  /// Success message for disabling lock
  ///
  /// In en, this message translates to:
  /// **'App lock disabled'**
  String get appLockDisabled;

  /// Success message for changing PIN
  ///
  /// In en, this message translates to:
  /// **'PIN changed successfully'**
  String get pinChanged;

  /// Toggle for biometric auth
  ///
  /// In en, this message translates to:
  /// **'Use {biometricType}'**
  String useBiometrics(String biometricType);

  /// Biometric toggle subtitle
  ///
  /// In en, this message translates to:
  /// **'Unlock with {biometricType} for faster access'**
  String unlockWithBiometrics(String biometricType);

  /// Toggle for lock on background
  ///
  /// In en, this message translates to:
  /// **'Lock when leaving app'**
  String get lockWhenLeaving;

  /// Subtitle for lock on background
  ///
  /// In en, this message translates to:
  /// **'Require PIN when returning to the app'**
  String get lockWhenLeavingSubtitle;

  /// Button to change PIN
  ///
  /// In en, this message translates to:
  /// **'Change PIN code'**
  String get changePinCode;

  /// Button to remove app lock
  ///
  /// In en, this message translates to:
  /// **'Remove app lock'**
  String get removeAppLock;

  /// App lock settings page title
  ///
  /// In en, this message translates to:
  /// **'App Lock Settings'**
  String get appLockSettings;

  /// App lock promo text
  ///
  /// In en, this message translates to:
  /// **'Protect your privacy with a PIN code'**
  String get protectYourPrivacy;

  /// GAD-7 assessment page title
  ///
  /// In en, this message translates to:
  /// **'GAD-7 Assessment'**
  String get gad7Assessment;

  /// PHQ-9 assessment page title
  ///
  /// In en, this message translates to:
  /// **'PHQ-9 Assessment'**
  String get phq9Assessment;

  /// Assessment introduction text
  ///
  /// In en, this message translates to:
  /// **'Over the last two weeks, how often have you been bothered by the following problems?'**
  String get assessmentIntroText;

  /// Assessment answer option
  ///
  /// In en, this message translates to:
  /// **'Not at all'**
  String get answerNotAtAll;

  /// Assessment answer option
  ///
  /// In en, this message translates to:
  /// **'Several days'**
  String get answerSeveralDays;

  /// Assessment answer option
  ///
  /// In en, this message translates to:
  /// **'More than half the days'**
  String get answerMoreThanHalfDays;

  /// Assessment answer option
  ///
  /// In en, this message translates to:
  /// **'Nearly every day'**
  String get answerNearlyEveryDay;

  /// See result button
  ///
  /// In en, this message translates to:
  /// **'See Result'**
  String get seeResult;

  /// GAD-7 question 1
  ///
  /// In en, this message translates to:
  /// **'Feeling nervous, anxious, or on edge'**
  String get gad7Question1;

  /// GAD-7 question 2
  ///
  /// In en, this message translates to:
  /// **'Not being able to stop or control worrying'**
  String get gad7Question2;

  /// GAD-7 question 3
  ///
  /// In en, this message translates to:
  /// **'Worrying too much about different things'**
  String get gad7Question3;

  /// GAD-7 question 4
  ///
  /// In en, this message translates to:
  /// **'Trouble relaxing'**
  String get gad7Question4;

  /// GAD-7 question 5
  ///
  /// In en, this message translates to:
  /// **'Being so restless that it is hard to sit still'**
  String get gad7Question5;

  /// GAD-7 question 6
  ///
  /// In en, this message translates to:
  /// **'Becoming easily annoyed or irritable'**
  String get gad7Question6;

  /// GAD-7 question 7
  ///
  /// In en, this message translates to:
  /// **'Feeling afraid as if something awful might happen'**
  String get gad7Question7;

  /// PHQ-9 question 1
  ///
  /// In en, this message translates to:
  /// **'Little interest or pleasure in doing things'**
  String get phq9Question1;

  /// PHQ-9 question 2
  ///
  /// In en, this message translates to:
  /// **'Feeling down, depressed, or hopeless'**
  String get phq9Question2;

  /// PHQ-9 question 3
  ///
  /// In en, this message translates to:
  /// **'Trouble falling or staying asleep, or sleeping too much'**
  String get phq9Question3;

  /// PHQ-9 question 4
  ///
  /// In en, this message translates to:
  /// **'Feeling tired or having little energy'**
  String get phq9Question4;

  /// PHQ-9 question 5
  ///
  /// In en, this message translates to:
  /// **'Poor appetite or overeating'**
  String get phq9Question5;

  /// PHQ-9 question 6
  ///
  /// In en, this message translates to:
  /// **'Feeling bad about yourself — or that you are a failure or have let yourself or your family down'**
  String get phq9Question6;

  /// PHQ-9 question 7
  ///
  /// In en, this message translates to:
  /// **'Trouble concentrating on things, such as reading the newspaper or watching television'**
  String get phq9Question7;

  /// PHQ-9 question 8
  ///
  /// In en, this message translates to:
  /// **'Moving or speaking so slowly that other people could have noticed? Or the opposite — being so fidgety or restless that you have been moving around a lot more than usual'**
  String get phq9Question8;

  /// PHQ-9 question 9
  ///
  /// In en, this message translates to:
  /// **'Thoughts that you would be better off dead or of hurting yourself in some way'**
  String get phq9Question9;

  /// GAD-7 results page title
  ///
  /// In en, this message translates to:
  /// **'GAD-7 Anxiety Assessment'**
  String get gad7ResultsTitle;

  /// PHQ-9 results page title
  ///
  /// In en, this message translates to:
  /// **'PHQ-9 Depression Assessment'**
  String get phq9ResultsTitle;

  /// GAD-7 minimal anxiety status
  ///
  /// In en, this message translates to:
  /// **'Minimal anxiety'**
  String get minimalAnxiety;

  /// GAD-7 mild anxiety status
  ///
  /// In en, this message translates to:
  /// **'Mild anxiety'**
  String get mildAnxiety;

  /// GAD-7 moderate anxiety status
  ///
  /// In en, this message translates to:
  /// **'Moderate anxiety'**
  String get moderateAnxiety;

  /// GAD-7 severe anxiety status
  ///
  /// In en, this message translates to:
  /// **'Severe anxiety'**
  String get severeAnxiety;

  /// PHQ-9 minimal depression status
  ///
  /// In en, this message translates to:
  /// **'Minimal depression'**
  String get minimalDepression;

  /// PHQ-9 mild depression status
  ///
  /// In en, this message translates to:
  /// **'Mild depression'**
  String get mildDepression;

  /// PHQ-9 moderate depression status
  ///
  /// In en, this message translates to:
  /// **'Moderate depression'**
  String get moderateDepression;

  /// PHQ-9 moderately severe depression status
  ///
  /// In en, this message translates to:
  /// **'Moderately severe'**
  String get moderatelySevereDepression;

  /// PHQ-9 severe depression status
  ///
  /// In en, this message translates to:
  /// **'Severe depression'**
  String get severeDepression;

  /// GAD-7 minimal anxiety description
  ///
  /// In en, this message translates to:
  /// **'Minimal anxiety. Keep up the good work!'**
  String get gad7DescMinimal;

  /// GAD-7 mild anxiety description
  ///
  /// In en, this message translates to:
  /// **'Mild anxiety. Consider incorporating relaxation techniques.'**
  String get gad7DescMild;

  /// GAD-7 moderate anxiety description
  ///
  /// In en, this message translates to:
  /// **'Moderate anxiety. Pay attention to your mental health.'**
  String get gad7DescModerate;

  /// GAD-7 severe anxiety description
  ///
  /// In en, this message translates to:
  /// **'Severe anxiety. Seeking professional help is recommended.'**
  String get gad7DescSevere;

  /// PHQ-9 minimal depression description
  ///
  /// In en, this message translates to:
  /// **'Symptoms suggest minimal depression. Continue monitoring your mood.'**
  String get phq9DescMinimal;

  /// PHQ-9 mild depression description
  ///
  /// In en, this message translates to:
  /// **'Symptoms suggest mild depression. It may be helpful to talk with a counselor.'**
  String get phq9DescMild;

  /// PHQ-9 moderate depression description
  ///
  /// In en, this message translates to:
  /// **'Symptoms suggest moderate depression. Consider a consultation with a healthcare professional.'**
  String get phq9DescModerate;

  /// PHQ-9 moderately severe depression description
  ///
  /// In en, this message translates to:
  /// **'Symptoms suggest moderately severe depression. Please reach out to a professional for support.'**
  String get phq9DescModeratelySevere;

  /// PHQ-9 severe depression description
  ///
  /// In en, this message translates to:
  /// **'Symptoms suggest severe depression. We strongly recommend seeking immediate professional help.'**
  String get phq9DescSevere;

  /// Next steps section title
  ///
  /// In en, this message translates to:
  /// **'Next Steps'**
  String get nextSteps;

  /// Recommendation
  ///
  /// In en, this message translates to:
  /// **'Practice mindfulness and meditation'**
  String get recPracticeMindfulness;

  /// Recommendation
  ///
  /// In en, this message translates to:
  /// **'Engage in regular physical activity'**
  String get recPhysicalActivity;

  /// Recommendation
  ///
  /// In en, this message translates to:
  /// **'Maintain a healthy sleep schedule'**
  String get recHealthySleep;

  /// Recommendation
  ///
  /// In en, this message translates to:
  /// **'Talk to trusted friends or family members'**
  String get recTalkToFriends;

  /// Recommendation
  ///
  /// In en, this message translates to:
  /// **'Maintain a routine for sleep and meals'**
  String get recMaintainRoutine;

  /// Recommendation
  ///
  /// In en, this message translates to:
  /// **'Set small, achievable daily goals'**
  String get recSetGoals;

  /// Recommendation
  ///
  /// In en, this message translates to:
  /// **'Stay connected with your support network'**
  String get recStayConnected;

  /// Urgent recommendation for crisis
  ///
  /// In en, this message translates to:
  /// **'Contact a mental health crisis hotline'**
  String get recContactCrisisHotline;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fr',
    'hi',
    'it',
    'pt',
    'th',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'it':
      return AppLocalizationsIt();
    case 'pt':
      return AppLocalizationsPt();
    case 'th':
      return AppLocalizationsTh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
