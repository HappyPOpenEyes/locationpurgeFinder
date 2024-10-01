import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
part 'freezed_data_classes.freezed.dart';


@freezed
class LoginObject with _$LoginObject {
  factory LoginObject(String uMAID, String uEmail, String uName, String uOS) = _LoginObject;
}

