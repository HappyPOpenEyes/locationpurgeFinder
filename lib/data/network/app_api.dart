import 'dart:ffi';
import 'dart:io';

import 'package:analyzer/dart/element/type.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../app/constants.dart';
import '../responses/responses.dart';
part 'app_api.g.dart';

@RestApi(baseUrl: Constants.baseUrl)
abstract class AppServiceClient {
  factory AppServiceClient(Dio dio, {String baseUrl}) = _AppServiceClient;

  @POST("/add")
  Future<LoginResponse> login(
    @Field("uMAID") String uMAID,
    @Field("uEmail") String uEmail,
    @Field("uName") String uName,
    @Field("uOS") String uOS,
  );

}
