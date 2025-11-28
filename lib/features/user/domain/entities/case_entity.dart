import 'package:equatable/equatable.dart';
import 'person_entity.dart';
import 'expenses_entity.dart';
import 'aid_entity.dart';

class UserCaseEntity extends Equatable {
  final String id;
  final PersonEntity applicant;
  final PersonEntity? spouse;
  final String caseDescription; // e.g., Widow, Divorced, Sick, etc.
  final List<PersonEntity> familyMembers;
  final int rationCardCount;
  final int pensionCount;
  final ExpensesEntity expenses;
  final List<AidEntity> aidHistory;
  final DateTime createdAt;

  const UserCaseEntity({
    required this.id,
    required this.applicant,
    this.spouse,
    required this.caseDescription,
    required this.familyMembers,
    required this.rationCardCount,
    required this.pensionCount,
    required this.expenses,
    required this.aidHistory,
    required this.createdAt,
  });

  double get totalFamilyIncome {
    double total = applicant.income;
    if (spouse != null) {
      total += spouse!.income;
    }
    for (var member in familyMembers) {
      total += member.income;
    }
    return total;
  }

  @override
  List<Object?> get props => [
        id,
        applicant,
        spouse,
        caseDescription,
        familyMembers,
        rationCardCount,
        pensionCount,
        expenses,
        aidHistory,
        createdAt,
      ];
}
