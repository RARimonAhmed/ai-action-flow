import '../../domain/entities/ai_prompt_entity.dart';

class AIPromptModel extends AIPromptEntity {
  const AIPromptModel({
    required super.id,
    required super.title,
    required super.instruction,
    required super.type,
    super.icon,
  });

  factory AIPromptModel.fromJson(Map json) {
    return AIPromptModel(
      id: json['id'] as String,
      title: json['title'] as String,
      instruction: json['instruction'] as String,
      type: _parsePromptType(json['type'] as String),
      icon: json['icon'] as String?,
    );
  }

  Map toJson() {
    return {
      'id': id,
      'title': title,
      'instruction': instruction,
      'type': type.name,
      'icon': icon,
    };
  }

  static PromptType _parsePromptType(String type) {
    return PromptType.values.firstWhere(
          (e) => e.name == type,
      orElse: () => PromptType.custom,
    );
  }

  factory AIPromptModel.fromEntity(AIPromptEntity entity) {
    return AIPromptModel(
      id: entity.id,
      title: entity.title,
      instruction: entity.instruction,
      type: entity.type,
      icon: entity.icon,
    );
  }
}