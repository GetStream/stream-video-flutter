import '../utils/none.dart';
import '../utils/result.dart';

abstract class AudioProcessor {
  Future<Result<bool>> isEnabled();
  Future<Result<None>> setEnabled(bool enabled);
  Future<Result<bool>> deviceSupportsAdvancedAudioProcessing();
}
