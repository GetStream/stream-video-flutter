extension Standard<T extends Object> on T {
  R let<R>(R Function(T it) convert) {
    return convert(this);
  }

  T also(void Function(T it) block) {
    block(this);
    return this;
  }
}
