import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin_dashboard_state.dart';

class AdminDashboardCubit extends Cubit<AdminDashboardState> {
  final FirebaseFirestore _firestore;

  AdminDashboardCubit(this._firestore) : super(AdminDashboardState.initial());

  Future<void> loadStats() async {
    emit(state.copyWith(isLoading: true));
    try {
      // 1. Total Cases & Urgent Cases
      // Use 'registrationDataForUsers' as confirmed in CasesService
      final casesCollection = _firestore.collection('registrationDataForUsers');

      final allCasesSnapshot = await casesCollection.get();
      int urgentCount = 0;

      for (var doc in allCasesSnapshot.docs) {
        final data = doc.data();
        // Logic: Marked as critical OR very low income (e.g. < 1000)
        final isCritical = data['isCritical'] == true;

        // Check expenses vs income if available to determine urgency implicitly?
        // For now rely on the boolean flag often set by admin or during registration logic
        if (isCritical) {
          urgentCount++;
        }
      }

      // 2. Donations Stats
      final now = DateTime.now();
      final startOfMonth = DateTime(now.year, now.month, 1);

      // Use 'donations' collection
      final donationsSnapshot = await _firestore.collection('donations').get();

      int totalDonationsCount = donationsSnapshot.size;
      double totalAmount = 0;
      double monthlyAmount = 0;
      Set<String> uniqueDonorPhones = {};

      for (var doc in donationsSnapshot.docs) {
        final data = doc.data();
        final dateStr = data['date'] as String?;
        final amount = (data['amount'] is int)
            ? (data['amount'] as int).toDouble()
            : (data['amount'] as double? ?? 0.0);

        final phone = data['phone'] as String?;
        if (phone != null && phone.isNotEmpty) {
          uniqueDonorPhones.add(phone);
        }

        totalAmount += amount; // Accumulate all time

        if (dateStr != null) {
          final date = DateTime.tryParse(dateStr);
          if (date != null && date.isAfter(startOfMonth)) {
            monthlyAmount += amount;
          }
        }
      }

      emit(
        state.copyWith(
          isLoading: false,
          totalCases: allCasesSnapshot.size,
          urgentCases: urgentCount,
          totalDonationsCount: totalDonationsCount,
          distinctDonorsCount: uniqueDonorPhones.length,
          totalDonationsAmount: totalAmount,
          monthlyDonationsAmount: monthlyAmount,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'فشل تحميل الإحصائيات: $e',
        ),
      );
    }
  }
}
