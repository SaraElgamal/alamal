import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../core/errors/failures.dart';
import '../repo/cases_repository.dart';
import '../../di/cases_service.dart';
import '../models/case_model.dart';

class CasesRepositoryImpl implements CasesRepository {
  final CasesService casesService;

  CasesRepositoryImpl({required this.casesService});

  @override
  Future<Either<Failure, void>> addCase(CaseModel caseModel) async {
    try {
      await casesService.addCase(caseModel);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CaseModel>>> getCases({
    int? limit,
    String? lastCaseId,
  }) async {
    try {
      final cases = await casesService.getCases(
        limit: limit,
        lastCaseId: lastCaseId,
      );
      return Right(cases);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CaseModel>> getCaseById(String id) async {
    try {
      final caseModel = await casesService.getCaseById(id);
      return Right(caseModel);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> exportCasesToExcel() async {
    try {
      final cases = await casesService.getCases();
      var excel = Excel.createExcel();
      Sheet sheetObject = excel['Sheet1'];

      // Headers
      List<String> headers = [
        'الاسم',
        'الرقم القومي',
        'السن',
        'المهنة',
        'الدخل',
        'رقم التليفون',
        'العنوان',
        'الحالة',
        'اسم الزوج',
        'دخل الاسرة',
        'عدد الافراد',
        'المصروفات',
        'تاريخ التسجيل',
      ];
      sheetObject.appendRow(headers.map((e) => TextCellValue(e)).toList());

      for (var c in cases) {
        List<CellValue> row = [
          TextCellValue(c.applicant.name),
          TextCellValue(c.applicant.nationalId),
          IntCellValue(c.applicant.age),
          TextCellValue(c.applicant.profession),
          DoubleCellValue(c.applicant.income),
          TextCellValue(c.applicant.phone),
          TextCellValue(c.applicant.address ?? ''),
          TextCellValue(c.caseDescription),
          TextCellValue(c.spouse?.name ?? 'لا يوجد'),
          DoubleCellValue(c.totalFamilyIncome),
          IntCellValue(c.familyMembers.length + 1 + (c.spouse != null ? 1 : 0)),
          DoubleCellValue(c.expenses.total),
          TextCellValue(c.createdAt.toString().split(' ')[0]),
        ];
        sheetObject.appendRow(row);
      }

      var fileBytes = excel.save();
      if (fileBytes == null) {
        return const Left(ExcelFailure('Failed to generate Excel file'));
      }

      final directory = await getDownloadsDirectory();
      if (directory == null) {
        return const Left(ExcelFailure('Could not access Downloads directory'));
      }
      final path =
          '${directory.path}/cases_export_${DateTime.now().millisecondsSinceEpoch}.xlsx';
      File(path)
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes);

      return Right(path);
    } catch (e) {
      return Left(ExcelFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCase(String id) async {
    try {
      await casesService.deleteCase(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAllCases() async {
    try {
      await casesService.deleteAllCases();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateCase(CaseModel caseModel) async {
    try {
      await casesService.updateCase(caseModel);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
