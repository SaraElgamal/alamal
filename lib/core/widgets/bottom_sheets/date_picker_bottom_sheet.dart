import 'package:charity_app/core/helpers/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Bottom sheet for selecting a date
class DatePickerBottomSheet extends StatefulWidget {
  final DateTime? selectedDate;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const DatePickerBottomSheet({
    super.key,
    this.selectedDate,
    this.firstDate,
    this.lastDate,
  });

  @override
  State<DatePickerBottomSheet> createState() => _DatePickerBottomSheetState();
}

class _DatePickerBottomSheetState extends State<DatePickerBottomSheet> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: context.colors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Select Date',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: context.colors.text,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close, color: context.colors.text),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Date Picker
          SizedBox(
            height: 350.h,
            child: Theme(
              data: Theme.of(context).copyWith(
                textTheme: Theme.of(context).textTheme.copyWith(
                      bodySmall: TextStyle(fontSize: 14.sp),
                      bodyMedium: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                    ),
              ),
              child: CalendarDatePicker(
                initialDate: _selectedDate,
                firstDate: widget.firstDate ?? DateTime(2000),
                lastDate: widget.lastDate ?? DateTime.now(),
                onDateChanged: (date) {
                  setState(() => _selectedDate = date);
                },
              ),
            ),
          ),

          SizedBox(height: 16.h),

          // Actions
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context, _selectedDate),
                  child: const Text('Confirm'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
