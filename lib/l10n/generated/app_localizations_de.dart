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
  String get goodAfternoon => 'Guten Tag';

  @override
  String get goodEvening => 'Guten Abend';

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
}
