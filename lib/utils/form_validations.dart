class Validations {
  //login
  String? emailMobileValidation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field cannot be empty';
    }
    return null;
  }

  String? passwordValidation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field cannot be empty';
    }
    return null;
  }

  //signup
  String? signUpNameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field cannot be empty';
    }
    return null;
  }

  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field cannot be empty';
    }
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value);
    if (!emailValid) {
      return 'Invalid Email';
    }
    return null;
  }

  String? mobileNumberValid(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field cannot be empty';
    }
    if (value.length < 11 || value.length > 11) {
      return 'Invalid Mobile Number';
    }
    return null;
  }

  String? signUpPasswordValidation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field cannot be empty';
    }
    if (value.length < 5) {
      return 'Password length must be greater than 5';
    }
    return null;
  }

  String? signUpConfirmPasswordValidation(
      String? value, String signupPasswordValue) {
    if (value == null || value.isEmpty) {
      return 'Field cannot be empty';
    }
    if (value != signupPasswordValue) {
      return 'Password does not match';
    }
    return null;
  }
}
