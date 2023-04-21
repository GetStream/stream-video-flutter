import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'action.dart';

@internal
abstract class StreamExternalAction extends StreamAction with EquatableMixin {
  const StreamExternalAction();

  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => true;
}
