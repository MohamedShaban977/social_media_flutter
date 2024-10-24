extension IterableExtensions<T> on Iterable<T> {
  Iterable<E> mapIndexed<E>(E Function(T e, int index) f) {
    int i = 0;
    return map((e) => f(e, i++));
  }
}
