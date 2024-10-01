//import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:location_purge_maid_finder/presentation/Home/home_viewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/data_source/remote_data_source.dart';
import '../data/network/app_api.dart';
import '../data/network/dio_factory.dart';
import '../data/network_info.dart';
import '../data/repository/repository_implementer.dart';
import '../domain/repository/repository.dart';

import '../domain/usecase/login_usercase.dart';
import 'app_prefs.dart';

final instance = GetIt.instance;

Future<void> initAppModule() async {
  final sharedPrefs = await SharedPreferences.getInstance();

  // shared prefs instance
  instance.registerFactory<SharedPreferences>(() => sharedPrefs);

  // app prefs instance
  instance.registerFactory<AppPreferences>(() => AppPreferences(instance()));

  // network info
  instance.registerFactory<InternetConnectionChecker>(() => InternetConnectionChecker());
  instance.registerFactory<NetworkInfo>(() => NetworkInfoImplementer(instance()));
  // instance
  //     .registerFactory<NetworkInfo>(() => NetworkInfoImplementer(instance()));

  // dio factory
  instance.registerFactory<DioFactory>(() => DioFactory(instance()));

  // app  service client
  final dio = await instance<DioFactory>().getDio();
  instance.registerFactory<AppServiceClient>(() => AppServiceClient(dio));

  // remote data source
  instance.registerFactory<RemoteDataSource>(
      () => RemoteDataSourceImplementer(instance()));

  // repository
  instance.registerFactory<Repository>(
      () => RepositoryImplementer(instance(), instance()));

}

initLoginModule() {
  if (!GetIt.I.isRegistered<LoginUseCase>()) {
    instance.registerFactory<LoginUseCase>(() => LoginUseCase(instance()));

    instance.registerFactory<HomeViewModel>(
        () => HomeViewModel(instance()));
  }
 
}



  // if (!GetIt.I.isRegistered<ProfileUpdateUseCase>()) {
  //   instance.registerFactory<ProfileUpdateUseCase>(
  //       () => ProfileUpdateUseCase(instance()));
  //   instance.registerFactory<ChangePasswordUseCase>(
  //       () => ChangePasswordUseCase(instance()));
  //   instance.registerFactory<GetOrganizationListUseCase>(
  //       () => GetOrganizationListUseCase(instance()));
  //   instance.registerFactory<ProfileViewModel>(
  //       () => ProfileViewModel(instance(), instance(), instance()));
  // }

