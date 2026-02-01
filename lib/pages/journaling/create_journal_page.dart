import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../services/ai_settings_service.dart';
import '../../services/database_service.dart';
import '../../services/gemini_service.dart';
import '../../services/llm_service.dart';
import '../../services/model_download_service.dart';
import '../../utils/responsive.dart';
import 'journal_summary_page.dart';

class CreateJournalPage extends StatefulWidget {
  final JournalEntry? entry; // If provided, we're editing an existing entry

  const CreateJournalPage({super.key, this.entry});

  @override
  State<CreateJournalPage> createState() => _CreateJournalPageState();
}

class _CreateJournalPageState extends State<CreateJournalPage> {
  final _contentController = TextEditingController();
  final _contentFocus = FocusNode();
  final _databaseService = DatabaseService();
  final _llmService = LlmService();
  final _aiSettings = AiSettingsService();
  final _geminiService = GeminiService();

  String _selectedMood = '😊';
  bool _isSaving = false;
  bool _isAnalyzing = false;
  bool _hasUnsavedChanges = false;
  int? _entryId; // Track the entry ID for auto-saving
  Timer? _autoSaveTimer;

  bool get _isEditing => widget.entry != null;

  final List<String> _moods = [
    '😊',
    '🙂',
    '😌',
    '😐',
    '😔',
    '😢',
    '😤',
    '🤔',
    '💪',
    '🙏',
  ];

