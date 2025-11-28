 import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/case_entity.dart'  ;
import '../repositories/cases_repository.dart';

class AddCaseUseCase {
  final CasesRepository repository;

  AddCaseUseCase(this.repository);


  Future<Either<Failure, void>> call(CaseEntity caseEntity) async {
    return await repository.addCase(caseEntity);
  }
}
