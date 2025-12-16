import 'package:charity_app/core/helpers/context_extension.dart';
import 'package:charity_app/core/helpers/url_launcher_helper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/navigation/routes/app_routes.dart';
import '../../data/models/case_model.dart';

class CaseDetailsScreen extends StatelessWidget {
  final CaseModel caseEntity;
  final bool showEditAction;

  const CaseDetailsScreen({
    super.key,
    required this.caseEntity,
    this.showEditAction = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(caseEntity.applicant.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          if (showEditAction)
            IconButton(
              icon:  Icon(Icons.edit, color: context.colors.primary,),
              onPressed: () {
                context.push(AppRoutes.editCase, extra: caseEntity);
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(context, 'بيانات مقدم الطلب'),
            _buildInfoRow('الاسم', caseEntity.applicant.name),
            _buildInfoRow('الرقم القومي', caseEntity.applicant.nationalId),
            _buildInfoRow('السن', caseEntity.applicant.age.toString()),
            _buildInfoRow('المهنة', caseEntity.applicant.profession),
            _buildInfoRow('الدخل', caseEntity.applicant.income.toString()),
            _buildInfoRow(
              'التليفون',
              caseEntity.applicant.phone,
              isPhone: true,
            ),
            _buildInfoRow('العنوان', caseEntity.applicant.address ?? '-'),

            if (caseEntity.spouse != null) ...[
              const Divider(),
              _buildSectionTitle(context, 'بيانات الزوج/الزوجة'),
              _buildInfoRow('الاسم', caseEntity.spouse!.name),
              _buildInfoRow('الرقم القومي', caseEntity.spouse!.nationalId),
              _buildInfoRow('السن', caseEntity.spouse!.age.toString()),
              _buildInfoRow('المهنة', caseEntity.spouse!.profession),
              _buildInfoRow('الدخل', caseEntity.spouse!.income.toString()),
              _buildInfoRow(
                'التليفون',
                caseEntity.spouse!.phone,
                isPhone: true,
              ),
            ],

            const Divider(),
            _buildSectionTitle(context, 'تفاصيل الحالة'),
            _buildInfoRow('التوصيف', caseEntity.caseDescription),
            _buildInfoRow(
              'دخل الأسرة الإجمالي',
              caseEntity.totalFamilyIncome.toString(),
            ),
            _buildInfoRow(
              'عدد أفراد الأسرة',
              caseEntity.familyMembers.length.toString(),
            ),

            const Divider(),
            _buildSectionTitle(context, 'المصروفات'),
            _buildInfoRow(
              'إجمالي المصروفات',
              caseEntity.expenses.total.toString(),
            ),
            // Add more details if needed
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isPhone = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
          if (isPhone && value.isNotEmpty) ...[
            IconButton(
              icon: const Icon(Icons.phone, color: Colors.green),
              onPressed: () => UrlLauncherHelper.openPhone(phone: value),
              tooltip: 'اتصال',
            ),
            IconButton(
              icon: const Icon(Icons.message, color: Colors.green),
              onPressed: () => UrlLauncherHelper.openWhatsApp(phone: value),
              tooltip: 'واتساب',
            ),
          ],
        ],
      ),
    );
  }
}
