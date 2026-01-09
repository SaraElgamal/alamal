import 'package:bloc/bloc.dart';
import 'package:charity_app/core/helpers/excel_helper.dart';
import '../../data/models/case_model.dart';
import '../../data/repo/cases_repository.dart';
import 'admin_cases_state.dart';

class AdminCasesCubit extends Cubit<AdminCasesState> {
  final CasesRepository casesRepository;

  AdminCasesCubit({required this.casesRepository})
    : super(const AdminCasesState());

  Future<void> loadCases() async {
    emit(
      state.copyWith(
        status: AdminCasesStatus.loading,
        cases: [],
        filteredCases: [],
        hasReachedMax: false,
      ),
    );
    final result = await casesRepository.getCases(
      limit: 50,
    ); // Increased limit for better filtering
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AdminCasesStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (cases) => emit(
        state.copyWith(
          status: AdminCasesStatus.success,
          cases: cases,
          hasReachedMax: cases.length < 50,
        ),
      ),
    );
  }

  Future<void> loadMoreCases() async {
    if (state.isLoadingMore || state.hasReachedMax) return;
    emit(state.copyWith(isLoadingMore: true));

    final result = await casesRepository.getCases(
      limit: 20,
      lastCaseId: state.cases.isNotEmpty ? state.cases.last.id : null,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(isLoadingMore: false, errorMessage: failure.message),
      ),
      (newCases) {
        final allCases = List<CaseModel>.from(state.cases)..addAll(newCases);
        emit(
          state.copyWith(
            isLoadingMore: false,
            cases: allCases,
            hasReachedMax: newCases.length < 20,
          ),
        );
        _applyFilters();
      },
    );
  }

  // --- Advanced Filter Method ---
  void filterCasesAdvanced({
    String? maritalStatus,
    bool? sortByLowestIncome,
    double? minIncome,
    double? maxIncome,
    int? minFamilyMembers,
    bool? showUrgentOnly,
    bool? hasAid,
    bool? hasChildren,
  }) {
    // We cannot use copyWith because it ignores nulls (which we need for resetting filters).
    // So we construct a new state preserving non-filter properties and applying new specific filters.
    emit(
      AdminCasesState(
        status: state.status,
        cases: state.cases,
        filteredCases: state.filteredCases, // Will be updated in _applyFilters
        errorMessage: state.errorMessage,
        successMessage: state.successMessage,
        deleteSuccessMessage: state.deleteSuccessMessage,
        hasReachedMax: state.hasReachedMax,
        isLoadingMore: state.isLoadingMore,
        excelPath: state.excelPath,
        // Apply Filters
        isFiltering: true,
        filterMaritalStatus: maritalStatus,
        filterSortByLowestIncome: sortByLowestIncome,
        filterMinIncome: minIncome,
        filterMaxIncome: maxIncome,
        filterMinFamilyMembers: minFamilyMembers,
        filterShowUrgentOnly: showUrgentOnly ?? false,
        filterHasAid: hasAid,
        filterHasChildren: hasChildren,
      ),
    );
    _applyFilters();
  }

  void clearFilter() {
    emit(
      AdminCasesState(
        status: state.status,
        cases: state.cases,
        filteredCases: [],
        errorMessage: state.errorMessage,
        successMessage: state.successMessage,
        deleteSuccessMessage: state.deleteSuccessMessage,
        hasReachedMax: state.hasReachedMax,
        isLoadingMore: state.isLoadingMore,
        excelPath: state.excelPath,
        // Reset Filters
        isFiltering: false,
        filterMaritalStatus: null,
        filterSortByLowestIncome: false,
        filterMinIncome: null,
        filterMaxIncome: null,
        filterMinFamilyMembers: null,
        filterShowUrgentOnly: false,
        filterHasAid: null,
        filterHasChildren: null,
      ),
    );
  }

  void _applyFilters() {
    List<CaseModel> filtered = List.from(state.cases);

    // 1. Marital Status
    if (state.filterMaritalStatus != null) {
      if (state.filterMaritalStatus == 'متزوج') {
        filtered = filtered.where((c) => c.spouse != null).toList();
      } else {
        filtered = filtered.where((c) => c.spouse == null).toList();
      }
    }

    // 2. Income Range
    if (state.filterMinIncome != null) {
      filtered = filtered
          .where((c) => c.manualTotalFamilyIncome >= state.filterMinIncome!)
          .toList();
    }
    if (state.filterMaxIncome != null) {
      filtered = filtered
          .where((c) => c.manualTotalFamilyIncome <= state.filterMaxIncome!)
          .toList();
    }

    // 3. Family Members
    if (state.filterMinFamilyMembers != null) {
      filtered = filtered
          .where((c) => c.familyMembers.length >= state.filterMinFamilyMembers!)
          .toList();
    }

    // 4. Urgent Only
    if (state.filterShowUrgentOnly == true) {
      filtered = filtered.where((c) {
        final totalIncome = c.manualTotalFamilyIncome;
        final totalExpenses = c.expenses.total;
        final remaining = totalIncome - totalExpenses;
        return remaining < 0 || totalIncome < 2000;
      }).toList();
    }

    // 5. Has Aid
    if (state.filterHasAid != null) {
      if (state.filterHasAid == true) {
        filtered = filtered.where((c) => c.aidHistory.isNotEmpty).toList();
      } else {
        filtered = filtered.where((c) => c.aidHistory.isEmpty).toList();
      }
    }

    // 6. Has Children
    if (state.filterHasChildren != null) {
      if (state.filterHasChildren == true) {
        filtered = filtered.where((c) => c.familyMembers.isNotEmpty).toList();
      } else {
        filtered = filtered.where((c) => c.familyMembers.isEmpty).toList();
      }
    }

    // 5. Sorting
    if (state.filterSortByLowestIncome == true) {
      filtered.sort(
        (a, b) =>
            a.manualTotalFamilyIncome.compareTo(b.manualTotalFamilyIncome),
      );
    }

    emit(state.copyWith(filteredCases: filtered));
  }

  Stream<double> exportToExcelChange() {
    final listToExport = state.isFiltering ? state.filteredCases : state.cases;
    return ExcelHelper.exportCasesWithProgress(
      listToExport,
      onComplete: (path) => emit(
        state.copyWith(
          successMessage: 'تم التصدير: $path',
          excelPath: path,
          status: AdminCasesStatus.excelExported,
        ),
      ),
      onError: (err) => emit(
        state.copyWith(errorMessage: err, status: AdminCasesStatus.error),
      ),
    );
  }

  Future<void> deleteCase(String id) async {
    final result = await casesRepository.deleteCase(id);
    result.fold((l) => emit(state.copyWith(errorMessage: l.message)), (r) {
      final updated = state.cases.where((c) => c.id != id).toList();
      emit(state.copyWith(cases: updated, deleteSuccessMessage: 'تم الحذف'));
      _applyFilters();
    });
  }

  Future<void> deleteAllCases() async {
    final result = await casesRepository.deleteAllCases();
    result.fold(
      (l) => emit(state.copyWith(errorMessage: l.message)),
      (r) => emit(
        state.copyWith(
          cases: [],
          filteredCases: [],
          deleteSuccessMessage: 'تم حذف الجميع',
        ),
      ),
    );
  }

  void searchCases(String query) {
    // Allow searching within filtered results or global? Use global for now
    if (query.isEmpty) {
      _applyFilters();
      return;
    }

    final source = state.cases;
    final result = source
        .where(
          (c) =>
              c.applicant.name.toLowerCase().contains(query.toLowerCase()) ||
              c.applicant.nationalId.contains(query),
        )
        .toList();

    emit(state.copyWith(isFiltering: true, filteredCases: result));
  }

  Future<void> updateCase(CaseModel updatedCase) async {
    emit(state.copyWith(status: AdminCasesStatus.loading));
    final result = await casesRepository.updateCase(updatedCase);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AdminCasesStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (success) {
        final updatedList = state.cases
            .map((c) => c.id == updatedCase.id ? updatedCase : c)
            .toList();
        emit(
          state.copyWith(
            status: AdminCasesStatus.success,
            cases: updatedList,
            successMessage: 'Case updated successfully',
          ),
        );
        _applyFilters();
      },
    );
  }
}
