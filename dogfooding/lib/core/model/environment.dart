enum Environment {
  pronto(
    'Pronto',
    'pronto',
    'pronto.getstream.io',
    aliases: ['stream-calls-dogfood'],
    baseUrls: [
      'https://pronto.getstream.io',
      'https://stream-calls-dogfood.vercel.app',
    ],
  ),
  prontoStaging(
    'Pronto Staging',
    'pronto',
    'pronto-staging.getstream.io',
    baseUrls: ['https://pronto-staging.getstream.io'],
  ),
  demo(
    'Demo',
    'demo',
    'pronto.getstream.io',
    aliases: [''],
    baseUrls: ['https://getstream.io'],
  ),
  staging(
    'Staging',
    'staging',
    'pronto.getstream.io',
    baseUrls: ['https://staging.getstream.io'],
  ),
  livestream(
    'Livestream',
    'demo',
    'pronto.getstream.io',
    baseUrls: ['https://livestream-react-demo.vercel.app'],
  ),
  custom('Custom', 'custom', '');

  const Environment(
    this.displayName,
    this.envName,
    this.hostName, {
    this.aliases = const [],
    this.baseUrls = const [],
  });

  factory Environment.fromSubdomain(String subdomain) {
    return Environment.values.firstWhere(
      (env) => env.name == subdomain || env.aliases.contains(subdomain),
      orElse: () => Environment.demo,
    );
  }

  factory Environment.fromHost(String host) {
    final hostParts = host.split('.');
    final envAlias = hostParts.length < 2 ? '' : hostParts[0];

    return Environment.fromSubdomain(envAlias);
  }

  factory Environment.fromBaseUrl(String baseUrl) {
    return Environment.values.firstWhere(
      (env) => env.baseUrls.contains(baseUrl),
    );
  }

  final String displayName;
  final String envName;
  final String hostName;
  final List<String> aliases;
  final List<String> baseUrls;

  /// Whether this is a Pronto environment.
  bool get isPronto => envName == 'pronto';

  /// The URL that joins [callId] on this environment, or null when it has no
  /// public join page.
  ///
  /// [encryptionKey] is the shared passphrase, appended as `encryption_key`.
  String? getJoinUrl({
    required String callId,
    String? callType,
    String? encryptionKey,
  }) {
    final url = switch (this) {
      Environment.pronto || Environment.prontoStaging || Environment.staging =>
        '${baseUrls.first}/join/$callId?type=${callType ?? 'default'}',
      Environment.demo =>
        '${baseUrls.first}/video/demos/join/$callId?type=${callType ?? 'default'}',
      Environment.livestream =>
        '${baseUrls.first}/?id=$callId&type=${callType ?? 'livestream'}',
      Environment.custom => null,
    };

    if (url == null || encryptionKey == null || encryptionKey.isEmpty) {
      return url;
    }

    return '$url&encryption_key=${Uri.encodeQueryComponent(encryptionKey)}';
  }
}
