import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/ai_prompt_entity.dart';
import '../entities/ai_response_entity.dart';

abstract class AIRepository {
  Future<Either<Failure, List<AIPromptEntity>>> getAvailablePrompts();

  Future<Either<Failure, AIResponseEntity>> generateAIResponse({
    required String selectedText,
    required AIPromptEntity prompt,
    String? customInstruction,
  });

  Future<Either<Failure, AIResponseEntity>> checkPlagiarism({
    required String text,
  });

  Future<Either<Failure, void>> saveToHistory(AIResponseEntity response);

  Future<Either<Failure, List<AIResponseEntity>>> getHistory();
}