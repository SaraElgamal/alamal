import 'package:equatable/equatable.dart';
import '../../data/models/case_model.dart';
import '../../../user/data/models/case_model.dart'
    as user_model; // Alias conflict check? Cubit uses admin model mainly.

enum AdminCasesStatus { initial, loading, success, error, excelExported }

class AdminCasesState extends Equatable {
  final AdminCasesStatus status;
  final List<CaseModel> cases;
  final List<CaseModel> filteredCases;
  final String? errorMessage;
  final String? successMessage;
  final String? deleteSuccessMessage;
  final bool hasReachedMax;
  final bool isLoadingMore;
  final bool isFiltering;
  final String? excelPath;

  // Filter State
  final String? filterMaritalStatus;
  final bool? filterSortByLowestIncome;

  // Advanced Filters
  final double? filterMinIncome;
  final double? filterMaxIncome;
  final int? filterMinFamilyMembers;
  final bool filterShowUrgentOnly;
  final bool? filterHasAid; // null=all, true=yes, false=no
  final bool? filterHasChildren; // null=all, true=yes, false=no

  const AdminCasesState({
    this.status = AdminCasesStatus.initial,
    this.cases = const [],
    this.filteredCases = const [],
    this.errorMessage,
    this.successMessage,
    this.deleteSuccessMessage,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
    this.isFiltering = false,
    this.excelPath,
    this.filterMaritalStatus,
    this.filterSortByLowestIncome,
    this.filterMinIncome,
    this.filterMaxIncome,
    this.filterMinFamilyMembers,
    this.filterShowUrgentOnly = false,
    this.filterHasAid,
    this.filterHasChildren,
  });

  AdminCasesState copyWith({
    AdminCasesStatus? status,
    List<CaseModel>? cases,
    List<CaseModel>? filteredCases,
    String? errorMessage,
    String? successMessage,
    String? deleteSuccessMessage,
    bool? hasReachedMax,
    bool? isLoadingMore,
    bool? isFiltering,
    String? excelPath,
    String? filterMaritalStatus,
    bool? filterSortByLowestIncome,
    double? filterMinIncome,
    double? filterMaxIncome,
    int? filterMinFamilyMembers,
    bool? filterShowUrgentOnly,
    bool? filterHasAid,
    bool? filterHasChildren,
  }) {
    return AdminCasesState(
      status: status ?? this.status,
      cases: cases ?? this.cases,
      filteredCases: filteredCases ?? this.filteredCases,
      errorMessage: errorMessage,
      successMessage: successMessage,
      deleteSuccessMessage: deleteSuccessMessage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isFiltering: isFiltering ?? this.isFiltering,
      excelPath: excelPath ?? this.excelPath,
      filterMaritalStatus: filterMaritalStatus ?? this.filterMaritalStatus,
      filterSortByLowestIncome:
          filterSortByLowestIncome ?? this.filterSortByLowestIncome,
      filterMinIncome: filterMinIncome ?? this.filterMinIncome,
      filterMaxIncome: filterMaxIncome ?? this.filterMaxIncome,
      filterMinFamilyMembers:
          filterMinFamilyMembers ?? this.filterMinFamilyMembers,
      filterShowUrgentOnly: filterShowUrgentOnly ?? this.filterShowUrgentOnly,
      filterHasAid: filterHasAid ?? this.filterHasAid,
      filterHasChildren: filterHasChildren ?? this.filterHasChildren,
    );
  }

  @override
  List<Object?> get props => [
    status,
    cases,
    filteredCases,
    errorMessage,
    successMessage,
    deleteSuccessMessage,
    hasReachedMax,
    isLoadingMore,
    isFiltering,
    excelPath,
    filterMaritalStatus,
    filterSortByLowestIncome,
    filterMinIncome,
    filterMaxIncome,
    filterMinFamilyMembers,
    filterShowUrgentOnly,
    filterHasAid,
    filterHasChildren,
  ];
}
