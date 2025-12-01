import 'package:bloc/bloc.dart';
import '../../data/models/case_model.dart';
import '../../data/repo/cases_repository.dart';
import 'user_cases_state.dart';

class UserCasesCubit extends Cubit<UserCasesState> {
  final CasesRepository casesRepository;

  UserCasesCubit({required this.casesRepository})
    : super(const UserCasesState());

  Future<void> loadCases() async {
    emit(state.copyWith(status: UserCasesStatus.loading));
    final result = await casesRepository.getCases();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: UserCasesStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (cases) =>
          emit(state.copyWith(status: UserCasesStatus.success, cases: cases)),
    );
  }

  Future<void> addNewCase(CaseModel caseModel) async {
    emit(state.copyWith(status: UserCasesStatus.loading));
    final result = await casesRepository.addCase(caseModel);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: UserCasesStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(
        state.copyWith(
          status: UserCasesStatus.caseAdded,
          successMessage: 'تم تسجيل الحالة بنجاح',
        ),
      ),
    );
  }

  Future<void> getCaseDetails(String id) async {
    emit(state.copyWith(status: UserCasesStatus.loading));
    final result = await casesRepository.getCaseById(id);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: UserCasesStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (caseModel) => emit(
        state.copyWith(
          status: UserCasesStatus.success,
          selectedCase: caseModel,
        ),
      ),
    );
  }

  Future<void> exportToExcel() async {
    emit(state.copyWith(status: UserCasesStatus.loading));
    final result = await casesRepository.exportCasesToExcel();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: UserCasesStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (path) => emit(
        state.copyWith(
          status: UserCasesStatus.excelExported,
          excelPath: path,
          successMessage: 'تم تصدير البيانات إلى Excel بنجاح',
        ),
      ),
    );
  }
}
