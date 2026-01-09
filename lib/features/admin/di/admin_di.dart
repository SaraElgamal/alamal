import 'package:charity_app/features/admin/presentation/cubit/admin_dashboard_cubit.dart';
import 'package:charity_app/features/admin/presentation/cubit/admin_donations_cubit.dart';
import 'package:get_it/get_it.dart';
import '../presentation/cubit/admin_cases_cubit.dart';
import '../data/repo/cases_repository.dart';
import '../data/repo_impl/cases_repository_impl.dart';
import 'cases_service.dart';

void initAdminDI(GetIt sl) {
  // Cubit
  sl.registerFactory(() => AdminCasesCubit(casesRepository: sl()));
  sl.registerFactory(() => AdminDashboardCubit(sl()));
  sl.registerFactory(() => AdminDonationsCubit(sl()));

  // Repository
  sl.registerLazySingleton<CasesRepository>(
    () => CasesRepositoryImpl(casesService: sl()),
  );

  // Services
  sl.registerLazySingleton<CasesService>(
    () => CasesServiceImpl(firestore: sl()),
  );
}
