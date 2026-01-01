import 'package:ai_action_flow/app/config/constants/api_constants.dart';
import 'package:ai_action_flow/app/config/constants/promt_constants.dart';
import 'package:dartz/dartz.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/network/network_info.dart';
import '../../core/utils/logger.dart';
import '../../domain/entities/ai_prompt_entity.dart';
import '../../domain/entities/ai_response_entity.dart';
import '../../domain/repositories/ai_repository.dart';
import '../models/ai_prompt_model.dart';
import '../models/ai_response_model.dart';
import '../providers/local/storage_provider.dart';
import '../providers/network/api_provider.dart';

class AIRepositoryImpl implements AIRepository {
  final ApiProvider apiProvider;
  final StorageProvider storageProvider;
  final NetworkInfo networkInfo;

  AIRepositoryImpl({
    required this.apiProvider,
    required this.storageProvider,
    required this.networkInfo,
  });

  @override
  Future<Either>> getAvailablePrompts() async {
    try {
      AppLogger.i('Getting available prompts');

      // Return predefined prompts
      return const Right(PromptConstants.defaultPrompts);
    } catch (e) {
      AppLogger.e('Error getting prompts', e);
      return Left(CacheFailure('Failed to load prompts: ${e.toString()}'));
    }
  }

  @override
  Future<Either> generateAIResponse({
    required String selectedText,
    required AIPromptEntity prompt,
    String? customInstruction,
  }) async {
    // Check network
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }

    try {
      AppLogger.i('Generating AI response for prompt: ${prompt.title}');

      // Build the system message based on prompt type
      final systemMessage = _buildSystemMessage(prompt, customInstruction);

      // Make API call to OpenAI
      final response = await apiProvider.post(
        ApiConstants.chatCompletions,
        data: {
          'model': ApiConstants.defaultModel,
          'messages': [
            {'role': 'system', 'content': systemMessage},
            {'role': 'user', 'content': selectedText},
          ],
          'max_tokens': ApiConstants.maxTokens,
          'temperature': 0.7,
        },
      );

      // Parse response
      final aiResponse = AIResponseModel.fromOpenAI(
        response,
        selectedText,
        prompt,
      );

      // Save to history
      await _saveToHistory(aiResponse);

      AppLogger.i('AI response generated successfully');
      return Right(aiResponse);
    } on ServerException catch (e) {
      AppLogger.e('Server error', e);
      return Left(ServerFailure(e.message, e.statusCode));
    } on NetworkException catch (e) {
      AppLogger.e('Network error', e);
      return Left(NetworkFailure(e.message));
    } catch (e) {
      AppLogger.e('Unexpected error', e);
      return Left(AIGenerationFailure('Failed to generate response: $e'));
    }
  }

  @override
  Future<Either> checkPlagiarism({
    required String text,
  }) async {
    // Check network
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }

    try {
      AppLogger.i('Checking plagiarism');

      final prompt = PromptConstants.defaultPrompts.firstWhere(
            (p) => p.type == PromptType.plagiarismCheck,
      );

      final response = await apiProvider.post(
        ApiConstants.chatCompletions,
        data: {
          'model': ApiConstants.defaultModel,
          'messages': [
            {
              'role': 'system',
              'content': prompt.instruction,
            },
            {'role': 'user', 'content': text},
          ],
          'max_tokens': ApiConstants.maxTokens,
          'temperature': 0.3,
        },
      );

      final aiResponse = AIResponseModel.fromOpenAI(response, text, prompt);

      AppLogger.i('Plagiarism check completed');
      return Right(aiResponse);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(AIGenerationFailure('Plagiarism check failed: $e'));
    }
  }

  @override
  Future<Either> saveToHistory(
      AIResponseEntity response,
      ) async {
    try {
      await _saveToHistory(response);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to save history: $e'));
    }
  }

  @override
  Future<Either>> getHistory() async {
    try {
      AppLogger.i('Getting history');

      final historyJson = storageProvider.read<List>(
        StorageProvider.keyHistory,
      );

      if (historyJson == null || historyJson.isEmpty) {
        return const Right([]);
      }

      final history = historyJson
          .map((json) => AIResponseModel.fromJson(json as Map))
          .toList();

      return Right(history);
    } catch (e) {
      AppLogger.e('Error getting history', e);
      return Left(CacheFailure('Failed to load history: $e'));
    }
  }

  // Private helper methods
  String _buildSystemMessage(AIPromptEntity prompt, String? customInstruction) {
    if (customInstruction != null && customInstruction.isNotEmpty) {
      return '$customInstruction\n\n${prompt.instruction}';
    }
    return prompt.instruction;
  }

  Future _saveToHistory(AIResponseEntity response) async {
    try {
      final historyJson = storageProvider.read<List>(
        StorageProvider.keyHistory,
      ) ?? [];

      final responseModel = AIResponseModel.fromEntity(response);
      historyJson.insert(0, responseModel.toJson());

      // Keep only last 50 items
      if (historyJson.length > 50) {
        historyJson.removeRange(50, historyJson.length);
      }

      await storageProvider.write(StorageProvider.keyHistory, historyJson);
      AppLogger.d('Response saved to history');
    } catch (e) {
      AppLogger.e('Failed to save history', e);
    }
  }
}