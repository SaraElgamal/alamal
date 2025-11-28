import '../../domain/entities/expenses_entity.dart';

class ExpensesModel extends ExpensesEntity {
  const ExpensesModel({
    super.rent,
    super.electricity,
    super.water,
    super.gas,
    super.education,
    super.treatment,
    super.debtRepayment,
    super.other,
  });

  factory ExpensesModel.fromJson(Map<String, dynamic> json) {
    return ExpensesModel(
      rent: (json['rent'] ?? 0).toDouble(),
      electricity: (json['electricity'] ?? 0).toDouble(),
      water: (json['water'] ?? 0).toDouble(),
      gas: (json['gas'] ?? 0).toDouble(),
      education: (json['education'] ?? 0).toDouble(),
      treatment: (json['treatment'] ?? 0).toDouble(),
      debtRepayment: (json['debtRepayment'] ?? 0).toDouble(),
      other: (json['other'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rent': rent,
      'electricity': electricity,
      'water': water,
      'gas': gas,
      'education': education,
      'treatment': treatment,
      'debtRepayment': debtRepayment,
      'other': other,
    };
  }

  factory ExpensesModel.fromEntity(ExpensesEntity entity) {
    return ExpensesModel(
      rent: entity.rent,
      electricity: entity.electricity,
      water: entity.water,
      gas: entity.gas,
      education: entity.education,
      treatment: entity.treatment,
      debtRepayment: entity.debtRepayment,
      other: entity.other,
    );
  }
}
