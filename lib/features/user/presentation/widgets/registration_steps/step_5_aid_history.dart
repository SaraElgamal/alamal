import 'package:charity_app/features/user/data/models/aid_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class Step5AidHistory extends StatelessWidget {
  final List<AidModel> aidHistory;
  final VoidCallback onAddAid;
  final ValueChanged<int> onDeleteAid;

  const Step5AidHistory({
    super.key,
    required this.aidHistory,
    required this.onAddAid,
    required this.onDeleteAid,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'سجل المساعدات السابقة',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
              TextButton.icon(
                onPressed: onAddAid,
                icon: const Icon(Icons.add_circle),
                label: const Text('إضافة مساعدة'),
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),

          if (aidHistory.isEmpty)
            Container(
              padding: EdgeInsets.all(32.r),
              margin: EdgeInsets.symmetric(vertical: 20.h),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.history_edu,
                    size: 48.sp,
                    color: Colors.grey.shade400,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'لا توجد مساعدات سابقة مسجلة',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'إذا حصلت الأسرة على مساعدات سابقة، يرجى إضافتها هنا.',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 12.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: aidHistory.length,
              itemBuilder: (context, index) {
                final aid = aidHistory[index];
                final isCash = aid.type == AidType.cash;
                return Card(
                  margin: EdgeInsets.only(bottom: 8.h),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isCash
                          ? Colors.green.withValues(alpha: 0.1)
                          : Colors.orange.withValues(alpha: 0.1),
                      child: Icon(
                        isCash
                            ? Icons.attach_money
                            : Icons.inventory_2_outlined,
                        color: isCash ? Colors.green : Colors.orange,
                      ),
                    ),
                    title: Text(
                      isCash ? 'مساعدة نقدية' : 'مساعدة عينية',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('القيمة/الوصف: ${aid.value}'),
                        Text(
                          'التاريخ: ${DateFormat('yyyy-MM-dd').format(aid.date)}',
                          style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => onDeleteAid(index),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
