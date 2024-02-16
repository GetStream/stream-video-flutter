import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:stream_video/src/action/internal_action.dart';
import 'package:stream_video/src/coordinator/models/coordinator_events.dart';
import 'package:stream_video/src/models/call_metadata.dart';

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
