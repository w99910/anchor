// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'Anchor';

  @override
  String get chat => 'Discussion';

  @override
  String get journal => 'Journal';

  @override
  String get home => 'Accueil';

  @override
  String get settings => 'Paramètres';

  @override
  String get help => 'Aide';

  @override
  String get friend => 'Ami';

  @override
  String get therapist => 'Thérapeute';

  @override
  String get chatWithFriend => 'Discuter avec un ami';

  @override
  String get guidedConversation => 'Conversation guidée';

  @override
  String get friendEmptyStateDescription =>
      'Je suis là pour écouter. Partagez tout ce qui vous préoccupe.';

  @override
  String get therapistEmptyStateDescription =>
      'Explorez vos pensées avec un dialogue thérapeutique guidé.';

  @override
  String get typeMessage => 'Tapez un message...';

  @override
  String get thinking => 'Réflexion...';

  @override
  String get loadingModel => 'Chargement du modèle...';

  @override
  String get downloadModel => 'Télécharger le modèle';

  @override
  String get downloadAiModel => 'Télécharger le modèle IA';

  @override
  String get advancedAi => 'IA Avancée';

  @override
  String get compactAi => 'IA Compacte';

  @override
  String get onDeviceAiChat => 'Chat IA sur l\'appareil';

  @override
  String get selectModel => 'Sélectionner le modèle';

  @override
  String get recommended => 'Recommandé';

  @override
  String get current => 'Actuel';

  @override
  String get currentlyInUse => 'Actuellement utilisé';

  @override
  String get moreCapableBetterResponses =>
      'Plus performant • Meilleures réponses';

  @override
  String get lightweightFastResponses => 'Léger • Réponses rapides';

  @override
  String downloadSize(String size) {
    return '~$size téléchargement';
  }

  @override
  String get modelReady => 'Modèle prêt';

  @override
  String get startChatting => 'Commencer à discuter';

  @override
  String get switchToDifferentModel => 'Changer de modèle';

  @override
  String get appearance => 'Apparence';

  @override
  String get language => 'Langue';

  @override
  String get selectLanguage => 'Sélectionner la langue';

  @override
  String get aiProvider => 'Fournisseur IA';

  @override
  String get security => 'Sécurité';

  @override
  String get notifications => 'Notifications';

  @override
  String get data => 'Données';

  @override
  String get appLock => 'Verrouillage de l\'app';

  @override
  String get pushNotifications => 'Notifications push';

  @override
  String get clearHistory => 'Effacer l\'historique';

  @override
  String get exportData => 'Exporter les données';

  @override
  String get skip => 'Passer';

  @override
  String get next => 'Suivant';

  @override
  String get getStarted => 'Commencer';

  @override
  String get continueText => 'Continuer';

  @override
  String get journalYourThoughts => 'Notez vos pensées';

  @override
  String get journalDescription =>
      'Exprimez-vous librement et suivez votre parcours émotionnel.';

  @override
  String get talkToAiCompanion => 'Parler au compagnon IA';

  @override
  String get talkToAiDescription =>
      'Discutez à tout moment avec un ami IA ou un thérapeute bienveillant.';

  @override
  String get trackYourProgress => 'Suivez vos progrès';

  @override
  String get trackProgressDescription =>
      'Comprenez vos schémas mentaux grâce aux analyses et évaluations.';

  @override
  String get chooseYourLanguage => 'Choisissez votre langue';

  @override
  String get languageDescription =>
      'Sélectionnez votre langue préférée pour l\'application. Vous pouvez la modifier plus tard dans les paramètres.';

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
  String get onDevice => 'Sur l\'appareil';

  @override
  String get cloud => 'Cloud';

  @override
  String get privateOnDevice => '100% sur l\'appareil';

  @override
  String get usingCloudAi => 'Utilisation de l\'IA Cloud';

  @override
  String get offlineMode => 'Mode hors ligne';

  @override
  String get aiReady => 'IA prête';

  @override
  String get nativeAi => 'IA native';

  @override
  String get demoMode => 'Mode démo';

  @override
  String get checkingModel => 'Vérification du modèle...';

  @override
  String get loadingAiModel => 'Chargement du modèle IA...';

  @override
  String get preparingModelForChat => 'Préparation du modèle pour le chat';

  @override
  String getModelForPrivateChat(String modelName) {
    return 'Obtenez le modèle $modelName pour un chat IA privé sur l\'appareil';
  }

  @override
  String get loadModel => 'Charger le modèle';

  @override
  String get aiModelReady => 'Modèle IA prêt';

  @override
  String get loadModelToStartChatting =>
      'Chargez le modèle pour commencer à discuter';

  @override
  String get deviceHasEnoughRam =>
      'Votre appareil a suffisamment de RAM pour les deux modèles';

  @override
  String wifiRecommended(String size) {
    return 'Wi-Fi recommandé. Taille du téléchargement : ~$size';
  }

  @override
  String get checkingModelStatus => 'Vérification du statut du modèle...';

  @override
  String get downloadFailed => 'Échec du téléchargement';

  @override
  String get retryDownload => 'Réessayer le téléchargement';

  @override
  String get keepAppOpen =>
      'Veuillez garder l\'application ouverte pendant le téléchargement';

  @override
  String get keepAppOpenDuringDownload =>
      'Veuillez garder l\'app ouverte pendant le téléchargement';

  @override
  String get switchText => 'Changer';

  @override
  String get change => 'Modifier';

  @override
  String get downloading => 'Téléchargement...';

  @override
  String get changeModel => 'Changer de modèle';

  @override
  String get errorOccurred =>
      'Désolé, un problème est survenu. Veuillez réessayer.';

  @override
  String get size => 'Taille';

  @override
  String get privacy => 'Confidentialité';

  @override
  String get downloadModelDescription =>
      'Téléchargez le modèle IA pour activer les conversations privées sur l\'appareil.';

  @override
  String get choosePreferredAiModel =>
      'Choisissez votre modèle d\'IA préféré pour des conversations privées sur l\'appareil.';

  @override
  String requiresWifiDownloadSize(String size) {
    return 'Wi-Fi recommandé. Taille du téléchargement: ~$size';
  }

  @override
  String get chooseModelDescription =>
      'Choisissez votre modèle IA préféré pour les conversations privées sur l\'appareil.';

  @override
  String get aboutYou => 'À propos de vous';

  @override
  String get helpPersonalizeExperience =>
      'Aidez-nous à personnaliser votre expérience';

  @override
  String get whatShouldWeCallYou => 'Comment devons-nous vous appeler ?';

  @override
  String get enterNameOrNickname => 'Entrez votre nom ou surnom';

  @override
  String get birthYear => 'Année de naissance';

  @override
  String get selectYear => 'Sélectionner l\'année';

  @override
  String get selectBirthYear => 'Sélectionner l\'année de naissance';

  @override
  String get gender => 'Genre';

  @override
  String get male => 'Homme';

  @override
  String get female => 'Femme';

  @override
  String get nonBinary => 'Non-binaire';

  @override
  String get preferNotToSay => 'Préfère ne pas dire';

  @override
  String get whatBringsYouHere => 'Qu\'est-ce qui vous amène ici ?';

  @override
  String get manageStress => 'Gérer le stress';

  @override
  String get trackMood => 'Suivre l\'humeur';

  @override
  String get buildHabits => 'Créer des habitudes';

  @override
  String get selfReflection => 'Auto-réflexion';

  @override
  String get justExploring => 'Juste explorer';

  @override
  String get howOftenJournal =>
      'À quelle fréquence souhaitez-vous tenir un journal ?';

  @override
  String get daily => 'Quotidien';

  @override
  String get fewTimesWeek => 'Quelques fois par semaine';

  @override
  String get weekly => 'Hebdomadaire';

  @override
  String get whenIFeelLikeIt => 'Quand j\'en ai envie';

  @override
  String get bestTimeForCheckIns =>
      'Quel moment convient le mieux pour les bilans ?';

  @override
  String get morning => 'Matin';

  @override
  String get afternoon => 'Après-midi';

  @override
  String get evening => 'Soir';

  @override
  String get flexible => 'Flexible';

  @override
  String questionOf(int current, int total) {
    return '$current sur $total';
  }

  @override
  String get chooseYourAi => 'Choisissez votre IA';

  @override
  String get selectHowToPowerAi =>
      'Sélectionnez comment alimenter votre assistant IA';

  @override
  String get onDeviceAi => 'IA sur l\'appareil';

  @override
  String get maximumPrivacy => 'Confidentialité maximale';

  @override
  String get onDeviceDescription =>
      'Fonctionne entièrement sur votre appareil. Vos données ne quittent jamais votre téléphone.';

  @override
  String get completePrivacy => 'Confidentialité complète';

  @override
  String get worksOffline => 'Fonctionne hors ligne';

  @override
  String get noSubscriptionNeeded => 'Pas d\'abonnement requis';

  @override
  String get requires2GBDownload => 'Nécessite ~2GB de téléchargement';

  @override
  String get usesDeviceResources => 'Utilise les ressources de l\'appareil';

  @override
  String get cloudAi => 'IA Cloud';

  @override
  String get morePowerful => 'Plus puissant';

  @override
  String get cloudDescription =>
      'Alimenté par des fournisseurs cloud pour des réponses plus rapides et intelligentes.';

  @override
  String get moreCapableModels => 'Modèles plus capables';

  @override
  String get fasterResponses => 'Réponses plus rapides';

  @override
  String get noStorageNeeded => 'Pas de stockage requis';

  @override
  String get requiresInternet => 'Nécessite Internet';

  @override
  String get dataSentToCloud => 'Données envoyées au cloud';

  @override
  String downloadingModel(int progress) {
    return 'Téléchargement du modèle... $progress%';
  }

  @override
  String settingUp(int progress) {
    return 'Configuration... $progress%';
  }

  @override
  String get setupFailed => 'La configuration a échoué. Veuillez réessayer.';

  @override
  String get insights => 'Perspectives';

  @override
  String get goodMorning => 'Bonjour';

  @override
  String get goodAfternoon => 'Bon après-midi';

  @override
  String get goodEvening => 'Bonsoir';

  @override
  String get howAreYouToday => 'Comment allez-vous aujourd\'hui?';

  @override
  String get moodGreat => 'Super';

  @override
  String get moodGood => 'Bien';

  @override
  String get moodOkay => 'Correct';

  @override
  String get moodLow => 'Pas très bien';

  @override
  String get moodSad => 'Triste';

  @override
  String get thisWeek => 'Cette semaine';

  @override
  String get upcomingAppointments => 'Rendez-vous à venir';

  @override
  String get avgMood => 'Humeur moy.';

  @override
  String get journalEntries => 'Entrées du journal';

  @override
  String get chatSessions => 'Sessions de chat';

  @override
  String get stressLevel => 'Niveau de stress';

  @override
  String get startYourStreak => 'Commencez votre série!';

  @override
  String get writeJournalToBegin => 'Écrivez une entrée pour commencer';

  @override
  String dayStreak(int count) {
    return 'Série de $count jours!';
  }

  @override
  String get amazingConsistency => 'Constance incroyable! Bien joué!';

  @override
  String get keepMomentumGoing => 'Gardez l\'élan';

  @override
  String get today => 'Aujourd\'hui';

  @override
  String get tomorrow => 'Demain';

  @override
  String get newEntry => 'Nouveau';

  @override
  String get noJournalEntriesYet => 'Pas encore d\'entrées';

  @override
  String get tapToCreateFirstEntry =>
      'Appuyez sur + pour créer votre première entrée';

  @override
  String get draft => 'Brouillon';

  @override
  String get finalized => 'Finalisé';

  @override
  String get getHelp => 'Obtenir de l\'aide';

  @override
  String get connectWithProfessionals =>
      'Connectez-vous avec des professionnels agréés';

  @override
  String get yourAppointments => 'Vos rendez-vous';

  @override
  String get inCrisis => 'En crise?';

  @override
  String get callEmergencyServices =>
      'Appelez les services d\'urgence immédiatement';

  @override
  String get call => 'Appeler';

  @override
  String get services => 'Services';

  @override
  String get resources => 'Ressources';

  @override
  String get therapistSession => 'Session de thérapeute';

  @override
  String get oneOnOneWithTherapist => 'Tête-à-tête avec un thérapeute agréé';

  @override
  String get mentalHealthConsultation => 'Consultation de santé mentale';

  @override
  String get generalWellnessGuidance => 'Conseils généraux de bien-être';

  @override
  String get articles => 'Articles';

  @override
  String get guidedMeditations => 'Méditations guidées';

  @override
  String get crisisHotlines => 'Lignes de crise';

  @override
  String get join => 'Rejoindre';

  @override
  String get trackMentalWellness =>
      'Suivez et comprenez votre bien-être mental';

  @override
  String get takeAssessment => 'Faire une évaluation';

  @override
  String get emotionalCheckIn => 'Bilan émotionnel';

  @override
  String get understandEmotionalState =>
      'Comprenez votre état émotionnel actuel';

  @override
  String get stressAssessment => 'Évaluation du stress';

  @override
  String get measureStressLevels => 'Mesurez vos niveaux de stress';

  @override
  String get recentResults => 'Résultats récents';

  @override
  String get checkIn => 'Bilan';

  @override
  String get cancel => 'Annuler';

  @override
  String nOfTotal(int current, int total) {
    return '$current sur $total';
  }

  @override
  String get emotionalWellbeing => 'Bien-être émotionnel';

  @override
  String get stressManagement => 'Gestion du stress';

  @override
  String get suggestions => 'Suggestions';

  @override
  String get done => 'Terminé';

  @override
  String get talkToProfessional => 'Parler à un professionnel';

  @override
  String get aiModel => 'Modèle d\'IA';

  @override
  String get pleaseWriteSomethingFirst =>
      'Veuillez d\'abord écrire quelque chose';

  @override
  String get useCloudAi => 'Utiliser l\'IA cloud?';

  @override
  String get aboutToSwitchToCloud =>
      'Vous êtes sur le point de passer à un fournisseur d\'IA cloud (Gemini)';

  @override
  String get cloudPrivacyWarning =>
      'Vos conversations seront envoyées aux serveurs de Google. Nous ne pouvons pas garantir la confidentialité de vos données lors de l\'utilisation de l\'IA cloud.';

  @override
  String get forMaxPrivacy =>
      'Pour une confidentialité maximale, utilisez l\'option IA sur l\'appareil';

  @override
  String get iUnderstand => 'Je comprends';

  @override
  String get switchedToCloudAi => 'Passé à l\'IA cloud (Gemini)';

  @override
  String get switchedToOnDeviceAi => 'Passé à l\'IA sur l\'appareil';

  @override
  String languageChangedTo(String language) {
    return 'Langue changée en $language';
  }

  @override
  String get clearHistoryQuestion => 'Effacer l\'historique?';

  @override
  String get clearHistoryWarning =>
      'Cela supprimera toutes vos données. Cette action ne peut pas être annulée.';

  @override
  String get clear => 'Effacer';

  @override
  String get historyCleared => 'Historique effacé';

  @override
  String get aboutAnchor => 'À propos d\'Anchor';

  @override
  String get privacyPolicy => 'Politique de confidentialité';

  @override
  String get helpAndSupport => 'Aide et support';

  @override
  String version(String version) {
    return 'Version $version';
  }

  @override
  String get yourWellnessCompanion => 'Votre compagnon de bien-être mental';

  @override
  String get system => 'Système';

  @override
  String get light => 'Clair';

  @override
  String get dark => 'Sombre';

  @override
  String get onDeviceProvider => 'Sur l\'appareil';

  @override
  String get privateRunsLocally => 'Privé, fonctionne localement';

  @override
  String get cloudGemini => 'Cloud (Gemini)';

  @override
  String get fasterRequiresInternet => 'Plus rapide, nécessite Internet';

  @override
  String get apiKeyNotConfigured => 'Clé API non configurée';

  @override
  String get about => 'À propos';

  @override
  String get findTherapist => 'Trouver un thérapeute';

  @override
  String get searchByNameOrSpecialty => 'Rechercher par nom ou spécialité...';

  @override
  String therapistsAvailable(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count thérapeutes disponibles',
      one: '$count thérapeute disponible',
    );
    return '$_temp0';
  }

  @override
  String get switchLabel => 'Changer';

  @override
  String changeModelTooltip(String modelName) {
    return 'Changer de modèle ($modelName)';
  }

  @override
  String get offline => 'Hors ligne';

  @override
  String get modelError => 'Erreur du modèle';

  @override
  String get cloudAiLabel => 'IA Cloud';

  @override
  String get usingCloudAiLabel => 'Utilisation de l\'IA cloud';

  @override
  String get from => 'À partir de';

  @override
  String get perSession => '/session';

  @override
  String get unavailable => 'Non disponible';

  @override
  String get bookSession => 'Réserver une session';

  @override
  String get viewProfile => 'Voir le profil';

  @override
  String get pleaseSelectTime => 'Veuillez sélectionner une heure';

  @override
  String get date => 'Date';

  @override
  String get time => 'Heure';

  @override
  String get urgency => 'Urgence';

  @override
  String get normal => 'Normal';

  @override
  String get regularScheduling => 'Planification régulière';

  @override
  String get urgent => 'Urgent';

  @override
  String get priority => 'Priorité (+\$20)';

  @override
  String get checkout => 'Paiement';

  @override
  String get summary => 'Résumé';

  @override
  String get type => 'Type';

  @override
  String get price => 'Prix';

  @override
  String get session => 'Session';

  @override
  String get urgencyFee => 'Frais d\'urgence';

  @override
  String get total => 'Total';

  @override
  String get testModeMessage =>
      'Mode test: Utilise des montants de \$1 sur le testnet Sepolia';

  @override
  String get freeCancellation =>
      'Annulation gratuite jusqu\'à 24 heures avant le rendez-vous';

  @override
  String payAmount(int amount) {
    return 'Payer \$$amount';
  }

  @override
  String get payment => 'Paiement';

  @override
  String get paymentMethod => 'Mode de paiement';

  @override
  String get creditDebitCard => 'Carte de crédit / débit';

  @override
  String get visaMastercardAmex => 'Visa, Mastercard, Amex';

  @override
  String get payWithPaypal => 'Payez avec votre compte PayPal';

  @override
  String get cardNumber => 'Numéro de carte';

  @override
  String get walletConnected => 'Portefeuille connecté';

  @override
  String get securedByBlockchain => 'Sécurisé par blockchain';

  @override
  String get securePayment => 'Paiement sécurisé';

  @override
  String get connectWalletToPay => 'Connecter le portefeuille pour payer';

  @override
  String reviewsCount(int count) {
    return '$count avis';
  }

  @override
  String get perSessionLabel => 'par session';

  @override
  String get minutes => 'minutes';

  @override
  String get available => 'Disponible';

  @override
  String get currentlyUnavailable => 'Actuellement non disponible';

  @override
  String nextSlot(String time) {
    return 'Prochain créneau: $time';
  }

  @override
  String get specializations => 'Spécialisations';

  @override
  String get languages => 'Langues';

  @override
  String get reviews => 'Avis';

  @override
  String get seeAll => 'Voir tout';

  @override
  String bookSessionWithPrice(int price) {
    return 'Réserver une session - \$$price';
  }

  @override
  String get unsavedChanges => 'Modifications non enregistrées';

  @override
  String get whatsOnYourMind => 'Qu\'avez-vous en tête?';

  @override
  String get analyzingEntry => 'Analyse de votre entrée...';

  @override
  String get finalizing => 'Finalisation...';

  @override
  String get thisMayTakeAMoment => 'Cela peut prendre un moment';

  @override
  String get aiGeneratingInsights => 'L\'IA génère des perspectives';

  @override
  String get pleaseWriteSomething => 'Veuillez d\'abord écrire quelque chose';

  @override
  String failedToSave(String error) {
    return 'Échec de l\'enregistrement: $error';
  }

  @override
  String failedToFinalize(String error) {
    return 'Échec de la finalisation: $error';
  }

  @override
  String get whatWouldYouLikeToDo => 'Que souhaitez-vous faire?';

  @override
  String get saveAsDraft => 'Enregistrer comme brouillon';

  @override
  String get keepEditingForDays => 'Continuer à éditer pendant 3 jours';

  @override
  String get finalizeWithAi => 'Finaliser avec l\'IA';

  @override
  String get finalizeWithCloudAi => 'Finaliser avec l\'IA cloud';

  @override
  String get finalizeEntry => 'Finaliser l\'entrée';

  @override
  String get getSummaryAndAnalysisGemini =>
      'Obtenir un résumé et une analyse (utilise Gemini)';

  @override
  String get getSummaryEmotionRisk =>
      'Obtenir un résumé, une analyse émotionnelle et une évaluation des risques';

  @override
  String get lockEntryAndStopEditing =>
      'Verrouiller l\'entrée et arrêter l\'édition';

  @override
  String get entryFinalized => 'Entrée finalisée';

  @override
  String get entrySaved => 'Entrée enregistrée';

  @override
  String get entryAnalyzed => 'Votre entrée de journal a été analysée';

  @override
  String get draftSaved => 'Brouillon enregistré';

  @override
  String get riskAssessment => 'Évaluation des risques';

  @override
  String get emotionalState => 'État émotionnel';

  @override
  String get aiSummary => 'Résumé IA';

  @override
  String get suggestedActions => 'Actions suggérées';

  @override
  String get draftMode => 'Mode brouillon';

  @override
  String get draftModeDescription =>
      'Vous pouvez continuer à éditer cette entrée pendant 3 jours. Quand vous êtes prêt, finalisez-la pour obtenir des perspectives IA.';

  @override
  String get storedOnEthStorage => 'Stocké sur EthStorage';

  @override
  String get ethStorageConfigRequired => 'Configuration EthStorage requise';

  @override
  String get retry => 'Réessayer';

  @override
  String get view => 'Voir';

  @override
  String get uploadingToEthStorage => 'Téléversement vers EthStorage...';

  @override
  String get storeOnEthStorage => 'Stocker sur EthStorage (Testnet)';

  @override
  String get successfullyUploaded => 'Téléversé avec succès sur EthStorage!';

  @override
  String couldNotOpenBrowser(String url) {
    return 'Impossible d\'ouvrir le navigateur. URL: $url';
  }

  @override
  String errorOpeningUrl(String error) {
    return 'Erreur lors de l\'ouverture de l\'URL: $error';
  }

  @override
  String get riskHighDesc =>
      'Envisagez de contacter un professionnel de la santé mentale';

  @override
  String get riskMediumDesc =>
      'Certaines préoccupations détectées - surveillez votre bien-être';

  @override
  String get riskLowDesc => 'Aucune préoccupation significative détectée';

  @override
  String get booked => 'Réservé!';

  @override
  String sessionConfirmed(String therapistName) {
    return 'Votre session avec $therapistName est confirmée';
  }

  @override
  String get tbd => 'À déterminer';

  @override
  String get paidWithDigitalWallet => 'Payé avec portefeuille numérique';

  @override
  String get viewMyAppointments => 'Voir mes rendez-vous';

  @override
  String paymentFailed(String error) {
    return 'Échec du paiement: $error';
  }

  @override
  String failedToConnectWallet(String error) {
    return 'Échec de connexion du portefeuille: $error';
  }

  @override
  String get connectWallet => 'Connecter le portefeuille';

  @override
  String get disconnect => 'Déconnecter';

  @override
  String get viewOnEtherscan => 'Voir sur Etherscan';

  @override
  String get continueButton => 'Continuer';

  @override
  String get seeResults => 'Voir les résultats';

  @override
  String get originalEntry => 'Entrée originale';

  @override
  String get storedOnBlockchain => 'Stocké sur la blockchain';

  @override
  String get stressLow => 'Faible';

  @override
  String get stressMedium => 'Moyen';

  @override
  String get stressHigh => 'Élevé';

  @override
  String get stressUnknown => 'Inconnu';

  @override
  String get trendNew => 'Nouveau';

  @override
  String get trendStable => 'Stable';

  @override
  String get trendImproved => 'Amélioré';

  @override
  String get trendWorsened => 'Dégradé';

  @override
  String get pleaseSelectSepoliaNetwork =>
      'Veuillez passer au réseau de test Sepolia dans votre portefeuille';

  @override
  String get switchNetwork => 'Changer de réseau';

  @override
  String get unlockAnchor => 'Déverrouiller Anchor';

  @override
  String get enterYourPin => 'Entrez votre PIN';

  @override
  String get enterPinToUnlock =>
      'Entrez votre PIN pour déverrouiller l\'application';

  @override
  String get incorrectPin => 'PIN incorrect';

  @override
  String incorrectPinAttempts(int attempts) {
    return 'PIN incorrect. $attempts tentatives restantes';
  }

  @override
  String tooManyAttempts(int seconds) {
    return 'Trop de tentatives. Réessayez dans $seconds secondes';
  }

  @override
  String get setUpAppLock => 'Configurer le verrouillage de l\'app';

  @override
  String get changePin => 'Changer le PIN';

  @override
  String get disableAppLock => 'Désactiver le verrouillage de l\'app';

  @override
  String get enterCurrentPin => 'Entrez le PIN actuel';

  @override
  String get createNewPin => 'Créer un nouveau PIN';

  @override
  String get confirmYourPin => 'Confirmez votre PIN';

  @override
  String get enterPinToDisableLock =>
      'Entrez votre PIN pour désactiver le verrouillage de l\'app';

  @override
  String get enterCurrentPinToContinue =>
      'Entrez votre PIN actuel pour continuer';

  @override
  String get choosePinDigits => 'Choisissez un PIN à 4 chiffres';

  @override
  String get reenterPinToConfirm => 'Entrez à nouveau votre PIN pour confirmer';

  @override
  String get pinMustBeDigits => 'Le PIN doit contenir au moins 4 chiffres';

  @override
  String get pinsDoNotMatch => 'Les PINs ne correspondent pas. Réessayez';

  @override
  String get failedToSetPin =>
      'Échec de la définition du PIN. Veuillez réessayer';

  @override
  String get appLockEnabled => 'Verrouillage de l\'app activé';

  @override
  String get appLockDisabled => 'Verrouillage de l\'app désactivé';

  @override
  String get pinChanged => 'PIN modifié avec succès';

  @override
  String useBiometrics(String biometricType) {
    return 'Utiliser $biometricType';
  }

  @override
  String unlockWithBiometrics(String biometricType) {
    return 'Déverrouiller avec $biometricType pour un accès plus rapide';
  }

  @override
  String get lockWhenLeaving => 'Verrouiller en quittant l\'app';

  @override
  String get lockWhenLeavingSubtitle => 'Exiger le PIN lors du retour à l\'app';

  @override
  String get changePinCode => 'Changer le code PIN';

  @override
  String get removeAppLock => 'Supprimer le verrouillage de l\'app';

  @override
  String get appLockSettings => 'Paramètres de verrouillage de l\'app';

  @override
  String get protectYourPrivacy => 'Protégez votre vie privée avec un code PIN';
}
