class EndpointConfig {
  const EndpointConfig({
    required this.apiKey,
    required this.rpcUrl,
    required this.wsUrl,
  });

  final String apiKey;
  final String rpcUrl;
  final String wsUrl;

  static EndpointConfig staging = const EndpointConfig(
    apiKey: 'us83cfwuhy8n',
    rpcUrl: 'https://rpc-video-coordinator.oregon-v1.stream-io-video.com/rpc',
    wsUrl:
        'wss://wss-video-coordinator.oregon-v1.stream-io-video.com/rpc/stream.video.coordinator.client_v1_rpc.Websocket/Connect',
  );

  static EndpointConfig stagingOregon = const EndpointConfig(
    apiKey: '554fuj7wzx4r',
    rpcUrl: 'https://video-edge-oregon-ce3.stream-io-api.com/video',
    wsUrl: 'wss://video-edge-oregon-ce3.stream-io-api.com/video/connect',
  );

  static EndpointConfig stagingFrankfurt = const EndpointConfig(
    apiKey: 'w6yaq5388uym',
    rpcUrl: 'https://video-edge-frankfurt-ce1.stream-io-api.com/video',
    wsUrl: 'wss://video-edge-frankfurt-ce1.stream-io-api.com/video/connect',
  );
}
