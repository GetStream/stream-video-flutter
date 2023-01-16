class CallSettings {
  const CallSettings({
    this.cameraEnabled = false,
    this.microphoneEnabled = false,
    this.screenShareEnabled = false,
  });

  final bool cameraEnabled;
  final bool microphoneEnabled;
  final bool screenShareEnabled;

  @override
  String toString() {
    return 'CallOptions{cameraEnabled: $cameraEnabled, microphoneEnabled: '
        '$microphoneEnabled, screenShareEnabled: $screenShareEnabled}';
  }
}
