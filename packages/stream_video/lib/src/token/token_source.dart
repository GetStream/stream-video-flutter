// import 'package:stream_core/stream_core.dart';

// import 'token_manager_extension.dart';

// /// Establishes the session's identity with the server, returning the token that
// /// authenticates it.
// typedef SessionEstablisher = Future<Result<UserToken>> Function();

// /// The single point every token acquisition in the SDK goes through.
// ///
// /// Wraps the core [TokenManager] with the extra step required only for guest sessions,
// /// since a guest's identity is assigned by the server and exists only once an authenticated
// /// request has created it. Callers ask for a token the same way regardless of user type —
// /// the first one to ask establishes the guest session and the rest wait for it, rather than
// /// failing while the identity is in-flight or minting a second guest of their own.
// class TokenSource {
//   /// Creates a [TokenSource] serving the given manager's tokens.
//   ///
//   /// [establishSession] is what gives that manager its identity, for a session
//   /// that starts without one. Leave it out for a user whose identity is known
//   /// up front: tokens are then served straight from the manager.
//   TokenSource(
//     this._tokenManager, {
//     SessionEstablisher? establishSession,
//   }) : _establishSession = establishSession;

//   final TokenManager _tokenManager;
//   final SessionEstablisher? _establishSession;

//   /// Whether tokens come from a provider that always returns the same one.
//   ///
//   /// `false` while the identity is still to be established, so a refused token
//   /// leads to [refreshToken], which establishes it.
//   bool get usesStaticProvider => _tokenManager.usesStaticProvider;

//   /// Returns a token, establishing the session first when the server has yet to
//   /// assign it an identity.
//   Future<Result<UserToken>> getToken() {
//     if (_isEstablished) return _tokenManager.getTokenAsResult();
//     return _establish();
//   }

//   /// Discards the cached token and loads a fresh one, establishing the session
//   /// first when the server has yet to assign it an identity.
//   Future<Result<UserToken>> refreshToken() {
//     if (_isEstablished) return _tokenManager.refreshTokenAsResult();
//     return _establish();
//   }

//   // An identity of its own, or nothing to establish one with — in which case
//   // the manager itself reports the missing identity.
//   bool get _isEstablished =>
//       _tokenManager.userId != null || _establishSession == null;

//   /// The establishment in flight, shared between concurrent callers so a second
//   /// caller arriving mid-exchange cannot establish a session of its own.
//   ///
//   /// Failures are not sticky: the next caller retries.
//   Future<Result<UserToken>>? _operation;

//   Future<Result<UserToken>> _establish() {
//     return _operation ??= _runEstablish();
//   }

//   Future<Result<UserToken>> _runEstablish() async {
//     try {
//       return await _establishSession!();
//     } finally {
//       _operation = null;
//     }
//   }
// }
