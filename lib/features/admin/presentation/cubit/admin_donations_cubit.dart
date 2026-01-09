import 'package:bloc/bloc.dart';
import 'package:charity_app/features/admin/data/models/donation_model.dart';
import 'package:charity_app/core/helpers/excel_helper.dart'; // Import Helper
import 'package:cloud_firestore/cloud_firestore.dart';

part 'admin_donations_state.dart';

class AdminDonationsCubit extends Cubit<AdminDonationsState> {
  final FirebaseFirestore _firestore;

  AdminDonationsCubit(this._firestore) : super(AdminDonationsState.initial());

  Future<void> loadDonations() async {
    emit(state.copyWith(status: AdminDonationsStatus.loading));
    try {
      final snapshot = await _firestore
          .collection('donations')
          .orderBy('date', descending: true)
          .get();

      final donations = snapshot.docs
          .map((doc) => DonationModel.fromFirestore(doc))
          .toList();

      emit(
        state.copyWith(
          status: AdminDonationsStatus.success,
          donations: donations,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AdminDonationsStatus.error,
          errorMessage: 'فشل تحميل التبرعات: $e',
        ),
      );
    }
  }

  Future<void> deleteDonation(String id) async {
    // Only update loading state for deletion if needed, or handle pessimistically
    // For now, let's just do it directly.
    try {
      await _firestore.collection('donations').doc(id).delete();

      final updatedDonations = state.donations
          .where((d) => d.id != id)
          .toList();

      emit(
        state.copyWith(
          donations: updatedDonations,
          deleteSuccessMessage: 'تم حذف التبرع بنجاح',
        ),
      );

      // Clear message after a bit
      Future.delayed(const Duration(seconds: 3), () {
        emit(state.copyWith(deleteSuccessMessage: null));
      });
    } catch (e) {
      emit(
        state.copyWith(
          status: AdminDonationsStatus.error,
          errorMessage: 'فشل حذف التبرع: $e',
        ),
      );
    }
  }

  Stream<double> exportDonations() {
    final listToExport = state.isFiltering
        ? state.filteredDonations
        : state.donations;
    return ExcelHelper.exportDonationsWithProgress(
      listToExport,
      onComplete: (path) => emit(
        state.copyWith(
          successMessage: 'تم التصدير: $path',
          excelPath: path,
          status: AdminDonationsStatus.excelExported,
        ),
      ),
      onError: (err) => emit(
        state.copyWith(errorMessage: err, status: AdminDonationsStatus.error),
      ),
    );
  }

  void searchDonations(String query) {
    if (query.isEmpty) {
      emit(state.copyWith(isFiltering: false, filteredDonations: []));
      return;
    }

    final filtered = state.donations.where((d) {
      final matchesName = d.name.toLowerCase().contains(query.toLowerCase());
      final matchesPhone = d.phone.contains(query);
      return matchesName || matchesPhone;
    }).toList();

    emit(state.copyWith(isFiltering: true, filteredDonations: filtered));
  }
}
