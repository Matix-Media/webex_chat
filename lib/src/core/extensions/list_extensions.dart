extension ListExtensions<T> on List<T> {
  List<List<T>> chunk(int chunkSize) {
    if (chunkSize <= 0) throw ArgumentError("Chunk size must be greater than zero.");
    return List.generate(
        (length + chunkSize - 1) ~/ chunkSize, (i) => sublist(i * chunkSize, (i + 1) * chunkSize.clamp(0, length)));
  }
}
