class TestCase<T, K> {
  final String name;
  final T input;
  final K expected;

  TestCase({required this.name, required this.input, required this.expected});
}
