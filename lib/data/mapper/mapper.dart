import 'package:location_purge_maid_finder/app/extension.dart';
import '../../domain/model/model.dart';
import '../responses/responses.dart';

const EMPTY = "";
const ZERO = 0;

extension LoginResponseMapper on LoginResponse? {
  Login toDomain() {
    return Login();
  }
}


