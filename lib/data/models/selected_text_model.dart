import '../../domain/entities/selected_text_entity.dart';

class SelectedTextModel extends SelectedTextEntity {
  const SelectedTextModel({
    required super.text,
    required super.positionX,
    required super.positionY,
    required super.selectedAt,
  });

  factory SelectedTextModel.fromJson(Map json) {
    return SelectedTextModel(
      text: json['text'] as String,
      positionX: (json['positionX'] as num).toDouble(),
      positionY: (json['positionY'] as num).toDouble(),
      selectedAt: DateTime.parse(json['selectedAt'] as String),
    );
  }

  Map toJson() {
    return {
      'text': text,
      'positionX': positionX,
      'positionY': positionY,
      'selectedAt': selectedAt.toIso8601String(),
    };
  }

  factory SelectedTextModel.fromEntity(SelectedTextEntity entity) {
    return SelectedTextModel(
      text: entity.text,
      positionX: entity.positionX,
      positionY: entity.positionY,
      selectedAt: entity.selectedAt,
    );
  }
}