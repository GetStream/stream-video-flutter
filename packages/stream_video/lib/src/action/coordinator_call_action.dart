import '../coordinator/models/coordinator_events.dart';
import '../models/call_metadata.dart';
import 'action.dart';

abstract class CoordinatorCallAction extends StreamAction {
  const CoordinatorCallAction();
}

class CoordinatorCallEventAction extends CoordinatorCallAction {
  const CoordinatorCallEventAction(this.event);

  final CoordinatorCallEvent event;
}

class CoordinatorCallUsersAction extends CoordinatorCallAction {
  const CoordinatorCallUsersAction({
    required this.users,
  });

  final Map<String, CallUser> users;
}
