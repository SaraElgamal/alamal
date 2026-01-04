import 'package:equatable/equatable.dart';

enum DonationType { cash, inKind }

class DonorModel extends Equatable {
  final String id;
  final String name;
  final String phone;
  final DonationType donationType;
  final double? amount; // for cash
  final String? description; // for in-kind
  final DateTime date;

  const DonorModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.donationType,
    this.amount,
    this.description,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'donationType': donationType.index,
      'amount': amount,
      'description': description,
      'date': date.toIso8601String(),
    };
  }

  factory DonorModel.fromJson(Map<String, dynamic> json, String documentId) {
    return DonorModel(
      id: documentId,
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      donationType: DonationType.values[json['donationType'] ?? 0],
      amount: (json['amount'] as num?)?.toDouble(),
      description: json['description'],
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    phone,
    donationType,
    amount,
    description,
    date,
  ];
}
