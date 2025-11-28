import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/case_entity.dart';

abstract class CasesRepository {
  Future<Either<Failure, List<UserCaseEntity>>> getCases();
  Future<Either<Failure, UserCaseEntity>> getCaseById(String id);
  Future<Either<Failure, void>> addCase(UserCaseEntity caseEntity);
  Future<Either<Failure, String>> exportCasesToExcel();
}
