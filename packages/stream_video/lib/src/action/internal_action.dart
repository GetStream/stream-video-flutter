import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'action.dart';

@internal
abstract class StreamInternalAction extends StreamAction with EquatableMixin {
  const StreamInternalAction();

  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => true;
}
