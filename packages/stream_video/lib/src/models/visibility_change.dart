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
}
