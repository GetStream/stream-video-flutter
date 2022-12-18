import 'package:rxdart/rxdart.dart';

class RxController<T> {
  RxController({
    T? seedValue,
    void Function()? onListen,
    void Function()? onCancel,
    bool sync = false,
  }) : _controller = seedValue == null
            ? BehaviorSubject<T>(
                sync: sync,
                onListen: onListen,
                onCancel: onCancel,
              )
            : BehaviorSubject<T>.seeded(
                seedValue,
                sync: sync,
                onListen: onListen,
                onCancel: onCancel,
              );

  final BehaviorSubject<T> _controller;

  Stream<T> get stream => _controller.stream;

  T? get valueOrNull => _controller.valueOrNull;

  T get value => _controller.value;

  set value(T value) => _controller.add(value);

  Future<dynamic> dispose() => _controller.close();
}
