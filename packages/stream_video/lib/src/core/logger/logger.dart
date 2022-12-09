import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

/// The logger for this package.
final logger = Logger.detached('StreamVideo');

/// Sets the log level for this package.
void setLogLevel(Level level) => logger.level = level;

void setLogHandler(ValueSetter<LogRecord> handler) =>
    logger.onRecord.listen(handler);
