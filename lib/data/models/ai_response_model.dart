import '../../domain/entities/ai_prompt_entity.dart';
import '../../domain/entities/ai_response_entity.dart';
import 'ai_prompt_model.dart';

class AIResponseModel extends AIResponseEntity {
  const AIResponseModel({
    required super.id,
    required super.originalText,
    required super.generatedText,
    required super.appliedPrompt,
    required super.status,
    required super.generatedAt,
    super.errorMessage,
  });

  factory AIResponseModel.fromJson(Map json) {
    return AIResponseModel(
      id: json['id'] as String,
      originalText: json['originalText'] as String,
      generatedText: json['generatedText'] as String,
      appliedPrompt: AIPromptModel.fromJson(
        json['appliedPrompt'] as Map,
      ),
      status: _parseStatus(json['status'] as String),
      generatedAt: DateTime.parse(json['generatedAt'] as String),
      errorMessage: json['errorMessage'] as String?,
    );
  }

  Map toJson() {
    return {
      'id': id,
      'originalText': originalText,
      'generatedText': generatedText,
      'appliedPrompt': AIPromptModel.fromEntity(appliedPrompt).toJson(),
      'status': status.name,
      'generatedAt': generatedAt.toIso8601String(),
      'errorMessage': errorMessage,
    };
  }

  static ResponseStatus _parseStatus(String status) {
    return ResponseStatus.values.firstWhere(
          (e) => e.name == status,
      orElse: () => ResponseStatus.error,
    );
  }

  factory AIResponseModel.fromEntity(AIResponseEntity entity) {
    return AIResponseModel(
      id: entity.id,
      originalText: entity.originalText,
      generatedText: entity.generatedText,
      appliedPrompt: entity.appliedPrompt,
      status: entity.status,
      generatedAt: entity.generatedAt,
      errorMessage: entity.errorMessage,
    );
  }

  // OpenAI API Response parsing
  factory AIResponseModel.fromOpenAI(
      Map json,
      String originalText,
      AIPromptEntity prompt,
      ) {
    final choices = json['choices'] as List;
    final firstChoice = choices.first as Map;
    final message = firstChoice['message'] as Map;
    final content = message['content'] as String;

    return AIResponseModel(
      id: json['id'] as String,
      originalText: originalText,
      generatedText: content.trim(),
      appliedPrompt: prompt,
      status: ResponseStatus.success,
      generatedAt: DateTime.now(),
    );
  }
}