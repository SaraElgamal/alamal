import 'dart:io';
import 'package:charity_app/features/user/domain/entities/case_entity.dart';
import 'package:charity_app/features/user/domain/entities/person_entity.dart' as user_person;
import 'package:charity_app/features/user/domain/entities/expenses_entity.dart' as user_expenses;
import 'package:charity_app/features/user/domain/entities/aid_entity.dart' as user_aid;
import 'package:dartz/dartz.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/case_entity.dart' ; 
import '../../domain/repositories/cases_repository.dart';
import '../datasources/cases_remote_data_source.dart';
import '../models/case_model.dart';

class CasesRepositoryImpl implements CasesRepository {
  final CasesRemoteDataSource remoteDataSource;

  CasesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, void>> addCase(CaseEntity caseEntity) async {
    try {
      final caseModel = CaseModel.fromEntity(caseEntity);
      await remoteDataSource.addCase(caseModel);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<UserCaseEntity>>> getCases() async {
    try {
      final cases = await remoteDataSource.getCases();
      // remoteDataSource returns a List<CaseModel> (admin CaseModel extends admin CaseEntity)
      // but the repository contract expects List<UserCaseEntity>. Map each CaseModel
      // to a UserCaseEntity by copying fields. The two entity shapes are identical,
      // so this is a simple structural conversion.
      final List<UserCaseEntity> userCases = cases.map((c) {
        final applicant = user_person.PersonEntity(
          name: c.applicant.name,
          nationalId: c.applicant.nationalId,
          age: c.applicant.age,
          profession: c.applicant.profession,
          income: c.applicant.income,
          phone: c.applicant.phone,
          address: c.applicant.address,
        );

        final spouse = c.spouse != null
            ? user_person.PersonEntity(
                name: c.spouse!.name,
                nationalId: c.spouse!.nationalId,
                age: c.spouse!.age,
                profession: c.spouse!.profession,
                income: c.spouse!.income,
                phone: c.spouse!.phone,
                address: c.spouse!.address,
              )
            : null;

        final familyMembers = c.familyMembers
            .map((m) => user_person.PersonEntity(
                  name: m.name,
                  nationalId: m.nationalId,
                  age: m.age,
                  profession: m.profession,
                  income: m.income,
                  phone: m.phone,
                  address: m.address,
                ))
            .toList();

        final expenses = user_expenses.ExpensesEntity(
          rent: c.expenses.rent,
          electricity: c.expenses.electricity,
          water: c.expenses.water,
          gas: c.expenses.gas,
          education: c.expenses.education,
          treatment: c.expenses.treatment,
          debtRepayment: c.expenses.debtRepayment,
          other: c.expenses.other,
        );

        final aidHistory = c.aidHistory
            .map((a) => user_aid.AidEntity(
                  type: user_aid.AidType.values[a.type.index],
                  value: a.value,
                  date: a.date,
                ))
            .toList();

        return UserCaseEntity(
          id: c.id,
          applicant: applicant,
          spouse: spouse,
          caseDescription: c.caseDescription,
          familyMembers: familyMembers,
          rationCardCount: c.rationCardCount,
          pensionCount: c.pensionCount,
          expenses: expenses,
          aidHistory: aidHistory,
          createdAt: c.createdAt,
        );
      }).toList();

      return Right(userCases);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CaseEntity>> getCaseById(String id) async {
    try {
      final caseModel = await remoteDataSource.getCaseById(id);
      return Right(caseModel);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override

  Future<Either<Failure, String>> exportCasesToExcel() async {
    try {
      final cases = await remoteDataSource.getCases();
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
        'تاريخ التسجيل'
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

      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/cases_export_${DateTime.now().millisecondsSinceEpoch}.xlsx';
      File(path)
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes);

      return Right(path);
    } catch (e) {
      return Left(ExcelFailure(e.toString()));
    }
  }
}
