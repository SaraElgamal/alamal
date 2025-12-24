import 'package:equatable/equatable.dart';

enum AidType { cash, food, medical, educational, other }

class AidModel extends Equatable {
  final AidType type;
  final double value;
  final String? description;
  final DateTime date;

  const AidModel({
    required this.type,
    required this.value,
    this.description,
    required this.date,
  });

  factory AidModel.fromJson(Map<String, dynamic> json) {
    return AidModel(
      type: AidType.values.firstWhere(
        (e) => e.toString() == (json['type'] ?? ''),
        orElse: () => AidType.cash,
      ),
      value: (json['value'] ?? 0).toDouble(),
      description: json['description'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.toString(),
      'value': value,
      'description': description,
      'date': date.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [type, value, description, date];
}
