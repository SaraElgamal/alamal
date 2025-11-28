import 'package:bloc/bloc.dart';
 import '../../domain/entities/case_entity.dart' ;
import '../../domain/usecases/add_case_usecase.dart';
import '../../domain/usecases/export_cases_to_excel_usecase.dart';
import '../../domain/usecases/get_cases_usecase.dart';
import 'admin_cases_state.dart';

class AdminCasesCubit extends Cubit<AdminCasesState> {
  final AddCaseUseCase addCase;
  final GetCasesUseCase getCases;
  final ExportCasesToExcelUseCase exportCases;

  AdminCasesCubit({
    required this.addCase,
    required this.getCases,
    required this.exportCases,
  }) : super(const AdminCasesState());

  Future<void> loadCases() async {
    emit(state.copyWith(status: AdminCasesStatus.loading));
    final result = await getCases();
    result.fold(
      (failure) => emit(state.copyWith(
        status: AdminCasesStatus.error,
        errorMessage: failure.message,
      )),
      (cases) => emit(state.copyWith(
        status: AdminCasesStatus.success,
        cases: cases,
      )),
    );
  }


  Future<void> addNewCase(CaseEntity caseEntity) async {
    emit(state.copyWith(status: AdminCasesStatus.loading));
    final result = await addCase(caseEntity);
    result.fold(
      (failure) => emit(state.copyWith(
        status: AdminCasesStatus.error,
        errorMessage: failure.message,
      )),
      (_) {
        // Reload cases after adding
        loadCases(); 
        // Or just emit success and let UI handle reload? 
        // Better to reload to keep list updated.
        // But we also want to show a success message.
        // Let's emit success with message, then reload?
        // Or reload and set success message.
        // If we reload, status goes back to loading.
        // Let's just emit success message for now, assuming list is updated or we manually add it.
        // For simplicity, let's just reload.
        // But to show "Case Added" snackbar, we need a state change.
        emit(state.copyWith(successMessage: 'Case added successfully'));
        loadCases();
      },
    );
  }

  Future<void> exportToExcel() async {
    emit(state.copyWith(status: AdminCasesStatus.loading));
    final result = await exportCases();
    result.fold(
      (failure) => emit(state.copyWith(
        status: AdminCasesStatus.error,
        errorMessage: failure.message,
      )),
      (path) => emit(state.copyWith(
        status: AdminCasesStatus.success,
        successMessage: 'Excel exported to $path',
      )),
    );
  }
}
