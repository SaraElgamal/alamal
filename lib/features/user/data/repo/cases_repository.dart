import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../models/case_model.dart';

abstract class CasesRepository {
  Future<Either<Failure, List<CaseModel>>> getCases();
  Future<Either<Failure, CaseModel>> getCaseById(String id);
  Future<Either<Failure, void>> addCase(CaseModel caseModel);
  Future<Either<Failure, void>> deleteCase(String id);
  Future<Either<Failure, void>> deleteAllCases();
  Future<Either<Failure, String>> exportCasesToExcel();
}
