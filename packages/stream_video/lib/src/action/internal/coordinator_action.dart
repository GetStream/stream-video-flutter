import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../coordinator/models/coordinator_events.dart';
import '../../models/call_metadata.dart';
import '../internal_action.dart';

@internal
abstract class CoordinatorAction extends StreamInternalAction
    with EquatableMixin {
  const CoordinatorAction();

  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => true;
}

class CoordinatorEventAction extends CoordinatorAction {
  const CoordinatorEventAction(this.event);

  final CoordinatorCallEvent event;
}

class UpdateUsers extends CoordinatorAction {
  const UpdateUsers({
    required this.users,
  });

  final Map<String, CallUser> users;
}
