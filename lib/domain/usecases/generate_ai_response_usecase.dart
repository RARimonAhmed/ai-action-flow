import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/ai_prompt_entity.dart';
import '../entities/ai_response_entity.dart';
import '../repositories/ai_repository.dart';

class GenerateAIResponseUseCase {
  final AIRepository repository;

  GenerateAIResponseUseCase(this.repository);

  Future<Either> call({
    required String selectedText,
    required AIPromptEntity prompt,
    String? customInstruction,
  }) async {
    // Validation
    if (selectedText.trim().isEmpty) {
      return const Left(
        ValidationFailure('Selected text cannot be empty'),
      );
    }

    if (selectedText.length < 3) {
      return const Left(
        ValidationFailure('Selected text is too short (minimum 3 characters)'),
      );
    }

    if (selectedText.length > 5000) {
      return const Left(
        ValidationFailure('Selected text is too long (maximum 5000 characters)'),
      );
    }

    return await repository.generateAIResponse(
      selectedText: selectedText,
      prompt: prompt,
      customInstruction: customInstruction,
    );
  }
}