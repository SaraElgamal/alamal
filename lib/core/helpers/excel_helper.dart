import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:charity_app/features/admin/data/models/case_model.dart';
import 'package:path_provider/path_provider.dart';
import '../../features/admin/data/models/donation_model.dart';

class ExcelHelper {
  // Simulates progress reporting
  static Stream<double> exportCasesWithProgress(
    List<CaseModel> cases, {
    required Function(String path) onComplete,
    required Function(String error) onError,
  }) async* {
    var excel = Excel.createExcel();

    // CRITICAL FIX: Rename default "Sheet1" instead of creating "Cases"
    // This ensures ONLY ONE sheet exists.
    String defaultSheet = excel.getDefaultSheet() ?? 'Sheet1';
    excel.rename(defaultSheet, 'جميع الحالات');
    Sheet sheetObject = excel['جميع الحالات'];

    // Professional Headers - ALL DATA
    List<String> headers = [
      'حالة رقم',
      'الاسم رباعي',
      'الرقم القومي',
      'رقم الهاتف',
      'العنوان',
      'السن',
      'المهنة',
      'الدخل الشخصي',
      'الحالة الاجتماعية',

      // Spouse Info
      'اسم الزوج/ة',
      'رقم قومي الزوج/ة',
      'مهنة الزوج/ة',
      'تليفون الزوج/ة',
      'دخل الزوج/ة',

      // Family Info
      'عدد الأبناء',
      'تفاصيل الأبناء (الاسم - السن - المهنة)',

      // Income & Financials
      'الدخل الشهري الكلي (محسوب)',
      'الدخل الشهري الكلي (يدوي/بحث)',
      'بطاقات التموين',
      'عدد المعاشات',

      // Expenses Breakdown
      'إيجار',
      'كهرباء',
      'مياه',
      'غاز',
      'تعليم',
      'علاج',
      'ديون',
      'مصروفات أخرى',
      'إجمالي المصروفات',
      'صافي الدخل (الدخل - المصروفات)',

      // Metadata
      'تاريخ التسجيل',
      'وصف الحالة',
      'المساعدات السابقة',
    ];

    // Start Append
    sheetObject.appendRow(headers.map((e) => TextCellValue(e)).toList());

    double total = cases.length.toDouble();
    if (total == 0) yield 100.0;

    for (var i = 0; i < cases.length; i++) {
      final item = cases[i];
      await Future.delayed(const Duration(microseconds: 1)); // Minimal delay

      // Logic
      final netIncome = item.manualTotalFamilyIncome - item.expenses.total;

      // Family Flatten
      String familyDetails = item.familyMembers.isEmpty
          ? 'لا يوجد'
          : item.familyMembers
                .map((m) => '${m.name} (${m.age}س/${m.profession})')
                .join(' - ');

      // Aid Flatten
      String aidDetails = item.aidHistory.isEmpty
          ? 'لا يوجد'
          : item.aidHistory
                .map((a) => '${a.type.name} (${a.value})')
                .join(' - ');

      List<CellValue> row = [
        IntCellValue(i + 1),
        TextCellValue(item.applicant.name),
        TextCellValue(item.applicant.nationalId),
        TextCellValue(item.applicant.phone),
        TextCellValue(item.applicant.address ?? 'غير محدد'),
        IntCellValue(item.applicant.age),
        TextCellValue(item.applicant.profession),
        DoubleCellValue(item.applicant.income),

        TextCellValue(item.spouse != null ? 'متزوج' : 'غير متزوج'),

        // Spouse
        TextCellValue(item.spouse?.name ?? '-'),
        TextCellValue(item.spouse?.nationalId ?? '-'),
        TextCellValue(item.spouse?.profession ?? '-'),
        TextCellValue(item.spouse?.phone ?? '-'),
        DoubleCellValue(item.spouse?.income ?? 0.0),

        // Family
        IntCellValue(item.familyMembers.length),
        TextCellValue(familyDetails),

        // Income
        DoubleCellValue(item.calculatedTotalFamilyIncome),
        DoubleCellValue(item.manualTotalFamilyIncome),
        IntCellValue(item.rationCardCount),
        IntCellValue(item.pensionCount),

        // Expenses
        DoubleCellValue(item.expenses.rent),
        DoubleCellValue(item.expenses.electricity),
        DoubleCellValue(item.expenses.water),
        DoubleCellValue(item.expenses.gas),
        DoubleCellValue(item.expenses.education),
        DoubleCellValue(item.expenses.treatment),
        DoubleCellValue(item.expenses.debtRepayment),
        DoubleCellValue(item.expenses.other),
        DoubleCellValue(item.expenses.total),
        DoubleCellValue(netIncome),

        // Meta
        TextCellValue(DateFormat('yyyy-MM-dd').format(item.createdAt)),
        TextCellValue(item.caseDescription),
        TextCellValue(aidDetails),
      ];

      sheetObject.appendRow(row);
      yield ((i + 1) / total) * 100;
    }

    try {
      final directory = await getApplicationDocumentsDirectory();
      final now = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final path = '${directory.path}/cases_export_$now.xlsx';

      final fileBytes = excel.save();
      if (fileBytes != null) {
        File(path)
          ..createSync(recursive: true)
          ..writeAsBytesSync(fileBytes);
        onComplete(path);
      } else {
        onError('فشل في إنشاء ملف الإكسل');
      }
    } catch (e) {
      onError(e.toString());
    }
  }

  static Stream<double> exportDonationsWithProgress(
    List<DonationModel> donations, {
    required Function(String path) onComplete,
    required Function(String error) onError,
  }) async* {
    var excel = Excel.createExcel();
    String defaultSheet = excel.getDefaultSheet() ?? 'Sheet1';
    excel.rename(defaultSheet, 'سجل التبرعات');
    Sheet sheetObject = excel['سجل التبرعات'];

    List<String> headers = [
      'م',
      'اسم المتبرع',
      'رقم الهاتف',
      'قيمة التبرع',
      'تاريخ التبرع',
      'نوع التبرع',
      'وصف/ملاحظات',
    ];
    sheetObject.appendRow(headers.map((e) => TextCellValue(e)).toList());

    double total = donations.length.toDouble();
    if (total == 0) yield 100.0;

    for (var i = 0; i < donations.length; i++) {
      final item = donations[i];
      await Future.delayed(const Duration(milliseconds: 1));

      List<CellValue> row = [
        IntCellValue(i + 1),
        TextCellValue(item.name),
        TextCellValue(item.phone),
        DoubleCellValue(item.amount),
        TextCellValue(DateFormat('yyyy-MM-dd HH:mm').format(item.date)),
        IntCellValue(
          item.donationType,
        ), // Could map to string if we have enum names
        TextCellValue(item.description ?? ''),
      ];
      sheetObject.appendRow(row);

      yield ((i + 1) / total) * 100;
    }

    try {
      final directory = await getApplicationDocumentsDirectory();
      final now = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final path = '${directory.path}/donations_$now.xlsx';

      final fileBytes = excel.save();
      if (fileBytes != null) {
        File(path)
          ..createSync(recursive: true)
          ..writeAsBytesSync(fileBytes);
        onComplete(path);
      } else {
        onError('فشل في إنشاء ملف الإكسل');
      }
    } catch (e) {
      onError(e.toString());
    }
  }
}
