enum Environment {
  pronto(
    'Pronto',
    'pronto',
    'pronto.getstream.io',
    aliases: ['stream-calls-dogfood'],
    baseUrls: [
      'https://pronto.getstream.io',
      'https://stream-calls-dogfood.vercel.app'
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
  custom(
    'Custom',
    'custom',
    '',
  );

  final String displayName;
  final String envName;
  final String hostName;
  final List<String> aliases;
  final List<String> baseUrls;

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
    final String envAlias = hostParts.length < 2 ? '' : hostParts[0];

    return Environment.fromSubdomain(envAlias);
  }

  factory Environment.fromBaseUrl(String baseUrl) {
    return Environment.values.firstWhere(
      (env) => env.baseUrls.contains(baseUrl),
    );
  }

  String? getJoinUrl({required String callId, String? callType}) {
    switch (this) {
      case Environment.pronto:
      case Environment.prontoStaging:
      case Environment.staging:
        return '${baseUrls.first}/join/$callId?type=${callType ?? 'default'}';
      case Environment.demo:
        return '${baseUrls.first}/video/demos/join/$callId?type=${callType ?? 'default'}';
      case Environment.livestream:
        return '${baseUrls.first}/?id=$callId&type=${callType ?? 'livestream'}';
      case Environment.custom:
        return null;
    }
  }
}
