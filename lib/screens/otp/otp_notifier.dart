import 'dart:async';
import 'package:flutter/material.dart';

class OtpNotifier extends ChangeNotifier {
  late BuildContext context;

  List<TextEditingController> otpFieldController = [];
  List<FocusNode> otpFieldFocusNode = [];

  bool isResendButtonEnabled = false;
  bool? invalidOTP;

  String otpCode = '', mobileNumber = '';
  late Timer timer;
  int startTime = 170;
  int otpLength = 6;
  int maxResendAttempts = 5;

  OtpNotifier(this.context, this.mobileNumber);

  void init() {
    for (int i = 0; i < otpLength; i++) {
      TextEditingController controller = TextEditingController();
      controller.addListener(() {
        _onTextChangeListener(false);
      });
      otpFieldController.add(controller);
      otpFieldFocusNode.add(FocusNode());
    }
    _startTimer();
  }

  void onTextChange(String text, int index) {
    int length = text.length;
    if (length > 2) {
      for (int i = 0; i < length; i++) {
        otpFieldController[i].text = text[i];
      }
    }
    if (length == 2) {
      otpFieldController[index].text = text[0];
      otpFieldController[index + 1].text = text[1];
    }
    if (text.length == 1) {
      _onTextChangeListener(false);
    } else {
      _onTextChangeListener(true);
    }
    otpCode = '';
    for (int i = 0; i < otpFieldController.length; i++) {
      otpCode += otpFieldController[i].text;
    }
    invalidOTP = null;
    if (otpCode.isNotEmpty && otpCode.length == otpLength) {
      _otpVerification();
    }
    notifyListeners();
  }

  void _onTextChangeListener(bool isBackSpaceTapped) {
    for (int i = 0; i < otpFieldController.length; i++) {
      TextEditingController currentController = otpFieldController[i];
      if (currentController.text.isEmpty) {
        if (isBackSpaceTapped) {
          otpFieldFocusNode[i > 0 ? i - 1 : i].requestFocus();
        }
        notifyListeners();
        return;
      }
    }
    otpFieldFocusNode.last.requestFocus();
    notifyListeners();
  }

  void _startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      isResendButtonEnabled = false;
      if (startTime < 1) {
        timer.cancel();
        isResendButtonEnabled = true;
      } else {
        startTime = startTime - 1;
        isResendButtonEnabled = false;
      }
      notifyListeners();
    });
  }

  String formattedTime(int timeInSecond) {
    int sec = timeInSecond % 60;
    int min = (timeInSecond / 60).floor();
    String minute = min.toString().length <= 1 ? "$min" : "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    return "$minute : $second";
  }

  Future<void> _otpVerification() async {
    if (otpCode == '934477') {
      invalidOTP = false;
    } else {
      invalidOTP = true;
    }
    notifyListeners();
  }

  String getMaskedMobileNumber(String mobileNumber) {
    String firstDigit = mobileNumber.substring(0, 1);
    String lastTwoDigits = mobileNumber.substring(mobileNumber.length - 2);
    String maskedNumber = "($firstDigit**) ***_**$lastTwoDigits.";
    return maskedNumber;
  }

  void onClickResend() {
    if (maxResendAttempts >= 1 && isResendButtonEnabled) {
      maxResendAttempts = maxResendAttempts--;
      startTime = 170;
      invalidOTP = null;
      _startTimer();
      notifyListeners();
    }
  }

  void onClickChangeNumber() {
    Navigator.pop(context);
  }

  void onWillPop() {
    Navigator.pop(context);
  }
}
