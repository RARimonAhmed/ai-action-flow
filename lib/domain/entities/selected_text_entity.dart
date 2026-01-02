import 'package:equatable/equatable.dart';

class SelectedTextEntity extends Equatable {
  final String text;
  final double positionX;
  final double positionY;
  final DateTime selectedAt;

  const SelectedTextEntity({
    required this.text,
    required this.positionX,
    required this.positionY,
    required this.selectedAt,
  });

  @override
  List<Object?> get props => [text, positionX, positionY, selectedAt];

  bool get isEmpty => text.trim().isEmpty;

  int get wordCount => text.trim().split(RegExp(r'\s+')).length;

  bool get isValidSelection => text.length >= 3 && text.length <= 5000;
}