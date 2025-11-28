import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/case_entity.dart';
import '../repositories/cases_repository.dart';

class GetCaseByIdUseCase {
  final CasesRepository repository;

  GetCaseByIdUseCase(this.repository);

  Future<Either<Failure, UserCaseEntity>> call(String id) async {
    return await repository.getCaseById(id);
  }
}
