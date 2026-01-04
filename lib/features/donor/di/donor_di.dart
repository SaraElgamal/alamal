import 'package:get_it/get_it.dart';
import '../data/repo/donor_repository.dart';
import '../data/repo_impl/donor_repository_impl.dart';
import '../presentation/cubit/donor_cubit.dart';
import 'donor_service.dart';

void initDonorDI(GetIt sl) {
  // Service
  sl.registerLazySingleton<DonorsService>(
    () => DonorsServiceImpl(firestore: sl()),
  );

  // Repository
  sl.registerLazySingleton<DonorRepository>(
    () => DonorRepositoryImpl(donorsService: sl()),
  );

  // Cubit
  sl.registerFactory(() => DonorCubit(donorRepository: sl()));
}
