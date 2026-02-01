// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Anchor';

  @override
  String get chat => 'Chat';

  @override
  String get journal => 'Journal';

  @override
  String get home => 'Home';

  @override
  String get settings => 'Settings';

  @override
  String get help => 'Help';

  @override
  String get friend => 'Friend';

  @override
  String get therapist => 'Therapist';

  @override
  String get chatWithFriend => 'Chat with a friend';

  @override
  String get guidedConversation => 'Guided conversation';

  @override
  String get friendEmptyStateDescription =>
      'I\'m here to listen. Share anything on your mind.';

  @override
  String get therapistEmptyStateDescription =>
      'Explore your thoughts with guided therapeutic dialogue.';

  @override
  String get typeMessage => 'Type a message...';

  @override
  String get thinking => 'Thinking...';

  @override
  String get loadingModel => 'Loading model...';

  @override
  String get downloadModel => 'Download Model';

  @override
  String get downloadAiModel => 'Download AI Model';

  @override
  String get advancedAi => 'Advanced AI';

  @override
  String get compactAi => 'Compact AI';

  @override
  String get onDeviceAiChat => 'On-Device AI Chat';

  @override
  String get selectModel => 'Select Model';

  @override
  String get recommended => 'Recommended';

  @override
  String get current => 'Current';

  @override
  String get currentlyInUse => 'Currently in use';

  @override
  String get moreCapableBetterResponses => 'More capable • Better responses';

  @override
  String get lightweightFastResponses => 'Lightweight • Fast responses';

  @override
  String downloadSize(String size) {
    return '~$size download';
  }

  @override
  String get modelReady => 'Model Ready';

  @override
  String get startChatting => 'Start Chatting';

  @override
  String get switchToDifferentModel => 'Switch to Different Model';

  @override
  String get appearance => 'Appearance';

  @override
  String get language => 'Language';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get aiProvider => 'AI Provider';

  @override
  String get security => 'Security';

  @override
  String get notifications => 'Notifications';

  @override
  String get data => 'Data';

  @override
  String get appLock => 'App lock';

  @override
  String get pushNotifications => 'Push notifications';

  @override
  String get clearHistory => 'Clear history';

  @override
  String get exportData => 'Export data';

  @override
  String get skip => 'Skip';

  @override
  String get next => 'Next';

  @override
  String get getStarted => 'Get Started';

  @override
  String get continueText => 'Continue';

  @override
  String get journalYourThoughts => 'Journal your thoughts';

  @override
  String get journalDescription =>
      'Express yourself freely and track your emotional journey over time.';

  @override
  String get talkToAiCompanion => 'Talk to AI companion';

  @override
  String get talkToAiDescription =>
      'Chat anytime with a supportive AI friend or therapist.';

  @override
  String get trackYourProgress => 'Track your progress';

  @override
  String get trackProgressDescription =>
      'Understand your mental patterns with insights and evaluations.';

  @override
  String get chooseYourLanguage => 'Choose your language';

  @override
  String get languageDescription =>
      'Select your preferred language for the app. You can change this later in settings.';

  @override
  String get english => 'English';

  @override
  String get thai => 'ไทย';

  @override
  String get german => 'Deutsch';

  @override
  String get french => 'Français';

  @override
  String get italian => 'Italiano';

  @override
  String get portuguese => 'Português';

  @override
  String get hindi => 'हिन्दी';

  @override
  String get spanish => 'Español';

  @override
  String get onDevice => 'On-device';

  @override
  String get cloud => 'Cloud';

  @override
  String get privateOnDevice => '100% on-device';

  @override
  String get usingCloudAi => 'Using Cloud AI';

  @override
  String get offlineMode => 'Offline mode';

  @override
  String get aiReady => 'AI Ready';

  @override
  String get nativeAi => 'Native AI';

  @override
  String get demoMode => 'Demo mode';

  @override
  String get checkingModel => 'Checking model...';

  @override
  String get loadingAiModel => 'Loading AI model...';

  @override
  String get preparingModelForChat => 'Preparing the model for chat';

  @override
  String getModelForPrivateChat(String modelName) {
    return 'Get the $modelName model for private, on-device AI chat';
  }

  @override
  String get loadModel => 'Load Model';

  @override
  String get aiModelReady => 'AI model ready';

  @override
  String get loadModelToStartChatting => 'Load the model to start chatting';

  @override
  String get deviceHasEnoughRam => 'Your device has enough RAM for both models';

  @override
  String wifiRecommended(String size) {
    return 'Requires Wi-Fi recommended. Download size: ~$size';
  }

  @override
  String get checkingModelStatus => 'Checking model status...';

  @override
  String get downloadFailed => 'Download Failed';

  @override
  String get retryDownload => 'Retry Download';

  @override
  String get keepAppOpen => 'Please keep the app open during download';

  @override
  String get keepAppOpenDuringDownload =>
      'Please keep the app open during download';

  @override
  String get switchText => 'Switch';

  @override
  String get change => 'Change';

  @override
  String get downloading => 'Downloading...';

  @override
  String get changeModel => 'Change model';

  @override
  String get errorOccurred =>
      'I\'m sorry, I encountered an issue. Please try again.';

  @override
  String get size => 'Size';

  @override
  String get privacy => 'Privacy';

  @override
  String get downloadModelDescription =>
      'Download the AI model to enable private, on-device conversations.';

  @override
  String get choosePreferredAiModel =>
      'Choose your preferred AI model for private, on-device conversations.';

  @override
  String requiresWifiDownloadSize(String size) {
    return 'Requires Wi-Fi recommended. Download size: ~$size';
  }

  @override
  String get chooseModelDescription =>
      'Choose your preferred AI model for private, on-device conversations.';

  @override
  String get aboutYou => 'About you';

  @override
  String get helpPersonalizeExperience => 'Help us personalize your experience';

  @override
  String get whatShouldWeCallYou => 'What should we call you?';

  @override
  String get enterNameOrNickname => 'Enter your name or nickname';

  @override
  String get birthYear => 'Birth year';

  @override
  String get selectYear => 'Select year';

  @override
  String get selectBirthYear => 'Select birth year';

  @override
  String get gender => 'Gender';

  @override
  String get male => 'Male';

  @override
  String get female => 'Female';

  @override
  String get nonBinary => 'Non-binary';

  @override
  String get preferNotToSay => 'Prefer not to say';

  @override
  String get whatBringsYouHere => 'What brings you here?';

  @override
  String get manageStress => 'Manage stress';

  @override
  String get trackMood => 'Track mood';

  @override
  String get buildHabits => 'Build habits';

  @override
  String get selfReflection => 'Self-reflection';

  @override
  String get justExploring => 'Just exploring';

  @override
  String get howOftenJournal => 'How often would you like to journal?';

  @override
  String get daily => 'Daily';

  @override
  String get fewTimesWeek => 'Few times a week';

  @override
  String get weekly => 'Weekly';

  @override
  String get whenIFeelLikeIt => 'When I feel like it';

  @override
  String get bestTimeForCheckIns => 'What time works best for check-ins?';

  @override
  String get morning => 'Morning';

  @override
  String get afternoon => 'Afternoon';

  @override
  String get evening => 'Evening';

  @override
  String get flexible => 'Flexible';

  @override
  String questionOf(int current, int total) {
    return '$current of $total';
  }

  @override
  String get chooseYourAi => 'Choose your AI';

  @override
  String get selectHowToPowerAi =>
      'Select how you want to power your AI assistant';

  @override
  String get onDeviceAi => 'On-Device AI';

  @override
  String get maximumPrivacy => 'Maximum privacy';

  @override
  String get onDeviceDescription =>
      'Runs entirely on your device. Your data never leaves your phone.';

  @override
  String get completePrivacy => 'Complete privacy';

  @override
  String get worksOffline => 'Works offline';

  @override
  String get noSubscriptionNeeded => 'No subscription needed';

  @override
  String get requires2GBDownload => 'Requires ~2GB download';

  @override
  String get usesDeviceResources => 'Uses device resources';

  @override
  String get cloudAi => 'Cloud AI';

  @override
  String get morePowerful => 'More powerful';

  @override
  String get cloudDescription =>
      'Powered by cloud providers for faster, smarter responses.';

  @override
  String get moreCapableModels => 'More capable models';

  @override
  String get fasterResponses => 'Faster responses';

  @override
  String get noStorageNeeded => 'No storage needed';

  @override
  String get requiresInternet => 'Requires internet';

  @override
  String get dataSentToCloud => 'Data sent to cloud';

  @override
  String downloadingModel(int progress) {
    return 'Downloading model... $progress%';
  }

  @override
  String settingUp(int progress) {
    return 'Setting up... $progress%';
  }

  @override
  String get setupFailed => 'Setup failed. Please try again.';

  @override
  String get insights => 'Insights';

  @override
  String get goodMorning => 'Good morning';

  @override
  String goodMorningName(String name) {
    return 'Good morning, $name';
  }

  @override
  String get goodAfternoon => 'Good afternoon';

  @override
  String goodAfternoonName(String name) {
    return 'Good afternoon, $name';
  }

  @override
  String get goodEvening => 'Good evening';

  @override
  String goodEveningName(String name) {
    return 'Good evening, $name';
  }

  @override
  String get howAreYouToday => 'How are you today?';

  @override
  String get moodGreat => 'Great';

  @override
  String get moodGood => 'Good';

  @override
  String get moodOkay => 'Okay';

  @override
  String get moodLow => 'Low';

  @override
  String get moodSad => 'Sad';

  @override
  String get thisWeek => 'This Week';

  @override
  String get upcomingAppointments => 'Upcoming Appointments';

  @override
  String get avgMood => 'Avg. Mood';

  @override
  String get journalEntries => 'Journal Entries';

  @override
  String get chatSessions => 'Chat Sessions';

  @override
  String get stressLevel => 'Stress Level';

  @override
  String get startYourStreak => 'Start your streak!';

  @override
  String get writeJournalToBegin => 'Write a journal entry to begin';

  @override
  String dayStreak(int count) {
    return '$count day streak!';
  }

  @override
  String get amazingConsistency => 'Amazing consistency! Keep it up!';

  @override
  String get keepMomentumGoing => 'Keep the momentum going';

  @override
  String get today => 'Today';

  @override
  String get tomorrow => 'Tomorrow';

  @override
  String get newEntry => 'New';

  @override
  String get noJournalEntriesYet => 'No journal entries yet';

  @override
  String get tapToCreateFirstEntry =>
      'Tap the + button to create your first entry';

  @override
  String get draft => 'Draft';

  @override
  String get finalized => 'Finalized';

  @override
  String get getHelp => 'Get help';

  @override
  String get connectWithProfessionals => 'Connect with licensed professionals';

  @override
  String get yourAppointments => 'Your Appointments';

  @override
  String get inCrisis => 'In crisis?';

  @override
  String get callEmergencyServices => 'Call emergency services immediately';

  @override
  String get call => 'Call';

  @override
  String get services => 'Services';

  @override
  String get resources => 'Resources';

  @override
  String get therapistSession => 'Therapist session';

  @override
  String get oneOnOneWithTherapist => 'One-on-one with a licensed therapist';

  @override
  String get mentalHealthConsultation => 'Mental health consultation';

  @override
  String get generalWellnessGuidance => 'General wellness guidance';

  @override
  String get articles => 'Articles';

  @override
  String get guidedMeditations => 'Guided meditations';

  @override
  String get crisisHotlines => 'Crisis hotlines';

  @override
  String get join => 'Join';

  @override
  String get trackMentalWellness => 'Track and understand your mental wellness';

  @override
  String get takeAssessment => 'Take an assessment';

  @override
  String get emotionalCheckIn => 'Emotional check-in';

  @override
  String get understandEmotionalState =>
      'Understand your current emotional state';

  @override
  String get stressAssessment => 'Stress assessment';

  @override
  String get measureStressLevels => 'Measure your stress levels';

  @override
  String get recentResults => 'Recent results';

  @override
  String get checkIn => 'check-in';

  @override
  String get cancel => 'Cancel';

  @override
  String nOfTotal(int current, int total) {
    return '$current of $total';
  }

  @override
  String get emotionalWellbeing => 'Emotional well-being';

  @override
  String get stressManagement => 'Stress management';

  @override
  String get suggestions => 'Suggestions';

  @override
  String get done => 'Done';

  @override
  String get talkToProfessional => 'Talk to a professional';

  @override
  String get aiModel => 'AI Model';

  @override
  String get pleaseWriteSomethingFirst => 'Please write something first';

  @override
  String get useCloudAi => 'Use Cloud AI?';

  @override
  String get aboutToSwitchToCloud =>
      'You are about to switch to a cloud AI provider (Gemini).';

  @override
  String get cloudPrivacyWarning =>
      'Your conversations will be sent to Google servers. We cannot guarantee data privacy when using cloud AI.';

  @override
  String get forMaxPrivacy =>
      'For maximum privacy, use the on-device AI option.';

  @override
  String get iUnderstand => 'I Understand';

  @override
  String get switchedToCloudAi => 'Switched to Cloud AI (Gemini)';

  @override
  String get switchedToOnDeviceAi => 'Switched to On-Device AI';

  @override
  String languageChangedTo(String language) {
    return 'Language changed to $language';
  }

  @override
  String get clearHistoryQuestion => 'Clear history?';

  @override
  String get clearHistoryWarning =>
      'This will delete all your data. This cannot be undone.';

  @override
  String get clear => 'Clear';

  @override
  String get historyCleared => 'History cleared';

  @override
  String get aboutAnchor => 'About Anchor';

  @override
  String get privacyPolicy => 'Privacy policy';

  @override
  String get helpAndSupport => 'Help & support';

  @override
  String version(String version) {
    return 'Version $version';
  }

  @override
  String get yourWellnessCompanion => 'Your mental wellness companion.';

  @override
  String get system => 'System';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get onDeviceProvider => 'On-Device';

  @override
  String get privateRunsLocally => 'Private, runs locally';

  @override
  String get cloudGemini => 'Cloud (Gemini)';

  @override
  String get fasterRequiresInternet => 'Faster, requires internet';

  @override
  String get apiKeyNotConfigured => 'API key not configured';

  @override
  String get about => 'About';

  @override
  String get findTherapist => 'Find a therapist';

  @override
  String get searchByNameOrSpecialty => 'Search by name or specialty...';

  @override
  String therapistsAvailable(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count therapists available',
      one: '$count therapist available',
    );
    return '$_temp0';
  }

  @override
  String get switchLabel => 'Switch';

  @override
  String changeModelTooltip(String modelName) {
    return 'Change model ($modelName)';
  }

  @override
  String get offline => 'Offline';

  @override
  String get modelError => 'Model error';

  @override
  String get cloudAiLabel => 'Cloud AI';

  @override
  String get usingCloudAiLabel => 'Using Cloud AI';

  @override
  String get from => 'From';

  @override
  String get perSession => '/session';

  @override
  String get unavailable => 'Unavailable';

  @override
  String get bookSession => 'Book session';

  @override
  String get viewProfile => 'View profile';

  @override
  String get pleaseSelectTime => 'Please select a time';

  @override
  String get date => 'Date';

  @override
  String get time => 'Time';

  @override
  String get urgency => 'Urgency';

  @override
  String get normal => 'Normal';

  @override
  String get regularScheduling => 'Regular scheduling';

  @override
  String get urgent => 'Urgent';

  @override
  String get priority => 'Priority (+\$20)';

  @override
  String get checkout => 'Checkout';

  @override
  String get summary => 'Summary';

  @override
  String get type => 'Type';

  @override
  String get price => 'Price';

  @override
  String get session => 'Session';

  @override
  String get urgencyFee => 'Urgency fee';

  @override
  String get total => 'Total';

  @override
  String get testModeMessage =>
      'Test mode: Using \$1 amount on Sepolia testnet';

  @override
  String get freeCancellation => 'Free cancellation up to 24 hours before';

  @override
  String payAmount(int amount) {
    return 'Pay \$$amount';
  }

  @override
  String get payment => 'Payment';

  @override
  String get paymentMethod => 'Payment method';

  @override
  String get creditDebitCard => 'Credit / Debit Card';

  @override
  String get visaMastercardAmex => 'Visa, Mastercard, Amex';

  @override
  String get payWithPaypal => 'Pay with your PayPal account';

  @override
  String get cardNumber => 'Card number';

  @override
  String get walletConnected => 'Wallet connected';

  @override
  String get securedByBlockchain => 'Secured by blockchain';

  @override
  String get securePayment => 'Secure payment';

  @override
  String get connectWalletToPay => 'Connect wallet to pay';

  @override
  String reviewsCount(int count) {
    return '$count reviews';
  }

  @override
  String get perSessionLabel => 'per session';

  @override
  String get minutes => 'minutes';

  @override
  String get available => 'Available';

  @override
  String get currentlyUnavailable => 'Currently unavailable';

  @override
  String nextSlot(String time) {
    return 'Next slot: $time';
  }

  @override
  String get specializations => 'Specializations';

  @override
  String get languages => 'Languages';

  @override
  String get reviews => 'Reviews';

  @override
  String get seeAll => 'See all';

  @override
  String bookSessionWithPrice(int price) {
    return 'Book session - \$$price';
  }

  @override
  String get unsavedChanges => 'Unsaved changes';

  @override
  String get whatsOnYourMind => 'What\'s on your mind?';

  @override
  String get analyzingEntry => 'Analyzing your entry...';

  @override
  String get finalizing => 'Finalizing...';

  @override
  String get thisMayTakeAMoment => 'This may take a moment';

  @override
  String get aiGeneratingInsights => 'AI is generating insights';

  @override
  String get pleaseWriteSomething => 'Please write something first';

  @override
  String failedToSave(String error) {
    return 'Failed to save: $error';
  }

  @override
  String failedToFinalize(String error) {
    return 'Failed to finalize: $error';
  }

  @override
  String get whatWouldYouLikeToDo => 'What would you like to do?';

  @override
  String get saveAsDraft => 'Save as Draft';

  @override
  String get keepEditingForDays => 'Keep editing for up to 3 days';

  @override
  String get finalizeWithAi => 'Finalize with AI';

  @override
  String get finalizeWithCloudAi => 'Finalize with Cloud AI';

  @override
  String get finalizeEntry => 'Finalize Entry';

  @override
  String get getSummaryAndAnalysisGemini =>
      'Get summary & analysis (uses Gemini)';

  @override
  String get getSummaryEmotionRisk =>
      'Get summary, emotion analysis & risk assessment';

  @override
  String get lockEntryAndStopEditing => 'Lock entry and stop editing';

  @override
  String get entryFinalized => 'Entry Finalized';

  @override
  String get entrySaved => 'Entry Saved';

  @override
  String get entryAnalyzed => 'Your journal entry has been analyzed';

  @override
  String get draftSaved => 'Your draft has been saved';

  @override
  String get riskAssessment => 'Risk Assessment';

  @override
  String get emotionalState => 'Emotional State';

  @override
  String get aiSummary => 'AI Summary';

  @override
  String get suggestedActions => 'Suggested Actions';

  @override
  String get draftMode => 'Draft Mode';

  @override
  String get draftModeDescription =>
      'You can continue editing this entry for up to 3 days. When ready, finalize it to get AI-powered insights.';

  @override
  String get storedOnEthStorage => 'Stored on EthStorage';

  @override
  String get ethStorageConfigRequired => 'EthStorage Configuration Required';

  @override
  String get retry => 'Retry';

  @override
  String get view => 'View';

  @override
  String get uploadingToEthStorage => 'Uploading to EthStorage...';

  @override
  String get storeOnEthStorage => 'Store on EthStorage (Testnet)';

  @override
  String get successfullyUploaded => 'Successfully uploaded to EthStorage!';

  @override
  String couldNotOpenBrowser(String url) {
    return 'Could not open browser. URL: $url';
  }

  @override
  String errorOpeningUrl(String error) {
    return 'Error opening URL: $error';
  }

  @override
  String get riskHighDesc =>
      'Consider reaching out to a mental health professional';

  @override
  String get riskMediumDesc =>
      'Some concerns detected - monitor your wellbeing';

  @override
  String get riskLowDesc => 'No significant concerns detected';

  @override
  String get booked => 'Booked!';

  @override
  String sessionConfirmed(String therapistName) {
    return 'Your session with $therapistName is confirmed.';
  }

  @override
  String get tbd => 'TBD';

  @override
  String get paidWithDigitalWallet => 'Paid with Digital Wallet';

  @override
  String get viewMyAppointments => 'View my appointments';

  @override
  String paymentFailed(String error) {
    return 'Payment failed: $error';
  }

  @override
  String failedToConnectWallet(String error) {
    return 'Failed to connect wallet: $error';
  }

  @override
  String get connectWallet => 'Connect wallet';

  @override
  String get disconnect => 'Disconnect';

  @override
  String get viewOnEtherscan => 'View on Etherscan';

  @override
  String get continueButton => 'Continue';

  @override
  String get seeResults => 'See Results';

  @override
  String get originalEntry => 'Original Entry';

  @override
  String get storedOnBlockchain => 'Stored on Blockchain';

  @override
  String get stressLow => 'Low';

  @override
  String get stressMedium => 'Medium';

  @override
  String get stressHigh => 'High';

  @override
  String get stressUnknown => 'Unknown';

  @override
  String get trendNew => 'New';

  @override
  String get trendStable => 'Stable';

  @override
  String get trendImproved => 'Improved';

  @override
  String get trendWorsened => 'Worsened';

  @override
  String get pleaseSelectSepoliaNetwork =>
      'Please switch to Sepolia testnet in your wallet';

  @override
  String get switchNetwork => 'Switch Network';

  @override
  String get unlockAnchor => 'Unlock Anchor';

  @override
  String get enterYourPin => 'Enter your PIN';

  @override
  String get enterPinToUnlock => 'Enter your PIN to unlock the app';

  @override
  String get incorrectPin => 'Incorrect PIN';

  @override
  String incorrectPinAttempts(int attempts) {
    return 'Incorrect PIN. $attempts attempts remaining';
  }

  @override
  String tooManyAttempts(int seconds) {
    return 'Too many attempts. Try again in $seconds seconds';
  }

  @override
  String get setUpAppLock => 'Set Up App Lock';

  @override
  String get changePin => 'Change PIN';

  @override
  String get disableAppLock => 'Disable App Lock';

  @override
  String get enterCurrentPin => 'Enter current PIN';

  @override
  String get createNewPin => 'Create new PIN';

  @override
  String get confirmYourPin => 'Confirm your PIN';

  @override
  String get enterPinToDisableLock => 'Enter your PIN to disable app lock';

  @override
  String get enterCurrentPinToContinue => 'Enter your current PIN to continue';

  @override
  String get choosePinDigits => 'Choose a 4 digit PIN';

  @override
  String get reenterPinToConfirm => 'Re-enter your PIN to confirm';

  @override
  String get pinMustBeDigits => 'PIN must be at least 4 digits';

  @override
  String get pinsDoNotMatch => 'PINs do not match. Try again';

  @override
  String get failedToSetPin => 'Failed to set PIN. Please try again';

  @override
  String get appLockEnabled => 'App lock enabled';

  @override
  String get appLockDisabled => 'App lock disabled';

  @override
  String get pinChanged => 'PIN changed successfully';

  @override
  String useBiometrics(String biometricType) {
    return 'Use $biometricType';
  }

  @override
  String unlockWithBiometrics(String biometricType) {
    return 'Unlock with $biometricType for faster access';
  }

  @override
  String get lockWhenLeaving => 'Lock when leaving app';

  @override
  String get lockWhenLeavingSubtitle => 'Require PIN when returning to the app';

  @override
  String get changePinCode => 'Change PIN code';

  @override
  String get removeAppLock => 'Remove app lock';

  @override
  String get appLockSettings => 'App Lock Settings';

  @override
  String get protectYourPrivacy => 'Protect your privacy with a PIN code';

  @override
  String get gad7Assessment => 'GAD-7 Assessment';

  @override
  String get phq9Assessment => 'PHQ-9 Assessment';

  @override
  String get assessmentIntroText =>
      'Over the last two weeks, how often have you been bothered by the following problems?';

  @override
  String get answerNotAtAll => 'Not at all';

  @override
  String get answerSeveralDays => 'Several days';

  @override
  String get answerMoreThanHalfDays => 'More than half the days';

  @override
  String get answerNearlyEveryDay => 'Nearly every day';

  @override
  String get seeResult => 'See Result';

  @override
  String get gad7Question1 => 'Feeling nervous, anxious, or on edge';

  @override
  String get gad7Question2 => 'Not being able to stop or control worrying';

  @override
  String get gad7Question3 => 'Worrying too much about different things';

  @override
  String get gad7Question4 => 'Trouble relaxing';

  @override
  String get gad7Question5 => 'Being so restless that it is hard to sit still';

  @override
  String get gad7Question6 => 'Becoming easily annoyed or irritable';

  @override
  String get gad7Question7 =>
      'Feeling afraid as if something awful might happen';

  @override
  String get phq9Question1 => 'Little interest or pleasure in doing things';

  @override
  String get phq9Question2 => 'Feeling down, depressed, or hopeless';

  @override
  String get phq9Question3 =>
      'Trouble falling or staying asleep, or sleeping too much';

  @override
  String get phq9Question4 => 'Feeling tired or having little energy';

  @override
  String get phq9Question5 => 'Poor appetite or overeating';

  @override
  String get phq9Question6 =>
      'Feeling bad about yourself — or that you are a failure or have let yourself or your family down';

  @override
  String get phq9Question7 =>
      'Trouble concentrating on things, such as reading the newspaper or watching television';

  @override
  String get phq9Question8 =>
      'Moving or speaking so slowly that other people could have noticed? Or the opposite — being so fidgety or restless that you have been moving around a lot more than usual';

  @override
  String get phq9Question9 =>
      'Thoughts that you would be better off dead or of hurting yourself in some way';

  @override
  String get gad7ResultsTitle => 'GAD-7 Anxiety Assessment';

  @override
  String get phq9ResultsTitle => 'PHQ-9 Depression Assessment';

  @override
  String get minimalAnxiety => 'Minimal anxiety';

  @override
  String get mildAnxiety => 'Mild anxiety';

  @override
  String get moderateAnxiety => 'Moderate anxiety';

  @override
  String get severeAnxiety => 'Severe anxiety';

  @override
  String get minimalDepression => 'Minimal depression';

  @override
  String get mildDepression => 'Mild depression';

  @override
  String get moderateDepression => 'Moderate depression';

  @override
  String get moderatelySevereDepression => 'Moderately severe';

  @override
  String get severeDepression => 'Severe depression';

  @override
  String get gad7DescMinimal => 'Minimal anxiety. Keep up the good work!';

  @override
  String get gad7DescMild =>
      'Mild anxiety. Consider incorporating relaxation techniques.';

  @override
  String get gad7DescModerate =>
      'Moderate anxiety. Pay attention to your mental health.';

  @override
  String get gad7DescSevere =>
      'Severe anxiety. Seeking professional help is recommended.';

  @override
  String get phq9DescMinimal =>
      'Symptoms suggest minimal depression. Continue monitoring your mood.';

  @override
  String get phq9DescMild =>
      'Symptoms suggest mild depression. It may be helpful to talk with a counselor.';

  @override
  String get phq9DescModerate =>
      'Symptoms suggest moderate depression. Consider a consultation with a healthcare professional.';

  @override
  String get phq9DescModeratelySevere =>
      'Symptoms suggest moderately severe depression. Please reach out to a professional for support.';

  @override
  String get phq9DescSevere =>
      'Symptoms suggest severe depression. We strongly recommend seeking immediate professional help.';

  @override
  String get nextSteps => 'Next Steps';

  @override
  String get recPracticeMindfulness => 'Practice mindfulness and meditation';

  @override
  String get recPhysicalActivity => 'Engage in regular physical activity';

  @override
  String get recHealthySleep => 'Maintain a healthy sleep schedule';

  @override
  String get recTalkToFriends => 'Talk to trusted friends or family members';

  @override
  String get recMaintainRoutine => 'Maintain a routine for sleep and meals';

  @override
  String get recSetGoals => 'Set small, achievable daily goals';

  @override
  String get recStayConnected => 'Stay connected with your support network';

  @override
  String get recContactCrisisHotline =>
      'Contact a mental health crisis hotline';
}
