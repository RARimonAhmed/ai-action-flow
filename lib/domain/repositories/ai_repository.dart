import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/ai_prompt_entity.dart';
import '../entities/ai_response_entity.dart';

abstract class AIRepository {
  Future<Either>> getAvailablePrompts();

  Future<Either> generateAIResponse({
    required String selectedText,
    required AIPromptEntity prompt,
    String? customInstruction,
  });

  Future<Either> checkPlagiarism({
    required String text,
  });

  Future<Either> saveToHistory(AIResponseEntity response);

  Future<Either>> getHistory();
}