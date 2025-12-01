import 'package:equatable/equatable.dart';

class PersonModel extends Equatable {
  final String name;
  final String nationalId;
  final int age;
  final String profession;
  final double income;
  final String phone;
  final String? address;

  const PersonModel({
    required this.name,
    required this.nationalId,
    required this.age,
    required this.profession,
    required this.income,
    required this.phone,
    this.address,
  });

  factory PersonModel.fromJson(Map<String, dynamic> json) {
    return PersonModel(
      name: json['name'] ?? '',
      nationalId: json['nationalId'] ?? '',
      age: json['age'] ?? 0,
      profession: json['profession'] ?? '',
      income: (json['income'] ?? 0).toDouble(),
      phone: json['phone'] ?? '',
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'nationalId': nationalId,
      'age': age,
      'profession': profession,
      'income': income,
      'phone': phone,
      'address': address,
    };
  }

  @override
  List<Object?> get props => [
    name,
    nationalId,
    age,
    profession,
    income,
    phone,
    address,
  ];
}
