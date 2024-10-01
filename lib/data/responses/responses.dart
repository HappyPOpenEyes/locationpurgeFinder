import 'package:json_annotation/json_annotation.dart';

part 'responses.g.dart';

@JsonSerializable()
class BaseResponse {
  @JsonKey(name: "code")
  int? status;
  @JsonKey(name: "message")
  String? message;
}

@JsonSerializable()
class LoginResponse extends BaseResponse {
  
  LoginResponse();

  //from JSON
  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  //to JSON
  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}

