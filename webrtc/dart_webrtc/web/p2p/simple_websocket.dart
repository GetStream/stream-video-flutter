import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:web/web.dart' as web;

typedef OnMessageCallback = void Function(dynamic msg);
typedef OnCloseCallback = void Function(int code, String reason);
typedef OnOpenCallback = void Function();

class SimpleWebSocket {
  SimpleWebSocket(this._url) {
    _url = _url.replaceAll('https:', 'wss:');
  }

  String _url;
  var _socket;
  OnOpenCallback? onOpen;
  OnMessageCallback? onMessage;
  OnCloseCallback? onClose;

  Future<void> connect() async {
    try {
      _socket = web.WebSocket(_url);
      _socket.onOpen.listen((e) {
        onOpen?.call();
      });

      _socket.onMessage.listen((e) {
        onMessage?.call(e.data);
      });

      _socket.onClose.listen((e) {
        onClose?.call(e.code, e.reason);
      });
    } catch (e) {
      onClose?.call(500, e.toString());
    }
  }

  void send(data) {
    if (_socket != null && _socket.readyState == web.WebSocket.OPEN) {
      _socket.send(data);
      print('send: $data');
    } else {
      print('WebSocket not connected, message $data not sent');
    }
  }

  void close() {
    if (_socket != null) _socket.close();
  }
}

Future<Map> getTurnCredential(String host, int port) async {
  var url = 'https://$host:$port/api/turn?service=turn&username=flutter-webrtc';
  final res = await http.get(Uri.parse(url));
  if (res.statusCode == 200) {
    var data = json.decode(res.body);
    print('getTurnCredential:response => $data.');
    return data;
  }
  return {};
}
