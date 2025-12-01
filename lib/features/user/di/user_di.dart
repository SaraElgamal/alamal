import 'package:get_it/get_it.dart';
import '../data/repo/cases_repository.dart';
import '../data/repo_impl/cases_repository_impl.dart';
import 'cases_service.dart';
import '../presentation/cubit/user_cases_cubit.dart';

void initUserDI(GetIt sl) {
  // Cubit
  sl.registerFactory(() => UserCasesCubit(casesRepository: sl()));

  // Repository
  sl.registerLazySingleton<CasesRepository>(
    () => CasesRepositoryImpl(casesService: sl()),
  );

  // Service
  sl.registerLazySingleton<CasesService>(
    () => CasesServiceImpl(firestore: sl()),
  );
}
