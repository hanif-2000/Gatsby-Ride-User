import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../utility/helper.dart';
import '../../utility/image_picker_helper.dart';

class FormProvider with ChangeNotifier {
  // initial
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController =
      TextEditingController(text: kDebugMode ? "testdev@gmail.com" : '');
  final TextEditingController _emailConfirmController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController =
      TextEditingController(text: kDebugMode ? "Pass@123" : '');
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _contactMessageController =
      TextEditingController();

  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardCvvController = TextEditingController();
  final TextEditingController _accountHolderController =
      TextEditingController();
  final TextEditingController _expiryController = TextEditingController();

  // final TextEditingController _otpController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _emailError = false;
  bool _emailConfirmError = false;
  bool _passwordError = false;
  bool _confirmPasswordError = false;
  bool _phoneError = false;
  bool _nameError = false;
  bool _checkBox = false;

  final _imagePicker = ImagePicker();
  dynamic _imagePickerError;
  XFile? _imageFile;
  bool _returnData = false;

  // setter

  set setEmailError(val) {
    _emailError = val;
    notifyListeners();
  }

  set setEmailConfirmError(val) {
    _emailConfirmError = val;
    notifyListeners();
  }

  set setPhoneError(val) {
    _phoneError = val;
    notifyListeners();
  }

  set setPasswordError(val) {
    _passwordError = val;
    notifyListeners();
  }

  set setConfirmPasswordError(val) {
    _confirmPasswordError = val;
    notifyListeners();
  }

  set setNameError(val) {
    _nameError = val;
    notifyListeners();
  }

  set setImageFile(XFile? file) {
    _imageFile = file;
    notifyListeners();
  }

  set setImageError(err) {
    _imagePickerError = err;
    notifyListeners();
  }

  set setReturnData(val) {
    _returnData = val;
    notifyListeners();
  }

  // getter

  TextEditingController get phoneController => _phoneController;
  TextEditingController get emailController => _emailController;
  TextEditingController get emailConfirmController => _emailConfirmController;
  TextEditingController get nameController => _nameController;
  TextEditingController get passwordController => _passwordController;
  TextEditingController get confirmPasswordController =>
      _confirmPasswordController;
  TextEditingController get currentPasswordController =>
      _currentPasswordController;
  TextEditingController get passwordConfirmController =>
      _passwordConfirmController;
  TextEditingController get firstNameController => _firstNameController;
  TextEditingController get lastNameController => _lastNameController;
  TextEditingController get countryController => _countryController;
  TextEditingController get cardNumberController => _cardNumberController;
  TextEditingController get cardCvvController => _cardCvvController;
  TextEditingController get accountHolderController => _accountHolderController;
  TextEditingController get expiryController => _expiryController;

  TextEditingController get contactMessageController =>
      _contactMessageController;
  // TextEditingController get otpController => _otpController;

  GlobalKey<FormState> get formKey => _formKey;

  bool get emailError => _emailError;
  bool get passwordError => _passwordError;
  bool get confirmPasswordError => _confirmPasswordError;
  bool get emailConfirmError => _emailConfirmError;
  bool get nameError => _nameError;
  bool get phoneError => _phoneError;
  bool get checkBox => _checkBox;

  XFile? get imageFile => _imageFile;
  String get imageFilePath => _imageFile?.path ?? '';
  dynamic get imagePickerError => _imagePickerError;
  bool get returnData => _returnData;

  // method
  refresh() => notifyListeners();

  refreshEmail() {
    _emailConfirmController.clear();
    _emailController.clear();
    notifyListeners();
  }

  refreshPassword() {
    _passwordConfirmController.clear();
    _currentPasswordController.clear();
    _confirmPasswordController.clear();
    _passwordController.clear();
    notifyListeners();
  }

  refreshRegister() {
    _passwordController.clear();
    _emailController.clear();
    _nameController.clear();
    _phoneController.clear();
    _confirmPasswordController.clear();
    notifyListeners();
  }

  updateCheckBox() {
    _checkBox = !checkBox;
    notifyListeners();
  }

  showImagePicker({required BuildContext context}) async {
    ImagePickerHelper.showPicker(
      context: context,
      imagePicker: _imagePicker,
      successCallBack: (file) {
        setImageFile = file;
        logMe('++++++>${file?.name}:${file?.path}');
        if (file!.path != "") {
          setReturnData = true;
        }
      },
      failedCallBack: (error) {
        logMe(error);
        showToast(message: error);
        setImageError = error;
        setImageFile = null;
        setReturnData = false;
      },
    );
    log("image file path" + imageFilePath.toString());

    log("return data+++++++>" + returnData.toString());
  }
}
