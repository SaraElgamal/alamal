import 'package:cloud_firestore/cloud_firestore.dart';

class DonationModel {
  final String id;
  final String name;
  final String phone;
  final double amount;
  final DateTime date;
  final String? description;
  final int donationType;

  DonationModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.amount,
    required this.date,
    this.description,
    required this.donationType,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'amount': amount,
      'date': date.toIso8601String(),
      'description': description,
      'donationType': donationType,
    };
  }

  factory DonationModel.fromJson(Map<String, dynamic> json) {
    return DonationModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      amount: (json['amount'] is int)
          ? (json['amount'] as int).toDouble()
          : (json['amount'] as double? ?? 0.0),
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      description: json['description'],
      donationType: json['donationType'] ?? 0,
    );
  }

  factory DonationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return DonationModel.fromJson({'id': doc.id, ...data});
  }
}
