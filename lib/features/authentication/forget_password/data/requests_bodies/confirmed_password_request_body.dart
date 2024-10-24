class ConfirmedPasswordRequestBody {
  final String? password;
  final String? confirmedPassword;

  ConfirmedPasswordRequestBody({
    this.password,
    this.confirmedPassword,
  });

  Map<String, dynamic> toJson() =>
      {
        "password": password,
        "confirmed_password": confirmedPassword,
      };
}
