import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/theme/theme_cubit.dart';
import 'features/user/di/user_di.dart';
import 'features/admin/di/admin_di.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerFactory(() => ThemeCubit(sl()));

  // Features - User
  initUserDI(sl);

  // Features - Admin
  initAdminDI(sl);

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => FirebaseAuth.instance);
}
