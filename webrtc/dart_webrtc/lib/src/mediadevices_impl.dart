import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:web/web.dart' as web;
import 'package:webrtc_interface/webrtc_interface.dart';

import 'media_stream_impl.dart';
import 'utils.dart';

class MediaDevicesWeb extends MediaDevices {
  @override
  Future<MediaStream> getUserMedia(
      Map<String, dynamic> mediaConstraints) async {
    try {
      try {
        if (!isMobile) {
          if (mediaConstraints['video'] is Map &&
              mediaConstraints['video']['facingMode'] != null) {
            mediaConstraints['video'].remove('facingMode');
          }
        }
        mediaConstraints.putIfAbsent('video', () => false);
        mediaConstraints.putIfAbsent('audio', () => false);
      } catch (e) {
        print(
            '[getUserMedia] failed to remove facingMode from mediaConstraints');
      }
      try {
        if (mediaConstraints['audio'] is Map<String, dynamic> &&
            Map.from(mediaConstraints['audio']).containsKey('optional') &&
            mediaConstraints['audio']['optional']
                is List<Map<String, dynamic>>) {
          List<Map<String, dynamic>> optionalValues =
              mediaConstraints['audio']['optional'];
          final audioMap = <String, dynamic>{};

          optionalValues.forEach((option) {
            option.forEach((key, value) {
              audioMap[key] = value;
            });
          });

          mediaConstraints['audio'].remove('optional');
          mediaConstraints['audio'].addAll(audioMap);
        }
      } catch (e, s) {
        print(
            '[getUserMedia] failed to translate optional audio constraints, $e, $s');
      }

      final mediaDevices = web.window.navigator.mediaDevices;

      if (mediaDevices.getProperty('getUserMedia'.toJS).isDefinedAndNotNull) {
        var args = mediaConstraints.jsify();
        final jsStream = await mediaDevices
            .getUserMedia(args as web.MediaStreamConstraints)
            .toDart;

        return MediaStreamWeb(jsStream, 'local');
      } else {
        final jsStream = await web.window.navigator.mediaDevices
            .getUserMedia(web.MediaStreamConstraints(
              audio: mediaConstraints['audio'],
              video: mediaConstraints['video'],
            ))
            .toDart;
        return MediaStreamWeb(jsStream, 'local');
      }
    } catch (e) {
      throw 'Unable to getUserMedia: ${e.toString()}';
    }
  }

  @override
  Future<MediaStream> getDisplayMedia(
      Map<String, dynamic> mediaConstraints) async {
    try {
      final mediaDevices = web.window.navigator.mediaDevices;

      if (mediaDevices
          .getProperty('getDisplayMedia'.toJS)
          .isDefinedAndNotNull) {
        final arg = mediaConstraints.jsify();
        final jsStream = await mediaDevices
            .getDisplayMedia(arg as web.DisplayMediaStreamOptions)
            .toDart;
        return MediaStreamWeb(jsStream, 'local');
      } else {
        final jsStream = await web.window.navigator.mediaDevices
            .getUserMedia(web.MediaStreamConstraints(
                video: {'mediaSource': 'screen'}.jsify()!,
                audio: mediaConstraints['audio'] ?? false))
            .toDart;
        return MediaStreamWeb(jsStream, 'local');
      }
    } catch (e) {
      throw 'Unable to getDisplayMedia: ${e.toString()}';
    }
  }

  @override
  Future<List<MediaDeviceInfo>> enumerateDevices() async {
    final devices = await getSources();

    return devices.map((e) {
      var input = e;
      return MediaDeviceInfo(
        deviceId: input.deviceId,
        groupId: input.groupId,
        kind: input.kind,
        label: input.label,
      );
    }).toList();
  }

  @override
  Future<List<web.MediaDeviceInfo>> getSources() async {
    final devices =
        await web.window.navigator.mediaDevices.enumerateDevices().toDart;
    return devices.toDart;
  }

