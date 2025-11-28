import '../../domain/entities/aid_entity.dart';

class AidModel extends AidEntity {
  const AidModel({
    required super.type,
    required super.value,
    required super.date,
  });

  factory AidModel.fromJson(Map<String, dynamic> json) {
    return AidModel(
      type: AidType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => AidType.cash,
      ),
      value: (json['value'] ?? 0).toDouble(),
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.toString(),
      'value': value,
      'date': date.toIso8601String(),
    };
  }

  factory AidModel.fromEntity(AidEntity entity) {
    return AidModel(
      type: entity.type,
      value: entity.value,
      date: entity.date,
    );
  }
}
