
import '../Request/request.dart';
import '../network/app_api.dart';
import '../responses/responses.dart';

abstract class RemoteDataSource {
  Future<LoginResponse> login(LoginRequest loginRequest);
  
}

class RemoteDataSourceImplementer implements RemoteDataSource {
  final AppServiceClient _appServiceClient;
  RemoteDataSourceImplementer(this._appServiceClient);

  @override
  Future<LoginResponse> login(LoginRequest loginRequest) async {
    return await _appServiceClient.login(
        loginRequest.uMAID, loginRequest.uEmail,loginRequest.uName,loginRequest.uOS);
  }

}