  @override
  MediaTrackSupportedConstraints getSupportedConstraints() {
    final mediaDevices = web.window.navigator.mediaDevices;

    var _mapConstraints = mediaDevices.getSupportedConstraints();

    return MediaTrackSupportedConstraints(
        aspectRatio: _mapConstraints.aspectRatio,
        autoGainControl: _mapConstraints.autoGainControl,
        brightness: _mapConstraints.brightness,
        channelCount: _mapConstraints.channelCount,
        colorTemperature: _mapConstraints.colorTemperature,
        contrast: _mapConstraints.contrast,
        deviceId: _mapConstraints.deviceId,
        echoCancellation: _mapConstraints.echoCancellation,
        exposureCompensation: _mapConstraints.exposureCompensation,
        exposureMode: _mapConstraints.exposureMode,
        exposureTime: _mapConstraints.exposureTime,
        facingMode: _mapConstraints.facingMode,
        focusDistance: _mapConstraints.focusDistance,
        focusMode: _mapConstraints.focusMode,
        frameRate: _mapConstraints.frameRate,
        groupId: _mapConstraints.groupId,
        height: _mapConstraints.height,
        iso: _mapConstraints.iso,
        latency: _mapConstraints.latency,
        noiseSuppression: _mapConstraints.noiseSuppression,
        pan: _mapConstraints.pan,
        pointsOfInterest: _mapConstraints.pointsOfInterest,
        resizeMode: _mapConstraints.resizeMode,
        saturation: _mapConstraints.saturation,
        sampleRate: _mapConstraints.sampleRate,
        sampleSize: _mapConstraints.sampleSize,
        sharpness: _mapConstraints.sharpness,
        tilt: _mapConstraints.tilt,
        torch: _mapConstraints.torch,
        whiteBalanceMode: _mapConstraints.whiteBalanceMode,
        width: _mapConstraints.width,
        zoom: _mapConstraints.zoom);
  }

  @override
  Future<MediaDeviceInfo> selectAudioOutput(
      [AudioOutputOptions? options]) async {
    try {
      final mediaDevices = web.window.navigator.mediaDevices;

      if (mediaDevices
          .getProperty('selectAudioOutput'.toJS)
          .isDefinedAndNotNull) {
        if (options != null) {
          final arg = options.jsify();
          final deviceInfo =
              await (mediaDevices.callMethod('selectAudioOutput'.toJS, arg)
                      as JSPromise<web.MediaDeviceInfo>)
                  .toDart;
          return MediaDeviceInfo(
            kind: deviceInfo.kind,
            label: deviceInfo.label,
            deviceId: deviceInfo.deviceId,
            groupId: deviceInfo.groupId,
          );
        } else {
          final deviceInfo =
              await (mediaDevices.callMethod('selectAudioOutput'.toJS)
                      as JSPromise<web.MediaDeviceInfo>)
                  .toDart;
          return MediaDeviceInfo(
            kind: deviceInfo.kind,
            label: deviceInfo.label,
            deviceId: deviceInfo.deviceId,
            groupId: deviceInfo.groupId,
          );
        }
      } else {
        throw UnimplementedError('selectAudioOutput is missing');
      }
    } catch (e) {
      throw 'Unable to selectAudioOutput: ${e.toString()}, Please try to use MediaElement.setSinkId instead.';
    }
  }

  @override
  set ondevicechange(Function(dynamic event)? listener) {
    try {
      final mediaDevices = web.window.navigator.mediaDevices;

      mediaDevices.ondevicechange = ((JSObject evt) {
        listener?.call(evt);
      }).toJS;
    } catch (e) {
      throw 'Unable to set ondevicechange: ${e.toString()}';
    }
  }

  @override
  Function(dynamic event)? get ondevicechange {
    try {
      final mediaDevices = web.window.navigator.mediaDevices;

      final fn = mediaDevices.ondevicechange;
      if (fn.isUndefinedOrNull) {
        return null;
      }
      return (dynamic event) => fn!.callAsFunction(event);
    } catch (e) {
      throw 'Unable to get ondevicechange: ${e.toString()}';
    }
  }
}
