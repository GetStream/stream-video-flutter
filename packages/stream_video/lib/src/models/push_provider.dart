import 'package:collection/collection.dart';

/// Provider used to send push notifications.
enum PushProvider {
  /// Send notifications using Google's Firebase Cloud Messaging
  firebase('firebase'),

  /// Send notifications using Huawei's Push Kit
  huawei('huawei'),

  /// Send notifications using Xiaomi's Mi Push Service
  xiaomi('xiaomi'),

  /// Send notifications using Apple's Push Notification service
  apn('apn');

  const PushProvider(this.alias);

  final String alias;

  @override
  String toString() => alias;

  static PushProvider? fromAlias(String? alias) {
    return PushProvider.values.firstWhereOrNull(
      (it) => it.alias == alias,
    );
  }
}
