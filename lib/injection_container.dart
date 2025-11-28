import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/theme/theme_cubit.dart';
import 'features/user/data/datasources/cases_remote_data_source.dart';
import 'features/user/data/repositories/cases_repository_impl.dart';
import 'features/user/domain/repositories/cases_repository.dart';
import 'features/user/domain/usecases/add_case_usecase.dart';
import 'features/user/domain/usecases/export_cases_to_excel_usecase.dart';
import 'features/user/domain/usecases/get_case_by_id_usecase.dart';
import 'features/user/domain/usecases/get_cases_usecase.dart';
import 'features/user/presentation/cubit/user_cases_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerFactory(() => ThemeCubit(sl()));

  // Features - User
  // Cubit
  sl.registerFactory(
    () => UserCasesCubit(
      addCase: sl(),
      getCases: sl(),
      getCaseById: sl(),
      exportCases: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => AddCaseUseCase(sl()));
  sl.registerLazySingleton(() => GetCasesUseCase(sl()));
  sl.registerLazySingleton(() => GetCaseByIdUseCase(sl()));
  sl.registerLazySingleton(() => ExportCasesToExcelUseCase(sl()));

  // Repository
  sl.registerLazySingleton<CasesRepository>(
    () => CasesRepositoryImpl(remoteDataSource: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<CasesRemoteDataSource>(
    () => CasesRemoteDataSourceImpl(firestore: sl()),
  );

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => FirebaseAuth.instance);
}
