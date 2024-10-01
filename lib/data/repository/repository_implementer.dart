

import 'package:dartz/dartz.dart';
import 'package:location_purge_maid_finder/data/mapper/mapper.dart';

import '../../domain/model/model.dart';
import '../../domain/repository/repository.dart';
import '../Request/request.dart';
import '../data_source/remote_data_source.dart';
import '../network/error_handler.dart';
import '../network/failure.dart';
import '../network_info.dart';

class RepositoryImplementer extends Repository {
  final RemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;
  RepositoryImplementer(this._remoteDataSource, this._networkInfo);
  @override
  Future<Either<Failure, Login>> login(LoginRequest loginRequest) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remoteDataSource.login(loginRequest);

        if (response.status == ApiInternalStatus.SUCCESS) {
          return Right(response.toDomain());
        } else {
          return Left(Failure(response.status ?? ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

}
