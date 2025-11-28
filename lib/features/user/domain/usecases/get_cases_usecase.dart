import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/case_entity.dart';
import '../repositories/cases_repository.dart';

class GetCasesUseCase {
  final CasesRepository repository;

  GetCasesUseCase(this.repository);

  Future<Either<Failure, List<UserCaseEntity>>> call() async {
    return await repository.getCases();
  }
}
