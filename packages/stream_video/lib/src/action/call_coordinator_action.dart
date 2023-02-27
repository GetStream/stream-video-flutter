import '../coordinator/models/coordinator_events.dart';
import '../models/call_metadata.dart';
import 'action.dart';

abstract class CallCoordinatorAction extends StreamAction {
  const CallCoordinatorAction();
}

class CallCoordinatorEventAction extends CallCoordinatorAction {
  const CallCoordinatorEventAction(this.event);

  final CallCoordinatorEvent event;
}

class CallCoordinatorUsersAction extends CallCoordinatorAction {
  const CallCoordinatorUsersAction({
    required this.users,
  });

  final Map<String, CallUser> users;
}
