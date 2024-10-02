class UtilitFunctions {
  bool hasAnyError(String? usernameError, String? emailOrPhoneError, String? passwordError) {
    return usernameError != null ||
        emailOrPhoneError != null ||
        passwordError != null;
  }
}
