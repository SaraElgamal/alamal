import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../di/donor_service.dart';
import '../models/donor_model.dart';
import '../repo/donor_repository.dart';

class DonorRepositoryImpl implements DonorRepository {
  final DonorsService donorsService;

  DonorRepositoryImpl({required this.donorsService});

  @override
  Future<Either<Failure, void>> addDonor(DonorModel donorModel) async {
    try {
      await donorsService.addDonor(donorModel);
      return const Right(null);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<Failure, List<DonorModel>>> getDonors() async {
    try {
      final donors = await donorsService.getDonors();
      return Right(donors);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  Failure _handleException(Object e) {
    if (e is FirebaseException) {
      if (e.code == 'unavailable' ||
          e.code == 'network-request-failed' ||
          e.code == 'deadline-exceeded') {
        return const NetworkFailure('لا يوجد اتصال بالانترنت');
      }
    } else if (e is SocketException) {
      return const NetworkFailure('لا يوجد اتصال بالانترنت');
    }
    return const ServerFailure('فيه مشكلة حاول ف وقت لاحق');
  }
}
