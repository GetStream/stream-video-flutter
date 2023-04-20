import '../action/action.dart';
import '../utils/list.dart';
import 'middleware.dart';

class RootMiddleware implements Middleware {
  RootMiddleware({
    required this.getState,
    required this.reduce,
    required this.middlewares,
  });

  @override
  final GetState getState;

  @override
  final Reduce reduce;

  final List<Middleware> middlewares;

  var _initialized = false;

  @override
  void dispatch(StreamAction action) {
    if (!_initialized) {
      _initialized = true;
      _initialize();
    }
    if (middlewares.isEmpty) {
      reduce(action);
      return;
    }
    middlewares.first.dispatch(action);
  }

  void _initialize() {
    for (var index = 0; index < middlewares.length; index++) {
      final current = middlewares[index];
      final next = middlewares.nextOr(index, () => _ReduceMiddleware(reduce));
      current.getState = getState;
      current.reduce = reduce;
      current.next = next;
    }
  }

  @override
  Middleware get next => this;

  @override
  set next(_) {}

  @override
  set getState(_) {}

  @override
  set reduce(_) {}
}

class _ReduceMiddleware implements Middleware {
  _ReduceMiddleware(this.reduce);

  @override
  Reduce reduce;

  @override
  void dispatch(StreamAction action) {
    reduce(action);
  }

  @override
  GetState getState = () {
    throw UnimplementedError('_ReduceMiddleware.getState');
  };

  @override
  Middleware get next => this;

  @override
  set next(_) {}
}
