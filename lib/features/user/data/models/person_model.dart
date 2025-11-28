import '../../domain/entities/person_entity.dart';

class PersonModel extends PersonEntity {
  const PersonModel({
    required super.name,
    required super.nationalId,
    required super.age,
    required super.profession,
    required super.income,
    required super.phone,
    super.address,
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

  factory PersonModel.fromEntity(PersonEntity entity) {
    return PersonModel(
      name: entity.name,
      nationalId: entity.nationalId,
      age: entity.age,
      profession: entity.profession,
      income: entity.income,
      phone: entity.phone,
      address: entity.address,
    );
  }
}
