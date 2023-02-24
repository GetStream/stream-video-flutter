extension IterableUtils<E, T extends Iterable<E>> on T {
  R? ifNotEmpty<R>(R Function(T it) convert) {
    if (isNotEmpty) {
      return convert(this);
    }
    return null;
  }
}

extension NullableIterableUtils<E, T extends Iterable<E>> on T? {
  R? ifNotEmptyOrNull<R>(R Function(T it) convert) {
    final self = this;
    if (self != null && self.isNotEmpty) {
      return convert(self);
    }
    return null;
  }
}
