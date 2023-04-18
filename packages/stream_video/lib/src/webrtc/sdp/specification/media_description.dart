import 'package:equatable/equatable.dart';

import '../codec/sdp_codec.dart';
import '../sdp.dart';

// https://www.rfc-editor.org/rfc/rfc4566#section-5.14
// m=<media> <port>/<number of ports> <proto> <fmt>
class MediaDescription with EquatableMixin {
  MediaDescription({
    required this.media,
    required this.port,
    this.numberOfPorts,
    required this.proto,
    required this.fmt,
  });

  final String media;
  final String port;
  final String? numberOfPorts;
  final String proto;
  final List<String> fmt;

  MediaDescription copyWith({
    String? media,
    String? port,
    String? numberOfPorts,
    String? proto,
    List<String>? fmt,
  }) {
    return MediaDescription(
      media: media ?? this.media,
      port: port ?? this.port,
      numberOfPorts: numberOfPorts ?? this.numberOfPorts,
      proto: proto ?? this.proto,
      fmt: fmt ?? this.fmt,
    );
  }

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [media, port, numberOfPorts, proto, fmt];
}

extension MediaDescriptionUtils on MediaDescription {
  bool get isAudio =>
      media.toUpperCase() == MediaType.audio.alias.toUpperCase();

  bool get isVideo =>
      media.toUpperCase() == MediaType.video.alias.toUpperCase();

  bool isTypeOf(MediaType type) =>
      media.toUpperCase() == type.alias.toUpperCase();
}

extension MediaDescriptionSdpUtils on SdpLine {
  bool get isMediaDescription => startsWith('m=');

  bool get isVideoDescription => startsWith('m=video');

  bool get isAudioDescription => startsWith('m=audio');
}

class MediaDescriptionParser {
  final _regex = RegExp(
    r'^m=([a-z]+) (\d+)(?:/(\d+))? ([\w/]+) (\d+(?: \d+)*)$',
  );
  final _groupMedia = 1;
  final _groupPort = 2;
  final _groupNumberOfPorts = 3;
  final _groupProto = 4;
  final _groupFmt = 5;

  MediaDescription? parse(SdpLine sdpLine) {
    final match = _regex.firstMatch(sdpLine);
    if (match == null) {
      return null;
    }
    final media = match.group(_groupMedia);
    final port = match.group(_groupPort);
    final numberOfPorts = match.group(_groupNumberOfPorts);
    final proto = match.group(_groupProto);
    final fmt = match.group(_groupFmt)?.split(' ');
    if (media == null || port == null || proto == null || fmt == null) {
      return null;
    }
    return MediaDescription(
      media: media,
      port: port,
      numberOfPorts: numberOfPorts,
      proto: proto,
      fmt: fmt,
    );
  }
}

extension MediaDescriptionLineComposer on MediaDescription {
  SdpLine toSdpLine() {
    final buffer = StringBuffer()
      ..write('m=')
      ..write(media)
      ..write(' ')
      ..write(port);
    if (numberOfPorts != null) {
      buffer
        ..write('/')
        ..write(numberOfPorts);
    }
    buffer
      ..write(' ')
      ..write(proto)
      ..write(' ')
      ..writeAll(fmt, ' ');
    return buffer.toString();
  }
}
