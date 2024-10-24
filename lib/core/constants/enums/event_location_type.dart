enum EventLocationType {
  online(
    key: 'online',
    number: 1,
  ),
  inPerson(
    key: 'in_person',
    number: 0,
  );

  final String key;
  final int number;

  const EventLocationType({required this.key, required this.number});
}
