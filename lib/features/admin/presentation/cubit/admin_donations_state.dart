part of 'admin_donations_cubit.dart';

enum AdminDonationsStatus { initial, loading, success, error, excelExported }

class AdminDonationsState {
  final AdminDonationsStatus status;
  final List<DonationModel> donations;
  final List<DonationModel> filteredDonations;
  final bool isFiltering;
  final String? errorMessage;
  final String? deleteSuccessMessage;
  final String? excelPath;
  final String? successMessage;

  const AdminDonationsState({
    required this.status,
    required this.donations,
    required this.filteredDonations,
    required this.isFiltering,
    this.errorMessage,
    this.deleteSuccessMessage,
    this.excelPath,
    this.successMessage,
  });

  factory AdminDonationsState.initial() {
    return const AdminDonationsState(
      status: AdminDonationsStatus.initial,
      donations: [],
      filteredDonations: [],
      isFiltering: false,
    );
  }

  AdminDonationsState copyWith({
    AdminDonationsStatus? status,
    List<DonationModel>? donations,
    List<DonationModel>? filteredDonations,
    bool? isFiltering,
    String? errorMessage,
    String? deleteSuccessMessage,
    String? excelPath,
    String? successMessage,
  }) {
    return AdminDonationsState(
      status: status ?? this.status,
      donations: donations ?? this.donations,
      filteredDonations: filteredDonations ?? this.filteredDonations,
      isFiltering: isFiltering ?? this.isFiltering,
      errorMessage: errorMessage,
      deleteSuccessMessage: deleteSuccessMessage,
      excelPath:
          excelPath, // Optional: Clear if not provided? No, keep it or allow null update.
      successMessage: successMessage,
    );
  }
}
