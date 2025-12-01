import 'package:equatable/equatable.dart';

class ExpensesModel extends Equatable {
  final double rent;
  final double electricity;
  final double water;
  final double gas;
  final double education;
  final double treatment;
  final double debtRepayment;
  final double other;

  const ExpensesModel({
    this.rent = 0,
    this.electricity = 0,
    this.water = 0,
    this.gas = 0,
    this.education = 0,
    this.treatment = 0,
    this.debtRepayment = 0,
    this.other = 0,
  });

  double get total =>
      rent +
      electricity +
      water +
      gas +
      education +
      treatment +
      debtRepayment +
      other;

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

  @override
  List<Object?> get props => [
    rent,
    electricity,
    water,
    gas,
    education,
    treatment,
    debtRepayment,
    other,
  ];
}