  @override
  void initState() {
    super.initState();
    // Pre-populate fields if editing
    if (widget.entry != null) {
      _contentController.text = widget.entry!.content;
      _selectedMood = widget.entry!.mood;
      _entryId = widget.entry!.id;
    }

    // Listen for changes to trigger auto-save
    _contentController.addListener(_onContentChanged);

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _contentFocus.requestFocus();
      }
    });
  }

  void _onContentChanged() {
    if (!_hasUnsavedChanges) {
      setState(() => _hasUnsavedChanges = true);
    }

    // Debounce auto-save
    _autoSaveTimer?.cancel();
    _autoSaveTimer = Timer(const Duration(seconds: 2), _autoSaveDraft);
  }

  @override
  void dispose() {
    _autoSaveTimer?.cancel();
    _contentController.removeListener(_onContentChanged);
    _contentController.dispose();
    _contentFocus.dispose();
    super.dispose();
  }

  /// Auto-save draft without AI analysis
  Future<void> _autoSaveDraft() async {
    if (_contentController.text.trim().isEmpty) return;
    if (_isSaving || _isAnalyzing) return;

    try {
      if (_entryId != null) {
        // Update existing draft
        final updatedEntry = JournalEntry(
          id: _entryId,
          content: _contentController.text.trim(),
          mood: _selectedMood,
          createdAt: widget.entry?.createdAt ?? DateTime.now(),
        );
        await _databaseService.updateJournalEntry(updatedEntry);
      } else {
        // Create new draft
        final newEntry = JournalEntry(
          content: _contentController.text.trim(),
          mood: _selectedMood,
        );
        _entryId = await _databaseService.insertJournalEntry(newEntry);
      }

      if (mounted) {
        setState(() => _hasUnsavedChanges = false);
      }
      debugPrint('Auto-saved draft with id $_entryId');
    } catch (e) {
      debugPrint('Error auto-saving draft: $e');
    }
  }

  /// Handle back button - save draft if there are changes
  Future<bool> _onWillPop() async {
    if (_hasUnsavedChanges && _contentController.text.trim().isNotEmpty) {
      await _autoSaveDraft();
    }
    return true;
  }

  /// Show options: Save as draft or Finalize with AI
  void _showSaveOptions() {
    if (_contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.pleaseWriteSomething),
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        // Check if AI is available (either loaded or downloadable)
        final downloadService = ModelDownloadService();
        return FutureBuilder<bool>(
          future: downloadService.isModelDownloaded(),
          builder: (context, snapshot) {
            final isDownloaded = snapshot.data ?? false;
            // AI is available if: cloud provider is configured OR on-device model is ready/downloaded
            // Also available as fallback: on-device selected but Gemini is configured
            final isCloudReady =
                _aiSettings.isCloudProvider && _geminiService.isConfigured;
            final isOnDeviceReady = _llmService.hasRealAI || isDownloaded;
            final canFallbackToGemini =
                !isOnDeviceReady && _geminiService.isConfigured;
            final isAiAvailable =
                isCloudReady || isOnDeviceReady || canFallbackToGemini;
            return _SaveOptionsSheet(
              isEditing: _isEditing,
              isAiAvailable: isAiAvailable,
              isCloudProvider: isCloudReady || canFallbackToGemini,
              onSaveDraft: _saveDraftAndClose,
              onFinalize: _finalizeWithAI,
            );
          },
        );
      },
    );
  }

  /// Save as draft and close
  Future<void> _saveDraftAndClose() async {
    Navigator.pop(context); // Close bottom sheet

    if (_isSaving) return;
    setState(() => _isSaving = true);

    try {
      await _autoSaveDraft();
      if (mounted) {
        Navigator.pop(context, true); // Return to journal list
      }
    } catch (e) {
      debugPrint('Error saving draft: $e');
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.failedToSave(e.toString()),
            ),
          ),
        );
      }
    }
  }

  /// Finalize the entry (with AI analysis if model is available)
  Future<void> _finalizeWithAI() async {
    Navigator.pop(context); // Close bottom sheet

    if (_isAnalyzing) return;

    try {
      // First ensure the entry is saved BEFORE setting _isAnalyzing
      // (because _autoSaveDraft checks _isAnalyzing and returns early if true)
      if (_entryId == null && _contentController.text.trim().isNotEmpty) {
        final newEntry = JournalEntry(
          content: _contentController.text.trim(),
          mood: _selectedMood,
        );
        _entryId = await _databaseService.insertJournalEntry(newEntry);
        debugPrint('Created entry with id $_entryId before finalizing');
      } else if (_entryId != null) {
        // Update existing draft
        final updatedEntry = JournalEntry(
          id: _entryId,
          content: _contentController.text.trim(),
          mood: _selectedMood,
          createdAt: widget.entry?.createdAt ?? DateTime.now(),
        );
        await _databaseService.updateJournalEntry(updatedEntry);
        debugPrint('Updated entry $_entryId before finalizing');
      }

      if (_entryId == null) {
        throw Exception('Failed to save entry before finalizing');
      }

      setState(() => _isAnalyzing = true);

      final content = _contentController.text.trim();
      _AnalysisResult? analysisResult;

      // Initialize AI settings
      await _aiSettings.initialize();

      // Check if using cloud provider
      if (_aiSettings.isCloudProvider && _geminiService.isConfigured) {
        debugPrint('Running AI analysis with Gemini cloud provider');
        analysisResult = await _analyzeJournalEntryWithGemini(content);
      } else {
        // Try to load model if it's downloaded but not loaded
        if (!_llmService.hasRealAI && !_llmService.isLoading) {
          final downloadService = ModelDownloadService();
          await downloadService.initialize();
          if (downloadService.isDownloaded) {
            debugPrint('Model downloaded but not loaded, loading now...');
            await _llmService.loadModel();
          }
        }

        // Only run AI analysis if real AI model is available (not mock)
        if (_llmService.hasRealAI) {
          debugPrint(
            'Running AI analysis with backend: ${_llmService.activeBackend}',
          );
          analysisResult = await _analyzeJournalEntry(content);
        } else {
          // Fallback to Gemini if on-device model not available but Gemini is configured
          if (_geminiService.isConfigured) {
            debugPrint(
              'On-device AI not available, falling back to Gemini cloud',
            );
            analysisResult = await _analyzeJournalEntryWithGemini(content);
          } else {
            debugPrint(
              'AI not available - backend: ${_llmService.activeBackend}, status: ${_llmService.status}',
            );
          }
        }
      }

      // Finalize the entry (with or without AI results)
      if (analysisResult != null) {
        await _databaseService.finalizeJournalEntry(
          id: _entryId!,
          summary: analysisResult.summary,
          emotionStatus: analysisResult.emotionStatus,
          actionItems: analysisResult.actionItems,
          riskStatus: analysisResult.riskStatus,
        );
      } else {
        // Just lock the entry without AI analysis
        await _databaseService.lockJournalEntry(_entryId!);
      }

      if (mounted) {
        // Navigate to summary page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => JournalSummaryPage(
              returnResult: true,
              entryId: _entryId,
              summary: analysisResult?.summary,
              emotionStatus: analysisResult?.emotionStatus,
              actionItems: analysisResult?.actionItems,
              riskStatus: analysisResult?.riskStatus,
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error finalizing entry: $e');
      if (mounted) {
        setState(() => _isAnalyzing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.failedToFinalize(e.toString()),
            ),
          ),
        );
      }
    }
  }

  /// Run AI analysis on journal content (only called when model is ready)
  Future<_AnalysisResult?> _analyzeJournalEntry(String content) async {
    final prompt =
        '''You are analyzing a journal entry. Respond ONLY with a JSON object, no other text.

Journal entry to analyze:
"$content"

Provide your analysis as JSON with these fields:
- summary: A 2-3 sentence summary of what the person is experiencing
- emotion: The primary emotion (one word: Happy, Sad, Anxious, Grateful, Reflective, Frustrated, Hopeful, Overwhelmed, Peaceful, or Motivated)
- risk: Mental health risk level (low, medium, or high)
- actions: Array of 2-3 helpful SUGGESTIONS for the person (like "Try deep breathing exercises", "Consider talking to a friend", "Take a short walk outdoors"). These must be actionable recommendations, NOT quotes from the entry.

JSON format:
{"summary": "...", "emotion": "...", "risk": "...", "actions": ["suggestion 1", "suggestion 2"]}''';

    try {
      final response = await _llmService.generateResponse(
        prompt: prompt,
        mode: 'therapist',
        maxTokens: 300,
        temperature: 0.7,
      );

      return _parseAnalysisResponse(response);
    } catch (e) {
      debugPrint('Error running AI analysis: $e');
      return null;
    }
  }

  /// Run AI analysis using Gemini cloud service
  Future<_AnalysisResult?> _analyzeJournalEntryWithGemini(
    String content,
  ) async {
    try {
      final result = await _geminiService.analyzeJournalEntry(content);
      if (result != null) {
        final summary = (result['summary'] as String?)?.trim() ?? '';
        final emotion = (result['emotion'] as String?)?.trim() ?? 'Reflective';
        final risk = (result['risk'] as String?)?.trim() ?? 'low';
        final actionsRaw = result['actions'];
        List<String> actions = [];
        if (actionsRaw is List) {
          actions = actionsRaw.map((e) => e.toString().trim()).toList();
        }

        if (summary.isNotEmpty) {
          return _AnalysisResult(
            summary: summary,
            emotionStatus: emotion,
            actionItems: actions.isEmpty
                ? ['Reflect on your feelings', 'Practice self-care']
                : actions,
            riskStatus: _normalizeRiskStatus(risk),
          );
        }
      }
      return null;
    } catch (e) {
      debugPrint('Error running Gemini analysis: $e');
      return null;
    }
  }

  _AnalysisResult? _parseAnalysisResponse(String response) {
    // Try to parse as JSON first
    try {
      // Extract JSON from response (model might include extra text)
      // Use a more permissive regex that can handle nested arrays
      final jsonMatch = RegExp(
        r'\{[^{}]*(?:\[[^\]]*\][^{}]*)*\}',
        dotAll: true,
      ).firstMatch(response);
      if (jsonMatch != null) {
        var jsonStr = jsonMatch.group(0)!;

        // Normalize keys by removing leading/trailing spaces inside quotes
        // This handles cases like {" summary": ...} -> {"summary": ...}
        jsonStr = jsonStr.replaceAllMapped(
          RegExp(r'"\s*([^"]+?)\s*"\s*:'),
          (match) => '"${match.group(1)!.trim()}":',
        );

        debugPrint('Normalized JSON: $jsonStr');
        final json = jsonDecode(jsonStr) as Map<String, dynamic>;

        final summary = (json['summary'] as String?)?.trim() ?? '';
        final emotion = (json['emotion'] as String?)?.trim() ?? 'Reflective';
        final risk = (json['risk'] as String?)?.trim() ?? 'low';
        final actionsRaw = json['actions'];
        List<String> actions = [];
        if (actionsRaw is List) {
          actions = actionsRaw.map((e) => e.toString().trim()).toList();
        }

        if (summary.isNotEmpty) {
          return _AnalysisResult(
            summary: summary,
            emotionStatus: emotion,
            actionItems: actions.isEmpty
                ? ['Reflect on your feelings', 'Practice self-care']
                : actions,
            riskStatus: _normalizeRiskStatus(risk),
          );
        }
      }
    } catch (e) {
      debugPrint('JSON parsing failed, trying fallback: $e');
    }

    // Fallback to text parsing
    String summary = '';
    String emotion = 'Reflective';
    String risk = 'low';
    List<String> actions = [];

    final lines = response.split('\n');
    bool inActions = false;

    for (final line in lines) {
      final trimmed = line.trim();

      if (trimmed.startsWith('SUMMARY:')) {
        summary = trimmed.substring(8).trim();
      } else if (trimmed.startsWith('EMOTION:')) {
        emotion = trimmed.substring(8).trim();
      } else if (trimmed.startsWith('RISK:')) {
        risk = trimmed.substring(5).trim();
      } else if (trimmed.startsWith('ACTIONS:')) {
        inActions = true;
      } else if (inActions && trimmed.startsWith('-')) {
        actions.add(trimmed.substring(1).trim());
      }
    }

    // Fallback if parsing failed
    if (summary.isEmpty) {
      summary = response.length > 200
          ? '${response.substring(0, 197)}...'
          : response;
    }

    return _AnalysisResult(
      summary: summary,
      emotionStatus: emotion,
      actionItems: actions.isEmpty
          ? ['Reflect on your feelings', 'Practice self-care']
          : actions,
      riskStatus: _normalizeRiskStatus(risk),
    );
  }

  String _normalizeRiskStatus(String risk) {
    final normalized = risk.toLowerCase().trim();
    if (normalized.contains('high')) return 'high';
    if (normalized.contains('medium')) return 'medium';
    return 'low';
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isAnalyzing,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop && !_isAnalyzing) {
          await _onWillPop();
          if (context.mounted) {
            Navigator.pop(context, _entryId != null);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: _isAnalyzing
                ? null
                : () async {
                    await _onWillPop();
                    if (context.mounted) {
                      Navigator.pop(context, _entryId != null);
                    }
                  },
            icon: const Icon(Icons.close_rounded),
          ),
          title: _hasUnsavedChanges
              ? Text(
                  AppLocalizations.of(context)!.unsavedChanges,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                )
              : null,
          actions: [
            if (!_isAnalyzing)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilledButton(
                  onPressed: _showSaveOptions,
                  style: FilledButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                  ),
                  child: Text(AppLocalizations.of(context)!.done),
                ),
              ),
          ],
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: ResponsiveCenter(
                maxWidth: 600,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    // Mood selector
                    SizedBox(
                      height: 56,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _moods.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final mood = _moods[index];
                          final isSelected = _selectedMood == mood;
                          return GestureDetector(
                            onTap: _isAnalyzing
                                ? null
                                : () {
                                    setState(() {
                                      _selectedMood = mood;
                                      _hasUnsavedChanges = true;
                                    });
                                  },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Theme.of(
                                        context,
                                      ).colorScheme.primaryContainer
                                    : Theme.of(
                                        context,
                                      ).colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(12),
                                border: isSelected
                                    ? Border.all(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                        width: 2,
                                      )
                                    : null,
                              ),
                              child: Text(
                                mood,
                                style: const TextStyle(fontSize: 24),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Content input
                    TextField(
                      controller: _contentController,
                      focusNode: _contentFocus,
                      maxLines: null,
                      minLines: 15,
                      enabled: !_isAnalyzing,
                      keyboardType: TextInputType.multiline,
                      textCapitalization: TextCapitalization.sentences,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(height: 1.6),
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.whatsOnYourMind,
                        hintStyle: TextStyle(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurfaceVariant.withOpacity(0.5),
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        filled: false,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Loading overlay during finalization
            if (_isAnalyzing)
              Container(
                color: Theme.of(
                  context,
                ).scaffoldBackgroundColor.withOpacity(0.8),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 24),
                      Text(
                        _llmService.isLoading
                            ? AppLocalizations.of(context)!.loadingAiModel
                            : _llmService.hasRealAI
                            ? AppLocalizations.of(context)!.analyzingEntry
                            : AppLocalizations.of(context)!.finalizing,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      if (_llmService.hasRealAI || _llmService.isLoading) ...[
                        const SizedBox(height: 8),
                        Text(
                          _llmService.isLoading
                              ? AppLocalizations.of(context)!.thisMayTakeAMoment
                              : AppLocalizations.of(
                                  context,
                                )!.aiGeneratingInsights,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _AnalysisResult {
  final String summary;
  final String emotionStatus;
  final List<String> actionItems;
  final String riskStatus;

  _AnalysisResult({
    required this.summary,
    required this.emotionStatus,
    required this.actionItems,
    required this.riskStatus,
  });
}

class _SaveOptionsSheet extends StatelessWidget {
  final bool isEditing;
  final bool isAiAvailable;
  final bool isCloudProvider;
  final VoidCallback onSaveDraft;
  final VoidCallback onFinalize;

  const _SaveOptionsSheet({
    required this.isEditing,
    required this.isAiAvailable,
    this.isCloudProvider = false,
    required this.onSaveDraft,
    required this.onFinalize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),

            Text(
              AppLocalizations.of(context)!.whatWouldYouLikeToDo,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 24),

            // Save as Draft option
            _OptionCard(
              icon: Icons.edit_note_rounded,
              iconColor: Theme.of(context).colorScheme.primary,
              title: AppLocalizations.of(context)!.saveAsDraft,
              description: AppLocalizations.of(context)!.keepEditingForDays,
              onTap: onSaveDraft,
            ),

            const SizedBox(height: 12),

            // Finalize option (with AI if available)
            _OptionCard(
              icon: isAiAvailable
                  ? (isCloudProvider
                        ? Icons.cloud_rounded
                        : Icons.auto_awesome_rounded)
                  : Icons.lock_rounded,
              iconColor: isAiAvailable
                  ? (isCloudProvider ? Colors.blue : Colors.amber)
                  : Colors.green,
              title: isAiAvailable
                  ? (isCloudProvider
                        ? AppLocalizations.of(context)!.finalizeWithCloudAi
                        : AppLocalizations.of(context)!.finalizeWithAi)
                  : AppLocalizations.of(context)!.finalizeEntry,
              description: isAiAvailable
                  ? (isCloudProvider
                        ? AppLocalizations.of(
                            context,
                          )!.getSummaryAndAnalysisGemini
                        : AppLocalizations.of(context)!.getSummaryEmotionRisk)
                  : AppLocalizations.of(context)!.lockEntryAndStopEditing,
              onTap: onFinalize,
              highlighted: true,
            ),

            const SizedBox(height: 16),

            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;
  final VoidCallback onTap;
  final bool highlighted;

  const _OptionCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
    required this.onTap,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: highlighted
          ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3)
          : Theme.of(context).colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
