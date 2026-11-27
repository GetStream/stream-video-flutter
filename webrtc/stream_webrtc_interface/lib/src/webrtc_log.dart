/// How severe a log record of the WebRTC packages is.
enum WebRtcLogLevel { verbose, info, warning }

/// Receives a log record of the WebRTC packages.
typedef WebRtcLogHandler =
    void Function(WebRtcLogLevel level, String tag, String message);

/// Where the WebRTC packages send their log records. Records are dropped
/// while it is null.
WebRtcLogHandler? webRtcLogHandler;
