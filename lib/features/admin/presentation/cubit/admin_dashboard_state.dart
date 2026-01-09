class AdminDashboardState {
  final int totalCases;
  final int urgentCases;
  final int totalDonationsCount;
  final int distinctDonorsCount;
  final double totalDonationsAmount;
  final double monthlyDonationsAmount;
  final bool isLoading;
  final String? errorMessage;

  AdminDashboardState({
    required this.totalCases,
    required this.urgentCases,
    required this.totalDonationsCount,
    required this.distinctDonorsCount,
    required this.totalDonationsAmount,
    required this.monthlyDonationsAmount,
    required this.isLoading,
    this.errorMessage,
  });

  factory AdminDashboardState.initial() {
    return AdminDashboardState(
      totalCases: 0,
      urgentCases: 0,
      totalDonationsCount: 0,
      distinctDonorsCount: 0,
      totalDonationsAmount: 0,
      monthlyDonationsAmount: 0,
      isLoading: false,
    );
  }

  AdminDashboardState copyWith({
    int? totalCases,
    int? urgentCases,
    int? totalDonationsCount,
    int? distinctDonorsCount,
    double? totalDonationsAmount,
    double? monthlyDonationsAmount,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AdminDashboardState(
      totalCases: totalCases ?? this.totalCases,
      urgentCases: urgentCases ?? this.urgentCases,
      totalDonationsCount: totalDonationsCount ?? this.totalDonationsCount,
      distinctDonorsCount: distinctDonorsCount ?? this.distinctDonorsCount,
      totalDonationsAmount: totalDonationsAmount ?? this.totalDonationsAmount,
      monthlyDonationsAmount:
          monthlyDonationsAmount ?? this.monthlyDonationsAmount,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
