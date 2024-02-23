class Validator {
  static bool isValidPhoneNumber(String value) {
    if (value.length <= 10) {
      return RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)').hasMatch(value);
    } else {
      return false;
    }
  }
}
