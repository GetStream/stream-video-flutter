import 'package:rxdart/rxdart.dart';
import 'package:stream_video_dart/protobuf/video_models/models.pb.dart';

class ClientState {
   final _currentUserController = BehaviorSubject<User?>();

    set currentUser(User? user) {
    // _computeUnreadCounts(user);
    _currentUserController.add(user);
  }

    /// The current user
  User? get currentUser => _currentUserController.valueOrNull;

  /// Call this method to dispose this object
  Future<void> dispose() async {
    await Future.wait([_currentUserController.close()]);
  }
}
