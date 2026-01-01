import 'package:equatable/equatable.dart';

enum PromptType {
  improveWriting,
  summarize,
  rewrite,
  simplify,
  plagiarismCheck,
  regenerate,
  custom
}

class AIPromptEntity extends Equatable {
  final String id;
  final String title;
  final String instruction;
  final PromptType type;
  final String? icon;

  const AIPromptEntity({
    required this.id,
    required this.title,
    required this.instruction,
    required this.type,
    this.icon,
  });

  @override
  List get props => [id, title, instruction, type, icon];
}