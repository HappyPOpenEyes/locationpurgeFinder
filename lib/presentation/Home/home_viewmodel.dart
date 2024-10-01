import 'dart:async';

import 'package:dio/dio.dart';
import 'package:location_purge_maid_finder/data/network/failure.dart';

import '../../app/constants.dart';
import '../../domain/usecase/login_usercase.dart';
import '../base/base_viewmodel.dart';
import '../common/state_renderer/freezed_data_classes.dart';
import '../common/state_renderer/state_render_impl.dart';
import '../common/state_renderer/state_renderer.dart';
import '../resources/string_manager.dart';

class HomeViewModel extends BaseViewModel
    implements LoginViewModelInputs, LoginViewModelOutputs {
  final StreamController _emailAddressStreamController =
      StreamController<String>.broadcast();
 
  final StreamController _isAllInputsValidStreamController =
      StreamController<void>.broadcast();

  StreamController isUserLoggedInSuccessfullyStreamController =
      StreamController<bool>();

  StreamController isUserUserNotFoundStreamController =
      StreamController<bool>();

  final StreamController _isAllInputsValidStreamController1 =
      StreamController<void>.broadcast();

  var loginObject = LoginObject("", "","","");
  bool isAlreadyErrorState = false, isLoading = false;
  int value = 0;
  bool isCheckBoxSeleccted = false;
  bool isCustomer = false;
  bool isEmailInvalid = false;
  final LoginUseCase _loginUseCase;

  HomeViewModel(this._loginUseCase);

  // inputs
  @override
  void dispose() {
    _emailAddressStreamController.close();
     isUserUserNotFoundStreamController.close();
    _isAllInputsValidStreamController.close();
    _isAllInputsValidStreamController1.close();
    isUserLoggedInSuccessfullyStreamController.close();
  }

  @override
  void start() {
    inputState.add(ContentState());
    
  }



  @override
  Sink get inputEmailAddress => _emailAddressStreamController.sink;

  @override
  Sink get inputIsAllInputValid => _isAllInputsValidStreamController.sink;

  @override
  Sink get inputIsAllInputValid1 => _isAllInputsValidStreamController1.sink;

  @override
  login(String MAID,String OS) async {
    print(loginObject.uEmail);
    print("herre");
    isLoading = true;
    isAlreadyErrorState = false;
    inputState.add(
        LoadingState(stateRendererType: StateRendererType.POPUP_LOADING_STATE));
    (await _loginUseCase.execute(
            LoginUseCaseInput(
            MAID, loginObject.uEmail, loginObject.uName, OS)))
        .fold((failure) {
      // left -> failure
      value = 2;
      isLoading = false;
      inputState.add(ContentState());
      isUserLoggedInSuccessfullyStreamController.add(true);
      // inputState.add(ErrorState(
      //     StateRendererType.POPUP_ERROR_STATE,
      //     failure.code == 422
      //         ? AppStrings.emailInvalid
      //         : failure.code == 404
      //             ? "User is not registered"
      //             : failure.code == 400
      //                 ? AppStrings.passwordInvalid
      //                 : failure.message));
      // isAlreadyErrorState = true;
    }, (data) async {
    });
  }

  final dio = Dio();

  void request(String MAID, String OS) async {
    isLoading = true;
    isAlreadyErrorState = false;
    inputState.add(
        LoadingState(stateRendererType: StateRendererType.POPUP_LOADING_STATE));
    var formData = FormData.fromMap({
      'uMAID': MAID,
      'uEmail': loginObject.uEmail,
      'uName':"",
      'uOS': OS
    });
    Response response;
    response = await dio.post('https://avantisprivacy.com/id/add',data:formData);
    if(response.statusCode==200){
      isEmailInvalid = false;
      isLoading = false;
      inputState.add(ContentState());
      isUserUserNotFoundStreamController.add(false);
      isUserLoggedInSuccessfullyStreamController.add(true);
    }
    else if(response.statusCode == 400){
     isEmailInvalid = true;
      _validate1();
      isLoading = false;
      inputState.add(ContentState());
      isUserUserNotFoundStreamController.add(true);
    }
    else{
    value = 2;
    isLoading = false;
    inputState
        .add(ErrorState(StateRendererType.POPUP_ERROR_STATE, "Something Went to wrong."));
    isAlreadyErrorState = true;
    }

  }

  @override
  setEmailAddress(String emailAddress) {
    isEmailInvalid = false;
    _validate1();
    isUserUserNotFoundStreamController.add(false);
    print(emailAddress);
    inputEmailAddress.add(emailAddress);
    loginObject = loginObject.copyWith(
        uEmail: emailAddress); // data class operation same as kotlin
    print(loginObject.uEmail);
    _validate();
  }

  // outputs


  @override
  Stream<String?> get outputIsEmailAddressValid =>
      _emailAddressStreamController.stream
          .map((emailAddress) => _isEmailAddressValid(emailAddress));

  @override
  Stream<bool> get outputIsAllInputsValid =>
      _isAllInputsValidStreamController.stream.map((_) => _isAllInputsValid());

  @override
  Stream<bool> get outputIsAllInputsValid1 =>
      _isAllInputsValidStreamController1.stream.map((_) => _isAllInputsValid1());
  // private functions

  _validate() {
    inputIsAllInputValid.add(null);
  }

   _validate1() {
    inputIsAllInputValid1.add(null);
  }

  bool _isPasswordValid(String password) {
    return password.isNotEmpty;
  }

  bool _showPassword(bool showPassword) {
    return showPassword;
  }

  String? _isEmailAddressValid(String emailAddress) {
    if (emailAddress.isEmpty) {
      return AppStrings.emailAddressError;
    } else if (Constants.emailValidatorRegExp.hasMatch(emailAddress)) {
      return null;
    } else {
      return AppStrings.emailAddressInvalidError;
    }
  }

  bool _isAllInputsValid() {
    return _isEmailAddressValid(loginObject.uEmail) == null && isCheckBoxSeleccted && isCustomer;
  }

  bool _isAllInputsValid1() {
    return isEmailInvalid;
  }

  setContentState() {
    if (value % 2 == 0) {
      isAlreadyErrorState = false;
      inputState.add(ContentState());
    } else {
      value++;
    }
  }
  
  @override
  setPassword() {
    isCheckBoxSeleccted = !isCheckBoxSeleccted;
     _validate(); 
  }

    @override
  setIsCustomer() {
    isCustomer = !isCustomer;
    _validate();
  }
}

abstract class LoginViewModelInputs {
  // three functions for actions
  setEmailAddress(String emailAddress);
  setPassword();

  login(String MAID, String OS);

// two sinks for streams
  Sink get inputEmailAddress;

  Sink get inputIsAllInputValid;
}

abstract class LoginViewModelOutputs {
  Stream<String?> get outputIsEmailAddressValid;
  Stream<bool> get outputIsAllInputsValid;
}
