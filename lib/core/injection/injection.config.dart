// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../../pages/controller/poll_controller.dart' as _i8;
import '../data/http_client/dio_client.dart' as _i4;
import '../data/http_client/http_client.dart' as _i3;
import '../data/poll_data_source/poll_data_source.dart' as _i5;
import '../data/poll_data_source/poll_web_source.dart' as _i6;
import '../domain/repositories/poll_repository.dart' as _i7;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.factory<_i3.HttpClient>(() => _i4.DioClient());
    gh.factory<_i5.PollsDataSource>(
        () => _i6.PollsWebSource(gh<_i3.HttpClient>()));
    gh.factory<_i7.PollsRepository>(
        () => _i7.PollsRepository(gh<_i5.PollsDataSource>()));
    gh.factory<_i8.PollController>(
        () => _i8.PollController(gh<_i7.PollsRepository>()));
    return this;
  }
}
