import 'package:meta/meta.dart';

@internal
abstract class SdpEditAction {
  const SdpEditAction();

  void execute(List<String> sdpLines);
}
