// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appName => 'Anchor';

  @override
  String get chat => 'Chat';

  @override
  String get journal => 'Tagebuch';

  @override
  String get home => 'Startseite';

  @override
  String get settings => 'Einstellungen';

  @override
  String get help => 'Hilfe';

  @override
  String get friend => 'Freund';

  @override
  String get therapist => 'Therapeut';

  @override
  String get chatWithFriend => 'Mit einem Freund chatten';

  @override
  String get guidedConversation => 'Geführtes Gespräch';

  @override
  String get friendEmptyStateDescription =>
      'Ich bin hier, um zuzuhören. Teile alles, was dir auf dem Herzen liegt.';

  @override
  String get therapistEmptyStateDescription =>
      'Erkunde deine Gedanken mit therapeutischer Gesprächsführung.';

  @override
  String get typeMessage => 'Nachricht eingeben...';

  @override
  String get thinking => 'Denkt nach...';

  @override
  String get loadingModel => 'Modell wird geladen...';

  @override
  String get downloadModel => 'Modell herunterladen';

  @override
  String get downloadAiModel => 'KI-Modell herunterladen';

  @override
  String get advancedAi => 'Erweitertes KI';

  @override
  String get compactAi => 'Kompaktes KI';

  @override
  String get onDeviceAiChat => 'KI-Chat auf dem Gerät';

  @override
  String get selectModel => 'Modell auswählen';

  @override
  String get recommended => 'Empfohlen';

  @override
  String get current => 'Aktuell';

  @override
  String get currentlyInUse => 'Wird derzeit verwendet';

  @override
  String get moreCapableBetterResponses =>
      'Leistungsfähiger • Bessere Antworten';

  @override
  String get lightweightFastResponses => 'Leichtgewichtig • Schnelle Antworten';

  @override
  String downloadSize(String size) {
    return '~$size Download';
  }

  @override
  String get modelReady => 'Modell bereit';

  @override
  String get startChatting => 'Chat starten';

  @override
  String get switchToDifferentModel => 'Zu anderem Modell wechseln';

  @override
  String get appearance => 'Erscheinungsbild';

  @override
  String get language => 'Sprache';

  @override
  String get selectLanguage => 'Sprache auswählen';

  @override
  String get aiProvider => 'KI-Anbieter';

  @override
  String get security => 'Sicherheit';

  @override
  String get notifications => 'Benachrichtigungen';

  @override
  String get data => 'Daten';

  @override
  String get appLock => 'App-Sperre';

  @override
  String get pushNotifications => 'Push-Benachrichtigungen';

  @override
  String get clearHistory => 'Verlauf löschen';

  @override
  String get exportData => 'Daten exportieren';

  @override
  String get skip => 'Überspringen';

  @override
  String get next => 'Weiter';

  @override
  String get getStarted => 'Los geht\'s';

  @override
  String get continueText => 'Fortfahren';

  @override
  String get journalYourThoughts => 'Schreibe deine Gedanken auf';

  @override
  String get journalDescription =>
      'Drücke dich frei aus und verfolge deine emotionale Reise.';

  @override
  String get talkToAiCompanion => 'Mit KI-Begleiter sprechen';

  @override
  String get talkToAiDescription =>
      'Chatte jederzeit mit einem unterstützenden KI-Freund oder Therapeuten.';

  @override
  String get trackYourProgress => 'Verfolge deinen Fortschritt';

  @override
  String get trackProgressDescription =>
      'Verstehe deine mentalen Muster mit Einblicken und Bewertungen.';

  @override
  String get chooseYourLanguage => 'Wähle deine Sprache';

  @override
  String get languageDescription =>
      'Wähle deine bevorzugte Sprache für die App. Du kannst dies später in den Einstellungen ändern.';

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
  String get onDevice => 'Auf dem Gerät';

  @override
  String get cloud => 'Cloud';

  @override
  String get privateOnDevice => '100% auf dem Gerät';

  @override
  String get usingCloudAi => 'Verwendet Cloud-KI';

  @override
  String get offlineMode => 'Offline-Modus';

  @override
  String get aiReady => 'KI bereit';

  @override
  String get nativeAi => 'Native KI';

  @override
  String get demoMode => 'Demo-Modus';

  @override
  String get checkingModel => 'Modell wird überprüft...';

  @override
  String get loadingAiModel => 'KI-Modell wird geladen...';

  @override
  String get preparingModelForChat => 'Modell wird für den Chat vorbereitet';

  @override
  String getModelForPrivateChat(String modelName) {
    return 'Hol dir das $modelName-Modell für private KI-Chats auf dem Gerät';
  }

  @override
  String get loadModel => 'Modell laden';

  @override
  String get aiModelReady => 'KI-Modell bereit';

  @override
  String get loadModelToStartChatting => 'Lade das Modell, um zu chatten';

  @override
  String get deviceHasEnoughRam => 'Dein Gerät hat genug RAM für beide Modelle';

  @override
  String wifiRecommended(String size) {
    return 'WLAN empfohlen. Download-Größe: ~$size';
  }

  @override
  String get checkingModelStatus => 'Modellstatus wird überprüft...';

  @override
  String get downloadFailed => 'Download fehlgeschlagen';

  @override
  String get retryDownload => 'Download wiederholen';

  @override
  String get keepAppOpen => 'Bitte lass die App während des Downloads geöffnet';

  @override
  String get keepAppOpenDuringDownload =>
      'Bitte lass die App während des Downloads geöffnet';

  @override
  String get switchText => 'Wechseln';

  @override
  String get change => 'Ändern';

  @override
  String get downloading => 'Wird heruntergeladen...';

  @override
  String get changeModel => 'Modell ändern';

  @override
  String get errorOccurred =>
      'Entschuldigung, es ist ein Problem aufgetreten. Bitte versuche es erneut.';

  @override
  String get size => 'Größe';

  @override
  String get privacy => 'Datenschutz';

  @override
  String get downloadModelDescription =>
      'Lade das KI-Modell herunter, um private Gespräche auf dem Gerät zu ermöglichen.';

  @override
  String get choosePreferredAiModel =>
      'Wähle dein bevorzugtes KI-Modell für private Gespräche auf dem Gerät.';

  @override
  String requiresWifiDownloadSize(String size) {
    return 'WLAN empfohlen. Download-Größe: ~$size';
  }

  @override
  String get chooseModelDescription =>
      'Wähle dein bevorzugtes KI-Modell für private Gespräche auf dem Gerät.';

  @override
  String get aboutYou => 'Über dich';

  @override
  String get helpPersonalizeExperience =>
      'Hilf uns, dein Erlebnis zu personalisieren';

  @override
  String get whatShouldWeCallYou => 'Wie sollen wir dich nennen?';

  @override
  String get enterNameOrNickname => 'Gib deinen Namen oder Spitznamen ein';

  @override
  String get birthYear => 'Geburtsjahr';

  @override
  String get selectYear => 'Jahr auswählen';

  @override
  String get selectBirthYear => 'Geburtsjahr auswählen';

  @override
  String get gender => 'Geschlecht';

  @override
  String get male => 'Männlich';

  @override
  String get female => 'Weiblich';

  @override
  String get nonBinary => 'Nicht-binär';

  @override
  String get preferNotToSay => 'Keine Angabe';

  @override
  String get whatBringsYouHere => 'Was führt dich hierher?';

  @override
  String get manageStress => 'Stress bewältigen';

  @override
  String get trackMood => 'Stimmung verfolgen';

  @override
  String get buildHabits => 'Gewohnheiten aufbauen';

  @override
  String get selfReflection => 'Selbstreflexion';

  @override
  String get justExploring => 'Nur erkunden';

  @override
  String get howOftenJournal => 'Wie oft möchtest du Tagebuch führen?';

  @override
  String get daily => 'Täglich';

  @override
  String get fewTimesWeek => 'Ein paar Mal pro Woche';

  @override
  String get weekly => 'Wöchentlich';

  @override
  String get whenIFeelLikeIt => 'Wenn mir danach ist';

  @override
  String get bestTimeForCheckIns =>
      'Welche Zeit passt am besten für Check-ins?';

  @override
  String get morning => 'Morgens';

  @override
  String get afternoon => 'Nachmittags';

  @override
  String get evening => 'Abends';

  @override
  String get flexible => 'Flexibel';

  @override
  String questionOf(int current, int total) {
    return '$current von $total';
  }

  @override
  String get chooseYourAi => 'Wähle deine KI';

  @override
  String get selectHowToPowerAi =>
      'Wähle, wie du deinen KI-Assistenten betreiben möchtest';

  @override
  String get onDeviceAi => 'KI auf dem Gerät';

  @override
  String get maximumPrivacy => 'Maximale Privatsphäre';

  @override
  String get onDeviceDescription =>
      'Läuft vollständig auf deinem Gerät. Deine Daten verlassen nie dein Telefon.';

  @override
  String get completePrivacy => 'Vollständige Privatsphäre';

  @override
  String get worksOffline => 'Funktioniert offline';

  @override
  String get noSubscriptionNeeded => 'Kein Abo erforderlich';

  @override
  String get requires2GBDownload => 'Erfordert ~2GB Download';

  @override
  String get usesDeviceResources => 'Nutzt Geräteressourcen';

  @override
  String get cloudAi => 'Cloud-KI';

  @override
  String get morePowerful => 'Leistungsfähiger';

  @override
  String get cloudDescription =>
      'Betrieben von Cloud-Anbietern für schnellere, intelligentere Antworten.';

  @override
  String get moreCapableModels => 'Leistungsfähigere Modelle';

  @override
  String get fasterResponses => 'Schnellere Antworten';

  @override
  String get noStorageNeeded => 'Kein Speicher erforderlich';

  @override
  String get requiresInternet => 'Erfordert Internet';

  @override
  String get dataSentToCloud => 'Daten werden in die Cloud gesendet';

  @override
  String downloadingModel(int progress) {
    return 'Modell wird heruntergeladen... $progress%';
  }

  @override
  String settingUp(int progress) {
    return 'Wird eingerichtet... $progress%';
  }

  @override
  String get setupFailed =>
      'Einrichtung fehlgeschlagen. Bitte versuche es erneut.';

  @override
  String get insights => 'Einblicke';

  @override
  String get goodMorning => 'Guten Morgen';

  @override
  String goodMorningName(String name) {
    return 'Guten Morgen, $name';
  }

  @override
  String get goodAfternoon => 'Guten Tag';

  @override
  String goodAfternoonName(String name) {
    return 'Guten Tag, $name';
  }

  @override
  String get goodEvening => 'Guten Abend';

  @override
  String goodEveningName(String name) {
    return 'Guten Abend, $name';
  }

  @override
  String get howAreYouToday => 'Wie geht es dir heute?';

  @override
  String get moodGreat => 'Super';

  @override
  String get moodGood => 'Gut';

  @override
  String get moodOkay => 'Okay';

  @override
  String get moodLow => 'Nicht so gut';

  @override
  String get moodSad => 'Traurig';

  @override
  String get thisWeek => 'Diese Woche';

  @override
  String get upcomingAppointments => 'Kommende Termine';

  @override
  String get avgMood => 'Durchschn. Stimmung';

  @override
  String get journalEntries => 'Tagebucheinträge';

  @override
  String get chatSessions => 'Chat-Sitzungen';

  @override
  String get stressLevel => 'Stresslevel';

  @override
  String get startYourStreak => 'Starte deine Serie!';

  @override
  String get writeJournalToBegin => 'Schreibe einen Eintrag, um zu beginnen';

  @override
  String dayStreak(int count) {
    return '$count Tage Serie!';
  }

  @override
  String get amazingConsistency => 'Erstaunliche Beständigkeit! Toll gemacht!';

  @override
  String get keepMomentumGoing => 'Bleib am Ball';

  @override
  String get today => 'Heute';

  @override
  String get tomorrow => 'Morgen';

  @override
  String get newEntry => 'Neu';

  @override
  String get noJournalEntriesYet => 'Noch keine Tagebucheinträge';

  @override
  String get tapToCreateFirstEntry =>
      'Tippe auf +, um deinen ersten Eintrag zu erstellen';

  @override
  String get draft => 'Entwurf';

  @override
  String get finalized => 'Abgeschlossen';

  @override
  String get getHelp => 'Hilfe erhalten';

  @override
  String get connectWithProfessionals =>
      'Verbinde dich mit lizenzierten Fachleuten';

  @override
  String get yourAppointments => 'Deine Termine';

  @override
  String get inCrisis => 'In einer Krise?';

  @override
  String get callEmergencyServices => 'Rufe sofort den Notdienst an';

  @override
  String get call => 'Anrufen';

  @override
  String get services => 'Dienste';

  @override
  String get resources => 'Ressourcen';

  @override
  String get therapistSession => 'Therapeuten-Sitzung';

  @override
  String get oneOnOneWithTherapist =>
      'Einzelsitzung mit lizenziertem Therapeuten';

  @override
  String get mentalHealthConsultation => 'Psychische Gesundheitsberatung';

  @override
  String get generalWellnessGuidance => 'Allgemeine Wellness-Beratung';

  @override
  String get articles => 'Artikel';

  @override
  String get guidedMeditations => 'Geführte Meditationen';

  @override
  String get crisisHotlines => 'Krisenhotlines';

  @override
  String get join => 'Teilnehmen';

  @override
  String get trackMentalWellness =>
      'Verfolge und verstehe dein mentales Wohlbefinden';

  @override
  String get takeAssessment => 'Bewertung machen';

  @override
  String get emotionalCheckIn => 'Emotionales Check-in';

  @override
  String get understandEmotionalState =>
      'Verstehe deinen aktuellen emotionalen Zustand';

  @override
  String get stressAssessment => 'Stressbewertung';

  @override
  String get measureStressLevels => 'Miss dein Stressniveau';

  @override
  String get recentResults => 'Aktuelle Ergebnisse';

  @override
  String get checkIn => 'Check-in';

  @override
  String get cancel => 'Abbrechen';

  @override
  String nOfTotal(int current, int total) {
    return '$current von $total';
  }

  @override
  String get emotionalWellbeing => 'Emotionales Wohlbefinden';

  @override
  String get stressManagement => 'Stressmanagement';

  @override
  String get suggestions => 'Vorschläge';

  @override
  String get done => 'Fertig';

  @override
  String get talkToProfessional => 'Mit einem Fachmann sprechen';

  @override
  String get aiModel => 'KI-Modell';

  @override
  String get pleaseWriteSomethingFirst => 'Bitte schreibe zuerst etwas';

  @override
  String get useCloudAi => 'Cloud-KI verwenden?';

  @override
  String get aboutToSwitchToCloud =>
      'Du wechselst zu einem Cloud-KI-Anbieter (Gemini)';

  @override
  String get cloudPrivacyWarning =>
      'Deine Gespräche werden an Google-Server gesendet. Wir können die Privatsphäre deiner Daten bei Verwendung von Cloud-KI nicht garantieren.';

  @override
  String get forMaxPrivacy =>
      'Für maximale Privatsphäre verwende die On-Device-KI-Option';

  @override
  String get iUnderstand => 'Ich verstehe';

  @override
  String get switchedToCloudAi => 'Zu Cloud-KI (Gemini) gewechselt';

  @override
  String get switchedToOnDeviceAi => 'Zu On-Device-KI gewechselt';

  @override
  String languageChangedTo(String language) {
    return 'Sprache auf $language geändert';
  }

  @override
  String get clearHistoryQuestion => 'Verlauf löschen?';

  @override
  String get clearHistoryWarning =>
      'Dies löscht alle deine Daten. Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get clear => 'Löschen';

  @override
  String get historyCleared => 'Verlauf gelöscht';

  @override
  String get aboutAnchor => 'Über Anchor';

  @override
  String get privacyPolicy => 'Datenschutzrichtlinie';

  @override
  String get helpAndSupport => 'Hilfe & Support';

  @override
  String version(String version) {
    return 'Version $version';
  }

  @override
  String get yourWellnessCompanion =>
      'Dein Wellness-Begleiter für psychische Gesundheit';

  @override
  String get system => 'System';

  @override
  String get light => 'Hell';

  @override
  String get dark => 'Dunkel';

  @override
  String get onDeviceProvider => 'Auf dem Gerät';

  @override
  String get privateRunsLocally => 'Privat, läuft lokal';

  @override
  String get cloudGemini => 'Cloud (Gemini)';

  @override
  String get fasterRequiresInternet => 'Schneller, erfordert Internet';

  @override
  String get apiKeyNotConfigured => 'API-Schlüssel nicht konfiguriert';

  @override
  String get about => 'Über';

  @override
  String get findTherapist => 'Therapeut finden';

  @override
  String get searchByNameOrSpecialty => 'Nach Name oder Fachgebiet suchen...';

  @override
  String therapistsAvailable(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Therapeuten verfügbar',
      one: '$count Therapeut verfügbar',
    );
    return '$_temp0';
  }

  @override
  String get switchLabel => 'Wechseln';

  @override
  String changeModelTooltip(String modelName) {
    return 'Modell ändern ($modelName)';
  }

  @override
  String get offline => 'Offline';

  @override
  String get modelError => 'Modellfehler';

  @override
  String get cloudAiLabel => 'Cloud-KI';

  @override
  String get usingCloudAiLabel => 'Cloud-KI wird verwendet';

  @override
  String get from => 'Ab';

  @override
  String get perSession => '/Sitzung';

  @override
  String get unavailable => 'Nicht verfügbar';

  @override
  String get bookSession => 'Sitzung buchen';

  @override
  String get viewProfile => 'Profil anzeigen';

  @override
  String get pleaseSelectTime => 'Bitte wähle eine Zeit';

  @override
  String get date => 'Datum';

  @override
  String get time => 'Zeit';

  @override
  String get urgency => 'Dringlichkeit';

  @override
  String get normal => 'Normal';

  @override
  String get regularScheduling => 'Reguläre Terminplanung';

  @override
  String get urgent => 'Dringend';

  @override
  String get priority => 'Priorität (+\$20)';

  @override
  String get checkout => 'Zur Kasse';

  @override
  String get summary => 'Zusammenfassung';

  @override
  String get type => 'Typ';

  @override
  String get price => 'Preis';

  @override
  String get session => 'Sitzung';

  @override
  String get urgencyFee => 'Dringlichkeitsgebühr';

  @override
  String get total => 'Gesamt';

  @override
  String get testModeMessage =>
      'Testmodus: Verwendet \$1 Beträge im Sepolia-Testnetz';

  @override
  String get freeCancellation =>
      'Kostenlose Stornierung bis 24 Stunden vor dem Termin';

  @override
  String payAmount(int amount) {
    return '\$$amount bezahlen';
  }

  @override
  String get payment => 'Zahlung';

  @override
  String get paymentMethod => 'Zahlungsmethode';

  @override
  String get creditDebitCard => 'Kredit- / Debitkarte';

  @override
  String get visaMastercardAmex => 'Visa, Mastercard, Amex';

  @override
  String get payWithPaypal => 'Mit deinem PayPal-Konto bezahlen';

  @override
  String get cardNumber => 'Kartennummer';

  @override
  String get walletConnected => 'Wallet verbunden';

  @override
  String get securedByBlockchain => 'Durch Blockchain gesichert';

  @override
  String get securePayment => 'Sichere Zahlung';

  @override
  String get connectWalletToPay => 'Wallet zum Bezahlen verbinden';

  @override
  String reviewsCount(int count) {
    return '$count Bewertungen';
  }

  @override
  String get perSessionLabel => 'pro Sitzung';

  @override
  String get minutes => 'Minuten';

  @override
  String get available => 'Verfügbar';

  @override
  String get currentlyUnavailable => 'Derzeit nicht verfügbar';

  @override
  String nextSlot(String time) {
    return 'Nächster Termin: $time';
  }

  @override
  String get specializations => 'Spezialisierungen';

  @override
  String get languages => 'Sprachen';

  @override
  String get reviews => 'Bewertungen';

  @override
  String get seeAll => 'Alle anzeigen';

  @override
  String bookSessionWithPrice(int price) {
    return 'Sitzung buchen - \$$price';
  }

  @override
  String get unsavedChanges => 'Ungespeicherte Änderungen';

  @override
  String get whatsOnYourMind => 'Was beschäftigt dich?';

  @override
  String get analyzingEntry => 'Eintrag wird analysiert...';

  @override
  String get finalizing => 'Wird abgeschlossen...';

  @override
  String get thisMayTakeAMoment => 'Dies kann einen Moment dauern';

  @override
  String get aiGeneratingInsights => 'KI generiert Einblicke';

  @override
  String get pleaseWriteSomething => 'Bitte schreibe zuerst etwas';

  @override
  String failedToSave(String error) {
    return 'Speichern fehlgeschlagen: $error';
  }

  @override
  String failedToFinalize(String error) {
    return 'Abschluss fehlgeschlagen: $error';
  }

  @override
  String get whatWouldYouLikeToDo => 'Was möchtest du tun?';

  @override
  String get saveAsDraft => 'Als Entwurf speichern';

  @override
  String get keepEditingForDays => 'Bis zu 3 Tage weiter bearbeiten';

  @override
  String get finalizeWithAi => 'Mit KI abschließen';

  @override
  String get finalizeWithCloudAi => 'Mit Cloud-KI abschließen';

  @override
  String get finalizeEntry => 'Eintrag abschließen';

  @override
  String get getSummaryAndAnalysisGemini =>
      'Zusammenfassung und Analyse erhalten (verwendet Gemini)';

  @override
  String get getSummaryEmotionRisk =>
      'Zusammenfassung, Emotionsanalyse und Risikobewertung erhalten';

  @override
  String get lockEntryAndStopEditing =>
      'Eintrag sperren und Bearbeitung beenden';

  @override
  String get entryFinalized => 'Eintrag abgeschlossen';

  @override
  String get entrySaved => 'Eintrag gespeichert';

  @override
  String get entryAnalyzed => 'Dein Tagebucheintrag wurde analysiert';

  @override
  String get draftSaved => 'Entwurf gespeichert';

  @override
  String get riskAssessment => 'Risikobewertung';

  @override
  String get emotionalState => 'Emotionaler Zustand';

  @override
  String get aiSummary => 'KI-Zusammenfassung';

  @override
  String get suggestedActions => 'Vorgeschlagene Maßnahmen';

  @override
  String get draftMode => 'Entwurfsmodus';

  @override
  String get draftModeDescription =>
      'Du kannst diesen Eintrag noch 3 Tage lang bearbeiten. Wenn du bereit bist, schließe ihn ab, um KI-Einblicke zu erhalten.';

  @override
  String get storedOnEthStorage => 'Auf EthStorage gespeichert';

  @override
  String get ethStorageConfigRequired =>
      'EthStorage-Konfiguration erforderlich';

  @override
  String get retry => 'Wiederholen';

  @override
  String get view => 'Anzeigen';

  @override
  String get uploadingToEthStorage => 'Wird auf EthStorage hochgeladen...';

  @override
  String get storeOnEthStorage => 'Auf EthStorage speichern (Testnet)';

  @override
  String get successfullyUploaded => 'Erfolgreich auf EthStorage hochgeladen!';

  @override
  String couldNotOpenBrowser(String url) {
    return 'Browser konnte nicht geöffnet werden. URL: $url';
  }

  @override
  String errorOpeningUrl(String error) {
    return 'Fehler beim Öffnen der URL: $error';
  }

  @override
  String get riskHighDesc =>
      'Erwäge, einen Fachmann für psychische Gesundheit zu kontaktieren';

  @override
  String get riskMediumDesc =>
      'Einige Bedenken erkannt - überwache dein Wohlbefinden';

  @override
  String get riskLowDesc => 'Keine signifikanten Bedenken erkannt';

  @override
  String get booked => 'Gebucht!';

  @override
  String sessionConfirmed(String therapistName) {
    return 'Deine Sitzung mit $therapistName ist bestätigt';
  }

  @override
  String get tbd => 'Noch festzulegen';

  @override
  String get paidWithDigitalWallet => 'Mit digitaler Wallet bezahlt';

  @override
  String get viewMyAppointments => 'Meine Termine anzeigen';

  @override
  String paymentFailed(String error) {
    return 'Zahlung fehlgeschlagen: $error';
  }

  @override
  String failedToConnectWallet(String error) {
    return 'Wallet-Verbindung fehlgeschlagen: $error';
  }

  @override
  String get connectWallet => 'Wallet verbinden';

  @override
  String get disconnect => 'Trennen';

  @override
  String get viewOnEtherscan => 'Auf Etherscan anzeigen';

  @override
  String get continueButton => 'Weiter';

  @override
  String get seeResults => 'Ergebnisse anzeigen';

  @override
  String get originalEntry => 'Originaleintrag';

  @override
  String get storedOnBlockchain => 'Auf der Blockchain gespeichert';

  @override
  String get stressLow => 'Niedrig';

  @override
  String get stressMedium => 'Mittel';

  @override
  String get stressHigh => 'Hoch';

  @override
  String get stressUnknown => 'Unbekannt';

  @override
  String get trendNew => 'Neu';

  @override
  String get trendStable => 'Stabil';

  @override
  String get trendImproved => 'Verbessert';

  @override
  String get trendWorsened => 'Verschlechtert';

  @override
  String get pleaseSelectSepoliaNetwork =>
      'Bitte wechsle zum Sepolia-Testnetz in deinem Wallet';

  @override
  String get switchNetwork => 'Netzwerk wechseln';

  @override
  String get unlockAnchor => 'Anchor entsperren';

  @override
  String get enterYourPin => 'Gib deine PIN ein';

  @override
  String get enterPinToUnlock => 'Gib deine PIN ein, um die App zu entsperren';

  @override
  String get incorrectPin => 'Falsche PIN';

  @override
  String incorrectPinAttempts(int attempts) {
    return 'Falsche PIN. $attempts Versuche übrig';
  }

  @override
  String tooManyAttempts(int seconds) {
    return 'Zu viele Versuche. Versuche es in $seconds Sekunden erneut';
  }

  @override
  String get setUpAppLock => 'App-Sperre einrichten';

  @override
  String get changePin => 'PIN ändern';

  @override
  String get disableAppLock => 'App-Sperre deaktivieren';

  @override
  String get enterCurrentPin => 'Aktuelle PIN eingeben';

  @override
  String get createNewPin => 'Neue PIN erstellen';

  @override
  String get confirmYourPin => 'PIN bestätigen';

  @override
  String get enterPinToDisableLock =>
      'Gib deine PIN ein, um die App-Sperre zu deaktivieren';

  @override
  String get enterCurrentPinToContinue =>
      'Gib deine aktuelle PIN ein, um fortzufahren';

  @override
  String get choosePinDigits => 'Wähle eine 4-stellige PIN';

  @override
  String get reenterPinToConfirm =>
      'Gib deine PIN erneut ein, um zu bestätigen';

  @override
  String get pinMustBeDigits => 'PIN muss mindestens 4 Ziffern haben';

  @override
  String get pinsDoNotMatch => 'PINs stimmen nicht überein. Versuche es erneut';

  @override
  String get failedToSetPin =>
      'PIN konnte nicht gesetzt werden. Bitte versuche es erneut';

  @override
  String get appLockEnabled => 'App-Sperre aktiviert';

  @override
  String get appLockDisabled => 'App-Sperre deaktiviert';

  @override
  String get pinChanged => 'PIN erfolgreich geändert';

  @override
  String useBiometrics(String biometricType) {
    return '$biometricType verwenden';
  }

  @override
  String unlockWithBiometrics(String biometricType) {
    return 'Mit $biometricType entsperren für schnelleren Zugriff';
  }

  @override
  String get lockWhenLeaving => 'Beim Verlassen der App sperren';

  @override
  String get lockWhenLeavingSubtitle =>
      'PIN erforderlich beim Zurückkehren zur App';

  @override
  String get changePinCode => 'PIN-Code ändern';

  @override
  String get removeAppLock => 'App-Sperre entfernen';

  @override
  String get appLockSettings => 'App-Sperre-Einstellungen';

  @override
  String get protectYourPrivacy =>
      'Schütze deine Privatsphäre mit einem PIN-Code';

  @override
  String get gad7Assessment => 'GAD-7 Bewertung';

  @override
  String get phq9Assessment => 'PHQ-9 Bewertung';

  @override
  String get assessmentIntroText =>
      'Wie oft haben Sie in den letzten zwei Wochen unter den folgenden Problemen gelitten?';

  @override
  String get answerNotAtAll => 'Überhaupt nicht';

  @override
  String get answerSeveralDays => 'An mehreren Tagen';

  @override
  String get answerMoreThanHalfDays => 'An mehr als der Hälfte der Tage';

  @override
  String get answerNearlyEveryDay => 'Beinahe jeden Tag';

  @override
  String get seeResult => 'Ergebnis anzeigen';

  @override
  String get gad7Question1 => 'Nervosität, Ängstlichkeit oder Anspannung';

  @override
  String get gad7Question2 =>
      'Nicht in der Lage sein, Sorgen zu stoppen oder zu kontrollieren';

  @override
  String get gad7Question3 => 'Übermäßige Sorgen bezüglich verschiedener Dinge';

  @override
  String get gad7Question4 => 'Schwierigkeiten, sich zu entspannen';

  @override
  String get gad7Question5 =>
      'So unruhig sein, dass es schwer fällt, still zu sitzen';

  @override
  String get gad7Question6 => 'Leicht reizbar oder verärgert werden';

  @override
  String get gad7Question7 =>
      'Angst haben, als ob etwas Schreckliches passieren könnte';

  @override
  String get phq9Question1 =>
      'Wenig Interesse oder Freude an Ihren Tätigkeiten';

  @override
  String get phq9Question2 =>
      'Niedergeschlagenheit, Schwermut oder Hoffnungslosigkeit';

  @override
  String get phq9Question3 =>
      'Schwierigkeiten, ein- oder durchzuschlafen, oder übermäßig viel zu schlafen';

  @override
  String get phq9Question4 => 'Müdigkeit oder wenig Energie';

  @override
  String get phq9Question5 => 'Verminderter Appetit oder übermäßiges Essen';

  @override
  String get phq9Question6 =>
      'Schlechte Meinung von sich selbst — oder das Gefühl, ein Versager zu sein oder die Familie enttäuscht zu haben';

  @override
  String get phq9Question7 =>
      'Schwierigkeiten, sich auf etwas zu konzentrieren, wie z.B. Zeitunglesen oder Fernsehen';

  @override
  String get phq9Question8 =>
      'So langsame Bewegungen oder Sprache, dass andere es bemerken könnten? Oder das Gegenteil — so zappelig oder unruhig, dass Sie sich mehr als üblich bewegt haben';

  @override
  String get phq9Question9 =>
      'Gedanken, dass Sie besser tot wären oder sich selbst verletzen könnten';

  @override
  String get gad7ResultsTitle => 'GAD-7 Angstbewertung';

  @override
  String get phq9ResultsTitle => 'PHQ-9 Depressionsbewertung';

  @override
  String get minimalAnxiety => 'Minimale Angst';

  @override
  String get mildAnxiety => 'Leichte Angst';

  @override
  String get moderateAnxiety => 'Mittlere Angst';

  @override
  String get severeAnxiety => 'Schwere Angst';

  @override
  String get minimalDepression => 'Minimale Depression';

  @override
  String get mildDepression => 'Leichte Depression';

  @override
  String get moderateDepression => 'Mittlere Depression';

  @override
  String get moderatelySevereDepression => 'Mittelschwere Depression';

  @override
  String get severeDepression => 'Schwere Depression';

  @override
  String get gad7DescMinimal => 'Minimale Angst. Weiter so!';

  @override
  String get gad7DescMild =>
      'Leichte Angst. Erwägen Sie Entspannungstechniken.';

  @override
  String get gad7DescModerate =>
      'Mittlere Angst. Achten Sie auf Ihre psychische Gesundheit.';

  @override
  String get gad7DescSevere =>
      'Schwere Angst. Professionelle Hilfe wird empfohlen.';

  @override
  String get phq9DescMinimal =>
      'Symptome deuten auf minimale Depression hin. Beobachten Sie Ihre Stimmung weiterhin.';

  @override
  String get phq9DescMild =>
      'Symptome deuten auf leichte Depression hin. Es könnte hilfreich sein, mit einem Berater zu sprechen.';

  @override
  String get phq9DescModerate =>
      'Symptome deuten auf mittlere Depression hin. Erwägen Sie eine Konsultation bei einem Facharzt.';

  @override
  String get phq9DescModeratelySevere =>
      'Symptome deuten auf mittelschwere Depression hin. Bitte wenden Sie sich an einen Fachmann.';

  @override
  String get phq9DescSevere =>
      'Symptome deuten auf schwere Depression hin. Wir empfehlen dringend, sofort professionelle Hilfe zu suchen.';

  @override
  String get nextSteps => 'Nächste Schritte';

  @override
  String get recPracticeMindfulness =>
      'Achtsamkeit und Meditation praktizieren';

  @override
  String get recPhysicalActivity => 'Regelmäßige körperliche Aktivität';

  @override
  String get recHealthySleep => 'Einen gesunden Schlafrhythmus einhalten';

  @override
  String get recTalkToFriends =>
      'Mit vertrauten Freunden oder Familienmitgliedern sprechen';

  @override
  String get recMaintainRoutine =>
      'Eine Routine für Schlaf und Mahlzeiten einhalten';

  @override
  String get recSetGoals => 'Kleine, erreichbare tägliche Ziele setzen';

  @override
  String get recStayConnected =>
      'Mit Ihrem Unterstützungsnetzwerk verbunden bleiben';

  @override
  String get recContactCrisisHotline =>
      'Eine psychische Krisenhotline kontaktieren';
}
