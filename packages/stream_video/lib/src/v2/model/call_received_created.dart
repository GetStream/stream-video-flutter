import 'call_created.dart';

class CallReceivedOrCreated {
  const CallReceivedOrCreated({
    required this.wasCreated,
    required this.data,
  });
  final bool wasCreated;
  final CallCreated data;

  @override
  String toString() {
    return 'CallReceivedOrCreated{wasCreated: $wasCreated, data: $data}';
  }
}
