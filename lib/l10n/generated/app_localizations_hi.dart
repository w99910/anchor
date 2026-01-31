// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appName => 'Anchor';

  @override
  String get chat => 'चैट';

  @override
  String get journal => 'डायरी';

  @override
  String get home => 'होम';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get help => 'मदद';

  @override
  String get friend => 'दोस्त';

  @override
  String get therapist => 'थेरेपिस्ट';

  @override
  String get chatWithFriend => 'दोस्त से बात करें';

  @override
  String get guidedConversation => 'मार्गदर्शित बातचीत';

  @override
  String get friendEmptyStateDescription =>
      'मैं सुनने के लिए यहाँ हूँ। जो भी आपके मन में हो, साझा करें।';

  @override
  String get therapistEmptyStateDescription =>
      'मार्गदर्शित चिकित्सीय संवाद के साथ अपने विचारों का अन्वेषण करें।';

  @override
  String get typeMessage => 'संदेश लिखें...';

  @override
  String get thinking => 'सोच रहा हूँ...';

  @override
  String get loadingModel => 'मॉडल लोड हो रहा है...';

  @override
  String get downloadModel => 'मॉडल डाउनलोड करें';

  @override
  String get downloadAiModel => 'AI मॉडल डाउनलोड करें';

  @override
  String get advancedAi => 'उन्नत AI';

  @override
  String get compactAi => 'कॉम्पैक्ट AI';

  @override
  String get onDeviceAiChat => 'डिवाइस पर AI चैट';

  @override
  String get selectModel => 'मॉडल चुनें';

  @override
  String get recommended => 'अनुशंसित';

  @override
  String get current => 'वर्तमान';

  @override
  String get currentlyInUse => 'वर्तमान में उपयोग में';

  @override
  String get moreCapableBetterResponses => 'अधिक सक्षम • बेहतर प्रतिक्रियाएं';

  @override
  String get lightweightFastResponses => 'हल्का • तेज़ प्रतिक्रियाएं';

  @override
  String downloadSize(String size) {
    return '~$size डाउनलोड';
  }

  @override
  String get modelReady => 'मॉडल तैयार';

  @override
  String get startChatting => 'चैट शुरू करें';

  @override
  String get switchToDifferentModel => 'दूसरे मॉडल पर स्विच करें';

  @override
  String get appearance => 'दिखावट';

  @override
  String get language => 'भाषा';

  @override
  String get selectLanguage => 'भाषा चुनें';

  @override
  String get aiProvider => 'AI प्रदाता';

  @override
  String get security => 'सुरक्षा';

  @override
  String get notifications => 'सूचनाएं';

  @override
  String get data => 'डेटा';

  @override
  String get appLock => 'ऐप लॉक';

  @override
  String get pushNotifications => 'पुश सूचनाएं';

  @override
  String get clearHistory => 'इतिहास साफ़ करें';

  @override
  String get exportData => 'डेटा निर्यात करें';

  @override
  String get skip => 'छोड़ें';

  @override
  String get next => 'अगला';

  @override
  String get getStarted => 'शुरू करें';

  @override
  String get continueText => 'जारी रखें';

  @override
  String get journalYourThoughts => 'अपने विचार लिखें';

  @override
  String get journalDescription =>
      'स्वतंत्र रूप से अभिव्यक्त करें और अपनी भावनात्मक यात्रा को ट्रैक करें।';

  @override
  String get talkToAiCompanion => 'AI साथी से बात करें';

  @override
  String get talkToAiDescription =>
      'किसी भी समय एक सहायक AI मित्र या थेरेपिस्ट से चैट करें।';

  @override
  String get trackYourProgress => 'अपनी प्रगति ट्रैक करें';

  @override
  String get trackProgressDescription =>
      'अंतर्दृष्टि और मूल्यांकन के साथ अपने मानसिक पैटर्न को समझें।';

  @override
  String get chooseYourLanguage => 'अपनी भाषा चुनें';

  @override
  String get languageDescription =>
      'ऐप के लिए अपनी पसंदीदा भाषा चुनें। आप इसे बाद में सेटिंग्स में बदल सकते हैं।';

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
  String get onDevice => 'डिवाइस पर';

  @override
  String get cloud => 'क्लाउड';

  @override
  String get privateOnDevice => '100% डिवाइस पर';

  @override
  String get usingCloudAi => 'क्लाउड AI का उपयोग';

  @override
  String get offlineMode => 'ऑफ़लाइन मोड';

  @override
  String get aiReady => 'AI तैयार';

  @override
  String get nativeAi => 'नेटिव AI';

  @override
  String get demoMode => 'डेमो मोड';

  @override
  String get checkingModel => 'मॉडल जाँच रहा है...';

  @override
  String get loadingAiModel => 'AI मॉडल लोड हो रहा है...';

  @override
  String get preparingModelForChat => 'चैट के लिए मॉडल तैयार हो रहा है';

  @override
  String getModelForPrivateChat(String modelName) {
    return 'निजी, डिवाइस पर AI चैट के लिए $modelName मॉडल प्राप्त करें';
  }

  @override
  String get loadModel => 'मॉडल लोड करें';

  @override
  String get aiModelReady => 'AI मॉडल तैयार';

  @override
  String get loadModelToStartChatting => 'चैट शुरू करने के लिए मॉडल लोड करें';

  @override
  String get deviceHasEnoughRam =>
      'आपके डिवाइस में दोनों मॉडल के लिए पर्याप्त RAM है';

  @override
  String wifiRecommended(String size) {
    return 'Wi-Fi अनुशंसित। डाउनलोड आकार: ~$size';
  }

  @override
  String get checkingModelStatus => 'मॉडल स्थिति जाँच रहा है...';

  @override
  String get downloadFailed => 'डाउनलोड विफल';

  @override
  String get retryDownload => 'पुनः प्रयास करें';

  @override
  String get keepAppOpen => 'कृपया डाउनलोड के दौरान ऐप खुला रखें';

  @override
  String get keepAppOpenDuringDownload => 'कृपया डाउनलोड के दौरान ऐप खुला रखें';

  @override
  String get switchText => 'स्विच करें';

  @override
  String get change => 'बदलें';

  @override
  String get downloading => 'डाउनलोड हो रहा है...';

  @override
  String get changeModel => 'मॉडल बदलें';

  @override
  String get errorOccurred =>
      'क्षमा करें, एक समस्या आई। कृपया पुनः प्रयास करें।';

  @override
  String get size => 'आकार';

  @override
  String get privacy => 'गोपनीयता';

  @override
  String get downloadModelDescription =>
      'निजी, डिवाइस पर बातचीत सक्षम करने के लिए AI मॉडल डाउनलोड करें।';

  @override
  String get choosePreferredAiModel =>
      'निजी, ऑन-डिवाइस बातचीत के लिए अपना पसंदीदा AI मॉडल चुनें।';

  @override
  String requiresWifiDownloadSize(String size) {
    return 'वाई-फाई अनुशंसित। डाउनलोड आकार: ~$size';
  }

  @override
  String get chooseModelDescription =>
      'निजी, डिवाइस पर बातचीत के लिए अपना पसंदीदा AI मॉडल चुनें।';

  @override
  String get aboutYou => 'आपके बारे में';

  @override
  String get helpPersonalizeExperience =>
      'अपने अनुभव को व्यक्तिगत बनाने में हमारी मदद करें';

  @override
  String get whatShouldWeCallYou => 'हम आपको क्या बुलाएं?';

  @override
  String get enterNameOrNickname => 'अपना नाम या उपनाम दर्ज करें';

  @override
  String get birthYear => 'जन्म वर्ष';

  @override
  String get selectYear => 'वर्ष चुनें';

  @override
  String get selectBirthYear => 'जन्म वर्ष चुनें';

  @override
  String get gender => 'लिंग';

  @override
  String get male => 'पुरुष';

  @override
  String get female => 'महिला';

  @override
  String get nonBinary => 'नॉन-बाइनरी';

  @override
  String get preferNotToSay => 'बताना नहीं चाहता';

  @override
  String get whatBringsYouHere => 'आपको यहाँ क्या लाया?';

  @override
  String get manageStress => 'तनाव प्रबंधन';

  @override
  String get trackMood => 'मूड ट्रैक करें';

  @override
  String get buildHabits => 'आदतें बनाएं';

  @override
  String get selfReflection => 'आत्म-चिंतन';

  @override
  String get justExploring => 'बस देख रहा हूं';

  @override
  String get howOftenJournal => 'आप कितनी बार डायरी लिखना चाहेंगे?';

  @override
  String get daily => 'रोज़ाना';

  @override
  String get fewTimesWeek => 'सप्ताह में कुछ बार';

  @override
  String get weekly => 'साप्ताहिक';

  @override
  String get whenIFeelLikeIt => 'जब मन करे';

  @override
  String get bestTimeForCheckIns => 'चेक-इन के लिए कौन सा समय सबसे अच्छा है?';

  @override
  String get morning => 'सुबह';

  @override
  String get afternoon => 'दोपहर';

  @override
  String get evening => 'शाम';

  @override
  String get flexible => 'लचीला';

  @override
  String questionOf(int current, int total) {
    return '$current में से $total';
  }

  @override
  String get chooseYourAi => 'अपना AI चुनें';

  @override
  String get selectHowToPowerAi =>
      'चुनें कि आप अपने AI सहायक को कैसे चलाना चाहते हैं';

  @override
  String get onDeviceAi => 'डिवाइस पर AI';

  @override
  String get maximumPrivacy => 'अधिकतम गोपनीयता';

  @override
  String get onDeviceDescription =>
      'आपके डिवाइस पर पूरी तरह से चलता है। आपका डेटा कभी आपके फोन से बाहर नहीं जाता।';

  @override
  String get completePrivacy => 'पूर्ण गोपनीयता';

  @override
  String get worksOffline => 'ऑफ़लाइन काम करता है';

  @override
  String get noSubscriptionNeeded => 'सब्सक्रिप्शन की ज़रूरत नहीं';

  @override
  String get requires2GBDownload => '~2GB डाउनलोड आवश्यक';

  @override
  String get usesDeviceResources => 'डिवाइस संसाधनों का उपयोग करता है';

  @override
  String get cloudAi => 'क्लाउड AI';

  @override
  String get morePowerful => 'अधिक शक्तिशाली';

  @override
  String get cloudDescription =>
      'तेज़, स्मार्ट प्रतिक्रियाओं के लिए क्लाउड प्रदाताओं द्वारा संचालित।';

  @override
  String get moreCapableModels => 'अधिक सक्षम मॉडल';

  @override
  String get fasterResponses => 'तेज़ प्रतिक्रियाएं';

  @override
  String get noStorageNeeded => 'स्टोरेज की ज़रूरत नहीं';

  @override
  String get requiresInternet => 'इंटरनेट आवश्यक';

  @override
  String get dataSentToCloud => 'डेटा क्लाउड पर भेजा जाता है';

  @override
  String downloadingModel(int progress) {
    return 'मॉडल डाउनलोड हो रहा है... $progress%';
  }

  @override
  String settingUp(int progress) {
    return 'सेटअप हो रहा है... $progress%';
  }

  @override
  String get setupFailed => 'सेटअप विफल। कृपया पुनः प्रयास करें।';

  @override
  String get insights => 'अंतर्दृष्टि';

  @override
  String get goodMorning => 'सुप्रभात';

  @override
  String get goodAfternoon => 'नमस्कार';

  @override
  String get goodEvening => 'शुभ संध्या';

  @override
  String get howAreYouToday => 'आज आप कैसा महसूस कर रहे हैं?';

  @override
  String get moodGreat => 'बहुत अच्छा';

  @override
  String get moodGood => 'अच्छा';

  @override
  String get moodOkay => 'ठीक';

  @override
  String get moodLow => 'अच्छा नहीं';

  @override
  String get moodSad => 'उदास';

  @override
  String get thisWeek => 'इस सप्ताह';

  @override
  String get upcomingAppointments => 'आगामी अपॉइंटमेंट';

  @override
  String get avgMood => 'औसत मूड';

  @override
  String get journalEntries => 'जर्नल प्रविष्टियां';

  @override
  String get chatSessions => 'चैट सत्र';

  @override
  String get stressLevel => 'तनाव का स्तर';

  @override
  String get startYourStreak => 'अपना स्ट्रीक शुरू करें!';

  @override
  String get writeJournalToBegin => 'शुरू करने के लिए एक प्रविष्टि लिखें';

  @override
  String dayStreak(int count) {
    return '$count दिन का स्ट्रीक!';
  }

  @override
  String get amazingConsistency => 'अद्भुत निरंतरता! शाबाश!';

  @override
  String get keepMomentumGoing => 'गति बनाए रखें';

  @override
  String get today => 'आज';

  @override
  String get tomorrow => 'कल';

  @override
  String get newEntry => 'नया';

  @override
  String get noJournalEntriesYet => 'अभी तक कोई जर्नल प्रविष्टियां नहीं';

  @override
  String get tapToCreateFirstEntry =>
      'अपनी पहली प्रविष्टि बनाने के लिए + पर टैप करें';

  @override
  String get draft => 'ड्राफ्ट';

  @override
  String get finalized => 'अंतिम';

  @override
  String get getHelp => 'मदद लें';

  @override
  String get connectWithProfessionals => 'लाइसेंस प्राप्त पेशेवरों से जुड़ें';

  @override
  String get yourAppointments => 'आपके अपॉइंटमेंट';

  @override
  String get inCrisis => 'संकट में?';

  @override
  String get callEmergencyServices => 'तुरंत आपातकालीन सेवाओं को कॉल करें';

  @override
  String get call => 'कॉल करें';

  @override
  String get services => 'सेवाएं';

  @override
  String get resources => 'संसाधन';

  @override
  String get therapistSession => 'थेरेपिस्ट सत्र';

  @override
  String get oneOnOneWithTherapist => 'लाइसेंस प्राप्त थेरेपिस्ट के साथ एक-एक';

  @override
  String get mentalHealthConsultation => 'मानसिक स्वास्थ्य परामर्श';

  @override
  String get generalWellnessGuidance => 'सामान्य कल्याण मार्गदर्शन';

  @override
  String get articles => 'लेख';

  @override
  String get guidedMeditations => 'निर्देशित ध्यान';

  @override
  String get crisisHotlines => 'संकट हेल्पलाइन';

  @override
  String get join => 'शामिल हों';

  @override
  String get trackMentalWellness =>
      'अपने मानसिक स्वास्थ्य को ट्रैक करें और समझें';

  @override
  String get takeAssessment => 'मूल्यांकन करें';

  @override
  String get emotionalCheckIn => 'भावनात्मक चेक-इन';

  @override
  String get understandEmotionalState =>
      'अपनी वर्तमान भावनात्मक स्थिति को समझें';

  @override
  String get stressAssessment => 'तनाव मूल्यांकन';

  @override
  String get measureStressLevels => 'अपने तनाव के स्तर को मापें';

  @override
  String get recentResults => 'हाल के परिणाम';

  @override
  String get checkIn => 'चेक-इन';

  @override
  String get cancel => 'रद्द करें';

  @override
  String nOfTotal(int current, int total) {
    return '$total में से $current';
  }

  @override
  String get emotionalWellbeing => 'भावनात्मक कल्याण';

  @override
  String get stressManagement => 'तनाव प्रबंधन';

  @override
  String get suggestions => 'सुझाव';

  @override
  String get done => 'हो गया';

  @override
  String get talkToProfessional => 'किसी पेशेवर से बात करें';

  @override
  String get aiModel => 'AI मॉडल';

  @override
  String get pleaseWriteSomethingFirst => 'कृपया पहले कुछ लिखें';

  @override
  String get useCloudAi => 'क्लाउड AI का उपयोग करें?';

  @override
  String get aboutToSwitchToCloud =>
      'आप क्लाउड AI प्रदाता (Gemini) पर स्विच करने वाले हैं';

  @override
  String get cloudPrivacyWarning =>
      'आपकी बातचीत Google के सर्वरों पर भेजी जाएगी। क्लाउड AI का उपयोग करते समय हम आपके डेटा की गोपनीयता की गारंटी नहीं दे सकते।';

  @override
  String get forMaxPrivacy =>
      'अधिकतम गोपनीयता के लिए, ऑन-डिवाइस AI विकल्प का उपयोग करें';

  @override
  String get iUnderstand => 'मैं समझता/समझती हूं';

  @override
  String get switchedToCloudAi => 'क्लाउड AI (Gemini) पर स्विच किया';

  @override
  String get switchedToOnDeviceAi => 'ऑन-डिवाइस AI पर स्विच किया';

  @override
  String languageChangedTo(String language) {
    return 'भाषा $language में बदली गई';
  }

  @override
  String get clearHistoryQuestion => 'इतिहास साफ़ करें?';

  @override
  String get clearHistoryWarning =>
      'यह आपका सारा डेटा हटा देगा। यह क्रिया पूर्ववत नहीं की जा सकती।';

  @override
  String get clear => 'साफ़ करें';

  @override
  String get historyCleared => 'इतिहास साफ़ किया गया';

  @override
  String get aboutAnchor => 'Anchor के बारे में';

  @override
  String get privacyPolicy => 'गोपनीयता नीति';

  @override
  String get helpAndSupport => 'सहायता और समर्थन';

  @override
  String version(String version) {
    return 'संस्करण $version';
  }

  @override
  String get yourWellnessCompanion => 'आपका मानसिक कल्याण साथी';

  @override
  String get system => 'सिस्टम';

  @override
  String get light => 'लाइट';

  @override
  String get dark => 'डार्क';

  @override
  String get onDeviceProvider => 'ऑन-डिवाइस';

  @override
  String get privateRunsLocally => 'निजी, स्थानीय रूप से चलता है';

  @override
  String get cloudGemini => 'क्लाउड (Gemini)';

  @override
  String get fasterRequiresInternet => 'तेज़, इंटरनेट आवश्यक';

  @override
  String get apiKeyNotConfigured => 'API कुंजी कॉन्फ़िगर नहीं';

  @override
  String get about => 'के बारे में';

  @override
  String get findTherapist => 'थेरेपिस्ट खोजें';

  @override
  String get searchByNameOrSpecialty => 'नाम या विशेषज्ञता से खोजें...';

  @override
  String therapistsAvailable(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count थेरेपिस्ट उपलब्ध',
      one: '$count थेरेपिस्ट उपलब्ध',
    );
    return '$_temp0';
  }

  @override
  String get switchLabel => 'स्विच करें';

  @override
  String changeModelTooltip(String modelName) {
    return 'मॉडल बदलें ($modelName)';
  }

  @override
  String get offline => 'ऑफ़लाइन';

  @override
  String get modelError => 'मॉडल त्रुटि';

  @override
  String get cloudAiLabel => 'क्लाउड AI';

  @override
  String get usingCloudAiLabel => 'क्लाउड AI का उपयोग हो रहा है';

  @override
  String get from => 'से';

  @override
  String get perSession => '/सत्र';

  @override
  String get unavailable => 'अनुपलब्ध';

  @override
  String get bookSession => 'सत्र बुक करें';

  @override
  String get viewProfile => 'प्रोफ़ाइल देखें';

  @override
  String get pleaseSelectTime => 'कृपया एक समय चुनें';

  @override
  String get date => 'दिनांक';

  @override
  String get time => 'समय';

  @override
  String get urgency => 'तात्कालिकता';

  @override
  String get normal => 'सामान्य';

  @override
  String get regularScheduling => 'नियमित शेड्यूलिंग';

  @override
  String get urgent => 'जरूरी';

  @override
  String get priority => 'प्राथमिकता (+\$20)';

  @override
  String get checkout => 'चेकआउट';

  @override
  String get summary => 'सारांश';

  @override
  String get type => 'प्रकार';

  @override
  String get price => 'मूल्य';

  @override
  String get session => 'सत्र';

  @override
  String get urgencyFee => 'तात्कालिकता शुल्क';

  @override
  String get total => 'कुल';

  @override
  String get testModeMessage =>
      'टेस्ट मोड: Sepolia टेस्टनेट पर \$1 राशि का उपयोग करता है';

  @override
  String get freeCancellation => 'अपॉइंटमेंट से 24 घंटे पहले तक मुफ्त रद्द';

  @override
  String payAmount(int amount) {
    return '\$$amount का भुगतान करें';
  }

  @override
  String get payment => 'भुगतान';

  @override
  String get paymentMethod => 'भुगतान विधि';

  @override
  String get creditDebitCard => 'क्रेडिट / डेबिट कार्ड';

  @override
  String get visaMastercardAmex => 'Visa, Mastercard, Amex';

  @override
  String get payWithPaypal => 'अपने PayPal खाते से भुगतान करें';

  @override
  String get cardNumber => 'कार्ड नंबर';

  @override
  String get walletConnected => 'वॉलेट जुड़ा';

  @override
  String get securedByBlockchain => 'ब्लॉकचेन द्वारा सुरक्षित';

  @override
  String get securePayment => 'सुरक्षित भुगतान';

  @override
  String get connectWalletToPay => 'भुगतान के लिए वॉलेट कनेक्ट करें';

  @override
  String reviewsCount(int count) {
    return '$count समीक्षाएं';
  }

  @override
  String get perSessionLabel => 'प्रति सत्र';

  @override
  String get minutes => 'मिनट';

  @override
  String get available => 'उपलब्ध';

  @override
  String get currentlyUnavailable => 'वर्तमान में अनुपलब्ध';

  @override
  String nextSlot(String time) {
    return 'अगला स्लॉट: $time';
  }

  @override
  String get specializations => 'विशेषज्ञताएं';

  @override
  String get languages => 'भाषाएं';

  @override
  String get reviews => 'समीक्षाएं';

  @override
  String get seeAll => 'सभी देखें';

  @override
  String bookSessionWithPrice(int price) {
    return 'सत्र बुक करें - \$$price';
  }

  @override
  String get unsavedChanges => 'सहेजे नहीं गए परिवर्तन';

  @override
  String get whatsOnYourMind => 'आपके मन में क्या है?';

  @override
  String get analyzingEntry => 'आपकी प्रविष्टि का विश्लेषण हो रहा है...';

  @override
  String get finalizing => 'अंतिम रूप दिया जा रहा है...';

  @override
  String get thisMayTakeAMoment => 'इसमें कुछ समय लग सकता है';

  @override
  String get aiGeneratingInsights => 'AI अंतर्दृष्टि उत्पन्न कर रहा है';

  @override
  String get pleaseWriteSomething => 'कृपया पहले कुछ लिखें';

  @override
  String failedToSave(String error) {
    return 'सहेजना विफल: $error';
  }

  @override
  String failedToFinalize(String error) {
    return 'अंतिम रूप देना विफल: $error';
  }

  @override
  String get whatWouldYouLikeToDo => 'आप क्या करना चाहेंगे?';

  @override
  String get saveAsDraft => 'ड्राफ्ट के रूप में सहेजें';

  @override
  String get keepEditingForDays => '3 दिनों तक संपादन जारी रखें';

  @override
  String get finalizeWithAi => 'AI के साथ अंतिम रूप दें';

  @override
  String get finalizeWithCloudAi => 'क्लाउड AI के साथ अंतिम रूप दें';

  @override
  String get finalizeEntry => 'प्रविष्टि अंतिम करें';

  @override
  String get getSummaryAndAnalysisGemini =>
      'सारांश और विश्लेषण प्राप्त करें (Gemini का उपयोग करता है)';

  @override
  String get getSummaryEmotionRisk =>
      'सारांश, भावना विश्लेषण और जोखिम मूल्यांकन प्राप्त करें';

  @override
  String get lockEntryAndStopEditing => 'प्रविष्टि लॉक करें और संपादन बंद करें';

  @override
  String get entryFinalized => 'प्रविष्टि अंतिम';

  @override
  String get entrySaved => 'प्रविष्टि सहेजी गई';

  @override
  String get entryAnalyzed => 'आपकी जर्नल प्रविष्टि का विश्लेषण किया गया';

  @override
  String get draftSaved => 'ड्राफ्ट सहेजा गया';

  @override
  String get riskAssessment => 'जोखिम मूल्यांकन';

  @override
  String get emotionalState => 'भावनात्मक स्थिति';

  @override
  String get aiSummary => 'AI सारांश';

  @override
  String get suggestedActions => 'सुझाई गई कार्रवाई';

  @override
  String get draftMode => 'ड्राफ्ट मोड';

  @override
  String get draftModeDescription =>
      'आप इस प्रविष्टि को 3 दिनों तक संपादित कर सकते हैं। जब तैयार हों, AI अंतर्दृष्टि प्राप्त करने के लिए अंतिम रूप दें।';

  @override
  String get storedOnEthStorage => 'EthStorage पर संग्रहीत';

  @override
  String get ethStorageConfigRequired => 'EthStorage कॉन्फ़िगरेशन आवश्यक';

  @override
  String get retry => 'पुनः प्रयास करें';

  @override
  String get view => 'देखें';

  @override
  String get uploadingToEthStorage => 'EthStorage पर अपलोड हो रहा है...';

  @override
  String get storeOnEthStorage => 'EthStorage पर संग्रहीत करें (Testnet)';

  @override
  String get successfullyUploaded => 'EthStorage पर सफलतापूर्वक अपलोड हुआ!';

  @override
  String couldNotOpenBrowser(String url) {
    return 'ब्राउज़र नहीं खोल सका। URL: $url';
  }

  @override
  String errorOpeningUrl(String error) {
    return 'URL खोलने में त्रुटि: $error';
  }

  @override
  String get riskHighDesc =>
      'मानसिक स्वास्थ्य पेशेवर से संपर्क करने पर विचार करें';

  @override
  String get riskMediumDesc =>
      'कुछ चिंताएं पाई गईं - अपने स्वास्थ्य पर नज़र रखें';

  @override
  String get riskLowDesc => 'कोई महत्वपूर्ण चिंता नहीं पाई गई';

  @override
  String get booked => 'बुक हो गया!';

  @override
  String sessionConfirmed(String therapistName) {
    return '$therapistName के साथ आपका सत्र पुष्ट है';
  }

  @override
  String get tbd => 'निर्धारित किया जाना है';

  @override
  String get paidWithDigitalWallet => 'डिजिटल वॉलेट से भुगतान किया';

  @override
  String get viewMyAppointments => 'मेरे अपॉइंटमेंट देखें';

  @override
  String paymentFailed(String error) {
    return 'भुगतान विफल: $error';
  }

  @override
  String failedToConnectWallet(String error) {
    return 'वॉलेट कनेक्ट करने में विफल: $error';
  }

  @override
  String get connectWallet => 'वॉलेट कनेक्ट करें';

  @override
  String get disconnect => 'डिस्कनेक्ट करें';

  @override
  String get viewOnEtherscan => 'Etherscan पर देखें';

  @override
  String get continueButton => 'जारी रखें';

  @override
  String get seeResults => 'परिणाम देखें';

  @override
  String get originalEntry => 'मूल प्रविष्टि';

  @override
  String get storedOnBlockchain => 'ब्लॉकचेन पर संग्रहीत';

  @override
  String get stressLow => 'कम';

  @override
  String get stressMedium => 'मध्यम';

  @override
  String get stressHigh => 'उच्च';

  @override
  String get stressUnknown => 'अज्ञात';

  @override
  String get trendNew => 'नया';

  @override
  String get trendStable => 'स्थिर';

  @override
  String get trendImproved => 'सुधार हुआ';

  @override
  String get trendWorsened => 'बिगड़ा';
}
