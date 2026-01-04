import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/donor_model.dart';
import '../../data/repo/donor_repository.dart';

enum DonorStatus { initial, loading, success, error }

class DonorState extends Equatable {
  final DonorStatus status;
  final List<DonorModel> donors;
  final String? errorMessage;
  final String? successMessage;

  const DonorState({
    this.status = DonorStatus.initial,
    this.donors = const [],
    this.errorMessage,
    this.successMessage,
  });

  DonorState copyWith({
    DonorStatus? status,
    List<DonorModel>? donors,
    String? errorMessage,
    String? successMessage,
  }) {
    return DonorState(
      status: status ?? this.status,
      donors: donors ?? this.donors,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
    );
  }

  @override
  List<Object?> get props => [status, donors, errorMessage, successMessage];
}

class DonorCubit extends Cubit<DonorState> {
  final DonorRepository donorRepository;

  DonorCubit({required this.donorRepository}) : super(const DonorState());

  Future<void> addDonor(DonorModel donorModel) async {
    emit(state.copyWith(status: DonorStatus.loading));
    final result = await donorRepository.addDonor(donorModel);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: DonorStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(
        state.copyWith(
          status: DonorStatus.success,
          successMessage: 'شكراً لمساهمتك الكريمة',
        ),
      ),
    );
  }

  Future<void> loadDonors() async {
    emit(state.copyWith(status: DonorStatus.loading));
    final result = await donorRepository.getDonors();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: DonorStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (donors) =>
          emit(state.copyWith(status: DonorStatus.success, donors: donors)),
    );
  }
}
