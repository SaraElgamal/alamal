import 'package:equatable/equatable.dart';

class ExpensesEntity extends Equatable {
  final double rent;
  final double electricity;
  final double water;
  final double gas;
  final double education;
  final double treatment;
  final double debtRepayment;
  final double other;

  const ExpensesEntity({
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
      rent + electricity + water + gas + education + treatment + debtRepayment + other;

  @override
  List<Object?> get props =>
      [rent, electricity, water, gas, education, treatment, debtRepayment, other];
}
