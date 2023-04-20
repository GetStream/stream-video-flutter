
import '../action/action.dart';
import '../call_state.dart';

abstract class Middleware {
  late GetState getState;
  late Reduce reduce;
  late Middleware next;

  void dispatch(StreamAction action);
}

typedef Reduce = void Function(StreamAction);
typedef GetState = CallState Function();
