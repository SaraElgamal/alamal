import 'package:flutter/material.dart';

class ValidationUtils {
  // التحقق من الرقم القومي (14 رقم)
  static String? validateNationalId(String? value) {
    if (value == null || value.isEmpty) {
      return 'الرقم القومي مطلوب';
    }
    
    if (value.length != 14) {
      return 'الرقم القومي يجب أن يكون 14 رقم';
    }
    
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'الرقم القومي يجب أن يحتوي على أرقام فقط';
    }
    
    return null;
  }

  // التحقق من رقم الهاتف (11 رقم)
  static String? validatePhone(String? value, {bool required = false}) {
    if (value == null || value.isEmpty) {
      return required ? 'رقم الهاتف مطلوب' : null;
    }
    
    if (value.length != 11) {
      return 'رقم الهاتف يجب أن يكون 11 رقم';
    }
    
    if (!RegExp(r'^01[0-2,5]{1}[0-9]{8}$').hasMatch(value)) {
      return 'رقم الهاتف يجب أن يبدأ بـ 010 أو 011 أو 012 أو 015';
    }
    
    return null;
  }

  // التحقق من الأرقام الموجبة
  static String? validatePositiveNumber(String? value, {bool required = false}) {
    if (value == null || value.isEmpty) {
      return required ? 'هذا الحقل مطلوب' : null;
    }
    
    final number = int.tryParse(value);
    if (number == null) {
      return 'يرجى إدخال رقم صحيح';
    }
    
    if (number < 0) {
      return 'يجب أن يكون الرقم موجب';
    }
    
    return null;
  }

  // التحقق من المبالغ المالية
  static String? validateAmount(String? value, {bool required = false}) {
    if (value == null || value.isEmpty) {
      return required ? 'هذا الحقل مطلوب' : null;
    }
    
    final amount = double.tryParse(value);
    if (amount == null) {
      return 'يرجى إدخال مبلغ صحيح';
    }
    
    if (amount < 0) {
      return 'يجب أن يكون المبلغ موجب';
    }
    
    return null;
  }

  // التحقق من النصوص المطلوبة
  static String? validateRequired(String? value, {String fieldName = 'هذا الحقل'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName مطلوب';
    }
    
    return null;
  }

  // التحقق من الاسم (يجب أن يحتوي على حرفين على الأقل)
  static String? validateName(String? value, {bool required = true}) {
    if (value == null || value.trim().isEmpty) {
      return required ? 'الاسم مطلوب' : null;
    }
    
    if (value.trim().length < 2) {
      return 'الاسم يجب أن يكون حرفين على الأقل';
    }
    
    return null;
  }

  // التحقق من السن
  static String? validateAge(String? value, {bool required = false}) {
    if (value == null || value.isEmpty) {
      return required ? 'السن مطلوب' : null;
    }
    
    final age = int.tryParse(value);
    if (age == null) {
      return 'يرجى إدخال سن صحيح';
    }
    
    if (age < 0 || age > 150) {
      return 'السن غير صحيح';
    }
    
    return null;
  }
}
