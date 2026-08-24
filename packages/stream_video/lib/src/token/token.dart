import '../models/models.dart';

/// A function which can be used to request a Stream Video API token from your
/// own backend server
typedef GuestTokenLoader = Future<String> Function(UserInfo user);

/// A function which can be used to request a Stream Video API token from your
/// own backend server.
/// Function requires a single [userId].
typedef TokenLoader = Future<String> Function(String userId);
