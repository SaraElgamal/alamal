import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../models/donor_model.dart';

abstract class DonorRepository {
  Future<Either<Failure, void>> addDonor(DonorModel donorModel);
  Future<Either<Failure, List<DonorModel>>> getDonors();
}
