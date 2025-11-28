import 'package:equatable/equatable.dart';
import '../../domain/entities/case_entity.dart';

enum UserCasesStatus {
  initial,
  loading,
  success,
  error,
  caseAdded,
  excelExported,
}

class UserCasesState extends Equatable {
  final UserCasesStatus status;
  final List<UserCaseEntity> cases;
  final UserCaseEntity? selectedCase;
  final String? errorMessage;
  final String? successMessage;
  final String? excelPath;

  const UserCasesState({
    this.status = UserCasesStatus.initial,
    this.cases = const [],
    this.selectedCase,
    this.errorMessage,
    this.successMessage,
    this.excelPath,
  });

  UserCasesState copyWith({
    UserCasesStatus? status,
    List<UserCaseEntity>? cases,
    UserCaseEntity? selectedCase,
    String? errorMessage,
    String? successMessage,
    String? excelPath,
  }) {
    return UserCasesState(
      status: status ?? this.status,
      cases: cases ?? this.cases,
      selectedCase: selectedCase ?? this.selectedCase,
      errorMessage: errorMessage,
      successMessage: successMessage,
      excelPath: excelPath,
    );
  }

  @override
  List<Object?> get props => [status, cases, selectedCase, errorMessage, successMessage, excelPath];
}
