import 'package:stream_core/stream_core.dart'
    as core
    show StreamLogConfig, StreamLogHandler, StreamLogPriority, StreamLogger;

import 'logger_api.dart';
import 'stream_log.dart';

/// Forwards `stream_core`'s own log records — the WebSocket client, engine,
/// health monitor and authentication handler this SDK runs on — into the video
/// logger, admitting records at [logPriority] and above. Core's logger is
/// silent until something installs a handler.
void installCoreLogBridge(Priority logPriority) {
  core.StreamLogger.configure(
    core.StreamLogConfig(
      priority: logPriority.toCoreLogPriority(),
      handler: core.StreamLogHandler.from(
        (record) => StreamLog().log(
          record.priority.toVideoPriority(),
          record.tag,
          () => [
            record.message,
            if (record.error != null) 'error: ${record.error}',
            if (record.stackTrace != null) '${record.stackTrace}',
          ].join('; '),
        ),
      ),
    ),
  );
}

extension on Priority {
  core.StreamLogPriority toCoreLogPriority() {
    return switch (this) {
      Priority.verbose => core.StreamLogPriority.verbose,
      Priority.debug => core.StreamLogPriority.debug,
      Priority.info => core.StreamLogPriority.info,
      Priority.warning => core.StreamLogPriority.warning,
      Priority.error => core.StreamLogPriority.error,
      Priority.none => core.StreamLogPriority.none,
    };
  }
}

extension on core.StreamLogPriority {
  Priority toVideoPriority() {
    return switch (this) {
      core.StreamLogPriority.verbose => Priority.verbose,
      core.StreamLogPriority.debug => Priority.debug,
      core.StreamLogPriority.info => Priority.info,
      core.StreamLogPriority.warning => Priority.warning,
      core.StreamLogPriority.error => Priority.error,
      core.StreamLogPriority.none => Priority.none,
    };
  }
}
