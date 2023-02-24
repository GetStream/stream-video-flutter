import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class CallDevice with EquatableMixin {
  const CallDevice({
    required this.userId,
    required this.pushToken,
    required this.pushProviderName,
    required this.createdAt,
    required this.updatedAt,
  });

  final String userId;
  final String pushToken;
  final String pushProviderName;
  final DateTime createdAt;
  final DateTime updatedAt;

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [
        userId,
        pushProviderName,
        pushToken,
        createdAt,
        updatedAt,
      ];
}
