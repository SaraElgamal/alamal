import 'package:equatable/equatable.dart';

class PersonEntity extends Equatable {
  final String name;
  final String nationalId;
  final int age;
  final String profession;
  final double income;
  final String phone;
  final String? address;

  const PersonEntity({
    required this.name,
    required this.nationalId,
    required this.age,
    required this.profession,
    required this.income,
    required this.phone,
    this.address,
  });

  @override
  List<Object?> get props => [name, nationalId, age, profession, income, phone, address];
}
