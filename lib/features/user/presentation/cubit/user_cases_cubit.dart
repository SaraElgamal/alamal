import 'package:bloc/bloc.dart';
import '../../domain/entities/case_entity.dart';
import '../../domain/usecases/add_case_usecase.dart';
import '../../domain/usecases/export_cases_to_excel_usecase.dart';
import '../../domain/usecases/get_case_by_id_usecase.dart';
import '../../domain/usecases/get_cases_usecase.dart';
import 'user_cases_state.dart';

class UserCasesCubit extends Cubit<UserCasesState> {
  final AddCaseUseCase addCase;
  final GetCasesUseCase getCases;
  final GetCaseByIdUseCase getCaseById;
  final ExportCasesToExcelUseCase exportCases;

  UserCasesCubit({
    required this.addCase,
    required this.getCases,
    required this.getCaseById,
    required this.exportCases,
  }) : super(const UserCasesState());

  Future<void> loadCases() async {
    emit(state.copyWith(status: UserCasesStatus.loading));
    final result = await getCases();
    result.fold(
      (failure) => emit(state.copyWith(
        status: UserCasesStatus.error,
        errorMessage: failure.message,
      )),
      (cases) => emit(state.copyWith(
        status: UserCasesStatus.success,
        cases: cases,
      )),
    );
  }

  Future<void> addNewCase(UserCaseEntity caseEntity) async {
    emit(state.copyWith(status: UserCasesStatus.loading));
    final result = await addCase(caseEntity);
    result.fold(
      (failure) => emit(state.copyWith(
        status: UserCasesStatus.error,
        errorMessage: failure.message,
      )),
      (_) => emit(state.copyWith(
        status: UserCasesStatus.caseAdded,
        successMessage: 'تم تسجيل الحالة بنجاح',
      )),
    );
  }

  Future<void> getCaseDetails(String id) async {
    emit(state.copyWith(status: UserCasesStatus.loading));
    final result = await getCaseById(id);
    result.fold(
      (failure) => emit(state.copyWith(
        status: UserCasesStatus.error,
        errorMessage: failure.message,
      )),
      (caseEntity) => emit(state.copyWith(
        status: UserCasesStatus.success,
        selectedCase: caseEntity,
      )),
    );
  }

  Future<void> exportToExcel() async {
    emit(state.copyWith(status: UserCasesStatus.loading));
    final result = await exportCases();
    result.fold(
      (failure) => emit(state.copyWith(
        status: UserCasesStatus.error,
        errorMessage: failure.message,
      )),
      (path) => emit(state.copyWith(
        status: UserCasesStatus.excelExported,
        excelPath: path,
        successMessage: 'تم تصدير البيانات إلى Excel بنجاح',
      )),
    );
  }
}
