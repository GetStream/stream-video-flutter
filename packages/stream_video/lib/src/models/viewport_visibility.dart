import 'dart:ui';

import 'package:equatable/equatable.dart';

abstract class ViewportVisibility extends Equatable {
  factory ViewportVisibility({Size? size}) {
    if (size == null) return const ViewportVisibility.unknown();
    if (size == Size.zero) return const ViewportVisibility.hidden();
    return ViewportVisibility.visible(size: size);
  }

  const factory ViewportVisibility.unknown() = Unknown._;

  const factory ViewportVisibility.visible({required Size size}) = Visible._;

  const factory ViewportVisibility.hidden() = Hidden._;

  const ViewportVisibility._({required this.size});

  /// Size of the element in the viewport.
  final Size? size;

  bool get isUnknown => this is Unknown;

  bool get isVisible => this is Visible;

  bool get isHidden => this is Hidden;

  @override
  List<Object?> get props => [size];

  @override
  bool? get stringify => true;
}

/// Unknown, not yet determined.
class Unknown extends ViewportVisibility {
  const Unknown._() : super._(size: null);

  @override
  String toString() => 'Unknown';
}

/// Visible in the viewport.
class Visible extends ViewportVisibility {
  const Visible._({required Size size}) : super._(size: size);

  @override
  String toString() => 'Visible(size: $size)';
}

/// Hidden from the viewport.
class Hidden extends ViewportVisibility {
  const Hidden._() : super._(size: Size.zero);

  @override
  String toString() => 'Hidden';
}
