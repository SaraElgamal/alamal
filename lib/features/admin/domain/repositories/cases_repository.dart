import 'package:charity_app/features/user/domain/entities/case_entity.dart';
import 'package:dartz/dartz.dart';
 import '../../../../core/errors/failures.dart';
import '../entities/case_entity.dart';

abstract class CasesRepository {
  Future<Either<Failure, List<UserCaseEntity>>> getCases();
  Future<Either<Failure, CaseEntity>> getCaseById(String id);
  Future<Either<Failure, void>> addCase(CaseEntity caseEntity);
  Future<Either<Failure, String>> exportCasesToExcel();
}
