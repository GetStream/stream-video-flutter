import 'package:equatable/equatable.dart';

class SfuPin extends Equatable {
  const SfuPin({
    required this.userId,
    required this.sessionId,
  });

  final String userId;
  final String sessionId;

  @override
  List<Object?> get props => [userId, sessionId];
}
