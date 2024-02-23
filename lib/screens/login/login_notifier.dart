import 'package:flutter/material.dart';
import 'package:mscpl_bamakantkar/screens/otp/otp.dart';
import 'package:mscpl_bamakantkar/utils/validation_utils.dart';

class LoginNotifier extends ChangeNotifier {
  late BuildContext context;

  late TextEditingController mobileNumberController;
  late FocusNode mobileNumberFocusNode;

  bool enableGetOtpButton = false, isDeclarationChecked = false;

  LoginNotifier(this.context);

  void init() {
    mobileNumberController = TextEditingController();
    mobileNumberFocusNode = FocusNode();
  }

  void onMobileNumberChange(String value) {
    mobileNumberController.text = value;
    shouldEnableGetOtpButton();
  }

  void onClickDeclaration() {
    isDeclarationChecked = !isDeclarationChecked;
    shouldEnableGetOtpButton();
  }

  void shouldEnableGetOtpButton() {
    if (isDeclarationChecked &&
        mobileNumberController.text.isNotEmpty &&
        Validator.isValidPhoneNumber(mobileNumberController.text)) {
      enableGetOtpButton = true;
    } else {
      enableGetOtpButton = false;
    }
    notifyListeners();
  }

  void onClickGetOtp() {
    if (enableGetOtpButton) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => OTP(mobileNumberController.text)));
    }
  }

  void onWillPop() {
    Navigator.pop(context);
  }
}
