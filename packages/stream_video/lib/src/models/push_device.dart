import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'models.dart';

@immutable
class PushDevice with EquatableMixin {
  const PushDevice({
    required this.pushToken,
    required this.pushProvider,
    this.pushProviderName,
    this.voip,
    required this.createdAt,
    this.disabled,
    this.disabledReason,
  });

  /// The notification push token
  final String pushToken;

  /// The notification push provider
  final PushProvider pushProvider;

  /// The notification push provider name
  final String? pushProviderName;

  /// When true the token is for Apple VoIP push notifications
  final bool? voip;

  /// The date when the device was created
  final DateTime createdAt;

  /// Whether the device is disabled
  final bool? disabled;

  /// The reason why the device is disabled
  final String? disabledReason;

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [
        pushToken,
        pushProvider,
        pushProviderName,
        voip,
        createdAt,
        disabled,
        disabledReason,
      ];
}
