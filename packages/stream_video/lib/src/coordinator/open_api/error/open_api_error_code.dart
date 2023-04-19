class OpenApiErrorCode {
  static const tokenExpired = 40;
  static const tokenNotValid = 41;
  static const tokenDateIncorrect = 42;
  static const tokenSignatureIncorrect = 43;
  static const apiKeyNotFound = 2;

  static final tokenRelated = [
    tokenExpired,
    tokenNotValid,
    tokenDateIncorrect,
    tokenSignatureIncorrect
  ];
}
