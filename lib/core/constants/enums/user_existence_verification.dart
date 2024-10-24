enum UserExistenceVerification {
  email('email'),
  phone('phone');

  final String key;

  const UserExistenceVerification(
    this.key,
  );
}
