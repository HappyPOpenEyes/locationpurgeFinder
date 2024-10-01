import 'package:dartz/dartz.dart';


import '../../data/Request/request.dart';
import '../../data/network/failure.dart';
import '../model/model.dart';
import '../repository/repository.dart';
import 'base_usercase.dart';

class LoginUseCase implements BaseUseCase<LoginUseCaseInput, Login> {
  final Repository _repository;

  LoginUseCase(this._repository);

  @override
  Future<Either<Failure, Login>> execute(
      LoginUseCaseInput input) async {
    return await _repository
        .login(LoginRequest(input.uMAID, input.uEmail, input.uName, input.uOS));
  }
}

class LoginUseCaseInput {
  String uMAID;
  String uEmail;
  String uName;
  String uOS;

  LoginUseCaseInput(this.uMAID, this.uEmail,this.uName,this.uOS);
}
