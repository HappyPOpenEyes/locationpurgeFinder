import 'package:dartz/dartz.dart';
import '../../data/Request/request.dart';
import '../../data/network/failure.dart';
import '../model/model.dart';

abstract class Repository {
  Future<Either<Failure, Login>> login(
    LoginRequest loginRequest,
  );
}


