import 'package:get_it/get_it.dart';
import '../presentation/cubit/admin_cases_cubit.dart';
import '../data/repo/cases_repository.dart';
import '../data/repo_impl/cases_repository_impl.dart';
import 'cases_service.dart';

void initAdminDI(GetIt sl) {
  // Cubit
  sl.registerFactory(() => AdminCasesCubit(casesRepository: sl()));

  // Repository
  sl.registerLazySingleton<CasesRepository>(
    () => CasesRepositoryImpl(casesService: sl()),
  );

  // Services
  sl.registerLazySingleton<CasesService>(
    () => CasesServiceImpl(firestore: sl()),
  );
}
