import 'package:equatable/equatable.dart';
import '../../data/models/case_model.dart';

enum AdminCasesStatus { initial, loading, success, error, excelExported }

class AdminCasesState extends Equatable {
  final AdminCasesStatus status;
  final List<CaseModel> cases;
  final List<CaseModel> filteredCases;
  final bool isFiltering;
  final String? errorMessage;
  final String? successMessage;
  final String? excelPath;
  final String? deleteSuccessMessage;
  final bool isLoadingMore;
  final bool hasReachedMax;
  final String? filterMaritalStatus;
  final bool filterSortByLowestIncome;

  const AdminCasesState({
    this.status = AdminCasesStatus.initial,
    this.cases = const [],
    this.filteredCases = const [],
    this.isFiltering = false,
    this.errorMessage,
    this.successMessage,
    this.excelPath,
    this.deleteSuccessMessage,
    this.isLoadingMore = false,
    this.hasReachedMax = false,
    this.filterMaritalStatus,
    this.filterSortByLowestIncome = false,
  });

  AdminCasesState copyWith({
    AdminCasesStatus? status,
    List<CaseModel>? cases,
    List<CaseModel>? filteredCases,
    bool? isFiltering,
    String? errorMessage,
    String? successMessage,
    String? excelPath,
    String? deleteSuccessMessage,
    bool? isLoadingMore,
    bool? hasReachedMax,
    String? filterMaritalStatus,
    bool? filterSortByLowestIncome,
  }) {
    return AdminCasesState(
      status: status ?? this.status,
      cases: cases ?? this.cases,
      filteredCases: filteredCases ?? this.filteredCases,
      isFiltering: isFiltering ?? this.isFiltering,
      errorMessage: errorMessage,
      successMessage: successMessage,
      excelPath: excelPath ?? this.excelPath,
      deleteSuccessMessage: deleteSuccessMessage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      filterMaritalStatus: filterMaritalStatus ?? this.filterMaritalStatus,
      filterSortByLowestIncome:
          filterSortByLowestIncome ?? this.filterSortByLowestIncome,
    );
  }

  @override
  List<Object?> get props => [
    status,
    cases,
    filteredCases,
    isFiltering,
    errorMessage,
    successMessage,
    excelPath,
    deleteSuccessMessage,
    isLoadingMore,
    hasReachedMax,
    filterMaritalStatus,
    filterSortByLowestIncome,
  ];
}
