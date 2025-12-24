import 'package:bloc/bloc.dart';
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
        isLoadingMore: false,
      ),
    );
    final result = await casesRepository.getCases(limit: 20);
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
          hasReachedMax: cases.length < 20,
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

  void filterCases({String? maritalStatus, bool? sortByLowestIncome}) {
    emit(
      state.copyWith(
        filterMaritalStatus: maritalStatus,
        filterSortByLowestIncome: sortByLowestIncome,
        isFiltering: true,
      ),
    );
    _applyFilters();
  }

  void _applyFilters() {
    List<CaseModel> filtered = List.from(state.cases);

    if (state.filterMaritalStatus != null) {
      filtered = filtered.where((c) {
        if (state.filterMaritalStatus == 'متزوج') {
          return c.spouse != null;
        } else if (state.filterMaritalStatus == 'أعزب' ||
            state.filterMaritalStatus == 'أرمل' ||
            state.filterMaritalStatus == 'مطلق') {
          return c.spouse == null;
        }
        return true;
      }).toList();
    }

    if (state.filterSortByLowestIncome == true) {
      filtered.sort(
        (a, b) => a.calculatedTotalFamilyIncome.compareTo(
          b.calculatedTotalFamilyIncome,
        ),
      );
    }

    emit(state.copyWith(filteredCases: filtered));
  }

  Future<void> addNewCase(CaseModel caseModel) async {
    emit(state.copyWith(status: AdminCasesStatus.loading));
    final result = await casesRepository.addCase(caseModel);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AdminCasesStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (_) {
        emit(state.copyWith(successMessage: 'Case added successfully'));
        loadCases();
      },
    );
  }

  Future<void> updateCase(CaseModel caseModel) async {
    emit(state.copyWith(status: AdminCasesStatus.loading));
    final result = await casesRepository.updateCase(caseModel);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AdminCasesStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (_) {
        // Update the specific case in the list to avoid full reload if possible,
        // or just reload. Reloading is safer for consistency.
        // But let's try to update locally for better UX.
        final updatedCases = state.cases.map((c) {
          return c.id == caseModel.id ? caseModel : c;
        }).toList();

        emit(
          state.copyWith(
            status: AdminCasesStatus.success,
            cases: updatedCases,
            successMessage: 'Case updated successfully',
          ),
        );
        _applyFilters();
      },
    );
  }

  Future<void> exportToExcel() async {
    emit(state.copyWith(status: AdminCasesStatus.loading));
    final result = await casesRepository.exportCasesToExcel();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AdminCasesStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (path) => emit(
        state.copyWith(
          status: AdminCasesStatus.excelExported,
          excelPath: path,
          successMessage: 'Excel exported to $path',
        ),
      ),
    );
  }

  Future<void> deleteCase(String id) async {
    emit(state.copyWith(status: AdminCasesStatus.loading));
    final result = await casesRepository.deleteCase(id);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AdminCasesStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (_) {
        final updatedCases = state.cases
            .where((element) => element.id != id)
            .toList();
        emit(
          state.copyWith(
            status: AdminCasesStatus.success,
            cases: updatedCases,
            deleteSuccessMessage: 'Case deleted successfully',
          ),
        );
        _applyFilters();
      },
    );
  }

  Future<void> deleteAllCases() async {
    emit(state.copyWith(status: AdminCasesStatus.loading));
    final result = await casesRepository.deleteAllCases();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AdminCasesStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(
        state.copyWith(
          status: AdminCasesStatus.success,
          cases: [],
          filteredCases: [],
          deleteSuccessMessage: 'All cases deleted successfully',
        ),
      ),
    );
  }

  void searchCases(String query) {
    if (query.isEmpty) {
      emit(state.copyWith(isFiltering: false, filteredCases: []));
      return;
    }
    final filtered = state.cases.where((c) {
      return c.applicant.name.toLowerCase().contains(query.toLowerCase()) ||
          c.applicant.nationalId.contains(query) ||
          c.applicant.phone.contains(query);
    }).toList();
    emit(state.copyWith(isFiltering: true, filteredCases: filtered));
  }
}
