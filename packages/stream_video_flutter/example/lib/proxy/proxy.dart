import 'dart:io';

void useProxy(String proxy) {
  HttpOverrides.global = ProxiedHttpOverrides(proxy);
}

class ProxiedHttpOverrides extends HttpOverrides {
  ProxiedHttpOverrides(this._proxy);
  final String _proxy;

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..findProxy = (uri) {
        return _proxy.isNotEmpty ? 'PROXY $_proxy;' : 'DIRECT';
      }
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => Platform.isAndroid;
  }
}
