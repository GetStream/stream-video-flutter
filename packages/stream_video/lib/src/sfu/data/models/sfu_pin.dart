import 'package:equatable/equatable.dart';

class SfuPin with EquatableMixin {
  SfuPin({
    required this.userId,
    required this.sessionId,
  });

  final String userId;
  final String sessionId;

  @override
  List<Object?> get props => [userId, sessionId];
}
