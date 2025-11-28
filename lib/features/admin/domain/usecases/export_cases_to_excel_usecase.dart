import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/cases_repository.dart';

class ExportCasesToExcelUseCase {
  final CasesRepository repository;

  ExportCasesToExcelUseCase(this.repository);

  Future<Either<Failure, String>> call() async {
    return await repository.exportCasesToExcel();
  }
}
