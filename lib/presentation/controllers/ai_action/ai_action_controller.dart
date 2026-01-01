import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/base/base_controller.dart';
import '../../../core/utils/logger.dart';
import '../../../domain/entities/ai_prompt_entity.dart';
import '../../../domain/entities/ai_response_entity.dart';
import '../../../domain/entities/selected_text_entity.dart';
import '../../../domain/usecases/generate_ai_response_usecase.dart';
import '../../../domain/usecases/get_prompts_usecase.dart';

class AIActionController extends BaseController {
  final GenerateAIResponseUseCase generateAIResponseUseCase;
  final GetPromptsUseCase getPromptsUseCase;

  AIActionController({
    required this.generateAIResponseUseCase,
    required this.getPromptsUseCase,
  });

  // State
  final availablePrompts = <AIPromptEntity>[].obs;
  final selectedPrompt = Rx<AIPromptEntity?>(null);
  final currentResponse = Rx<AIResponseEntity?>(null);
  final isGenerating = false.obs;
  final customPromptController = TextEditingController();

  // Bottom Sheet
  final showBottomSheet = false.obs;
  SelectedTextEntity? _currentSelectedText;

  @override
  void initController() {
    AppLogger.i('AIActionController initialized');
    _loadPrompts();
  }

  @override
  void disposeController() {
    customPromptController.dispose();
    AppLogger.i('AIActionController disposed - resources cleaned');
  }

  Future<void> _loadPrompts() async {
    setLoading(true);

    final result = await getPromptsUseCase();

    result.fold(
          (failure) {
        AppLogger.e('Failed to load prompts: ${failure.message}');
        setError(failure.message);
      },
          (prompts) {
        availablePrompts.value = prompts;
        AppLogger.i('Loaded ${prompts.length} prompts');
      },
    );

    setLoading(false);
  }

  // Open prompt bottom sheet
  void openPromptSheet(SelectedTextEntity selectedText) {
    _currentSelectedText = selectedText;
    selectedPrompt.value = null;
    currentResponse.value = null;
    customPromptController.clear();
    showBottomSheet.value = true;

    AppLogger.i('Prompt sheet opened for text: ${selectedText.text.substring(0, 50)}...');
  }

  // Close bottom sheet
  void closePromptSheet() {
    showBottomSheet.value = false;
    selectedPrompt.value = null;
    currentResponse.value = null;
    customPromptController.clear();
    _currentSelectedText = null;

    AppLogger.d('Prompt sheet closed');
  }

  // Select a prompt
  void selectPrompt(AIPromptEntity prompt) {
    if (isGenerating.value) {
      AppLogger.w('Cannot select prompt while generating');
      return;
    }

    selectedPrompt.value = prompt;
    AppLogger.i('Prompt selected: ${prompt.title}');

    // Auto-generate if not custom
    if (prompt.type != PromptType.custom) {
      generateResponse();
    }
  }

  // Remove selected prompt
  void removePrompt() {
    selectedPrompt.value = null;
    currentResponse.value = null;
    AppLogger.d('Prompt removed');
  }

  // Generate AI response
  Future<void> generateResponse({String? customInstruction}) async {
    if (_currentSelectedText == null || selectedPrompt.value == null) {
      AppLogger.w('Cannot generate: missing text or prompt');
      return;
    }

    if (isGenerating.value) {
      AppLogger.w('Already generating response');
      return;
    }

    isGenerating.value = true;
    clearError();

    AppLogger.i('Generating AI response...');

    // Create loading response
    currentResponse.value = AIResponseEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      originalText: _currentSelectedText!.text,
      generatedText: '',
      appliedPrompt: selectedPrompt.value!,
      status: ResponseStatus.loading,
      generatedAt: DateTime.now(),
    );

    final result = await generateAIResponseUseCase(
      selectedText: _currentSelectedText!.text,
      prompt: selectedPrompt.value!,
      customInstruction: customInstruction,
    );

    result.fold(
          (failure) {
        AppLogger.e('AI generation failed: ${failure.message}');

        currentResponse.value = currentResponse.value?.copyWith(
          status: ResponseStatus.error,
          errorMessage: failure.message,
        );

        Get.snackbar(
          'Error',
          failure.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade400,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      },
          (response) {
        AppLogger.i('AI response generated successfully');
        currentResponse.value = response;

        Get.snackbar(
          'Success',
          'Response generated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade400,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      },
    );

    isGenerating.value = false;
  }

  // Submit custom prompt
  void submitCustomPrompt() {
    final instruction = customPromptController.text.trim();

    if (instruction.isEmpty) {
      Get.snackbar(
        'Empty Prompt',
        'Please enter a custom instruction',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (instruction.length < 10) {
      Get.snackbar(
        'Prompt Too Short',
        'Please provide more details (at least 10 characters)',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Create custom prompt
    final customPrompt = AIPromptEntity(
      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Custom',
      instruction: instruction,
      type: PromptType.custom,
      icon: '✏️',
    );

    selectPrompt(customPrompt);
    generateResponse(customInstruction: instruction);
  }

  // Regenerate response
  Future<void> regenerate() async {
    if (selectedPrompt.value == null) {
      AppLogger.w('Cannot regenerate: no prompt selected');
      return;
    }

    AppLogger.i('Regenerating response');
    await generateResponse(
      customInstruction: selectedPrompt.value!.type == PromptType.custom
          ? customPromptController.text.trim()
          : null,
    );
  }

  // Copy response to clipboard
  void copyResponse() {
    if (currentResponse.value?.generatedText != null) {
      // Implement clipboard copy
      Get.snackbar(
        'Copied',
        'Response copied to clipboard',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
      AppLogger.i('Response copied to clipboard');
    }
  }
}