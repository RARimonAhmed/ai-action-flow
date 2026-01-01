import 'package:equatable/equatable.dart';
import 'ai_prompt_entity.dart';

enum ResponseStatus { loading, success, error }

class AIResponseEntity extends Equatable {
  final String id;
  final String originalText;
  final String generatedText;
  final AIPromptEntity appliedPrompt;
  final ResponseStatus status;
  final DateTime generatedAt;
  final String? errorMessage;

  const AIResponseEntity({
    required this.id,
    required this.originalText,
    required this.generatedText,
    required this.appliedPrompt,
    required this.status,
    required this.generatedAt,
    this.errorMessage,
  });

  @override
  List get props => [
    id,
    originalText,
    generatedText,
    appliedPrompt,
    status,
    generatedAt,
    errorMessage,
  ];

  AIResponseEntity copyWith({
    String? id,
    String? originalText,
    String? generatedText,
    AIPromptEntity? appliedPrompt,
    ResponseStatus? status,
    DateTime? generatedAt,
    String? errorMessage,
  }) {
    return AIResponseEntity(
      id: id ?? this.id,
      originalText: originalText ?? this.originalText,
      generatedText: generatedText ?? this.generatedText,
      appliedPrompt: appliedPrompt ?? this.appliedPrompt,
      status: status ?? this.status,
      generatedAt: generatedAt ?? this.generatedAt,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}