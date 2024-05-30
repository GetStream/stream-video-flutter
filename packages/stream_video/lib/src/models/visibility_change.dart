import 'viewport_visibility.dart';

class VisibilityChange {
  const VisibilityChange({
    required this.sessionId,
    required this.userId,
    required this.visibility,
  });

  final String sessionId;
  final String userId;
  final ViewportVisibility visibility;

  List<Object?> get props => [sessionId, userId, visibility];

  @override
  String toString() {
    return 'SubscriptionChange{sessionId: $sessionId, userId: $userId, '
        'visibility: $visibility';
  }
}
