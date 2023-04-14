extension ListUtils<T> on List<T> {
  List<T> movedToFront(T item) {
    final itemIndex = indexOf(item);
    if (itemIndex != -1 && itemIndex != 0) {
      final result = [...this];
      return result
        ..insert(
          0,
          result.removeAt(itemIndex),
        );
    }
    return this;
  }
}
