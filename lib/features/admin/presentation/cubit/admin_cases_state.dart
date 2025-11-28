 import 'package:charity_app/features/user/domain/entities/case_entity.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/case_entity.dart'  ;

enum AdminCasesStatus { initial, loading, success, error }

class AdminCasesState extends Equatable {
  final AdminCasesStatus status;
  final List<UserCaseEntity> cases;
  final String? errorMessage;
  final String? successMessage;

  const AdminCasesState({
    this.status = AdminCasesStatus.initial,
    this.cases = const [],
    this.errorMessage,
    this.successMessage,
  });

  AdminCasesState copyWith({
    AdminCasesStatus? status,
    List<UserCaseEntity>? cases,
    String? errorMessage,
    String? successMessage,
  }) {
    return AdminCasesState(
      status: status ?? this.status,
      cases: cases ?? this.cases,
      errorMessage: errorMessage, // Reset error on new state unless provided
      successMessage: successMessage, // Reset success message
    );
  }

  @override
  List<Object?> get props => [status, cases, errorMessage, successMessage];
}
