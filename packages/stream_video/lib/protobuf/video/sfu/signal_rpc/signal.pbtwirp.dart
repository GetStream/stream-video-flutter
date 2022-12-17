// Code generated by protoc-gen-flutter-twirp. DO NOT EDIT. video/sfu/signal_rpc/signal

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:protobuf/protobuf.dart';
import 'package:tart/tart.dart' as twirp;
import 'signal.pb.dart';
import 'package:stream_video/protobuf/video/sfu/models/models.pb.dart';

abstract class SignalServer {
  // SetPublisher sends the WebRTC offer for the peer connection used to publish A/V
  Future<SetPublisherResponse> setPublisher(
      twirp.Context ctx, SetPublisherRequest req);
  // answer is sent by the client to the SFU after receiving a subscriber_offer.
  Future<SendAnswerResponse> sendAnswer(
      twirp.Context ctx, SendAnswerRequest req);
  // SendICECandidate sends an ICE candidate to the client
  Future<ICETrickleResponse> iceTrickle(twirp.Context ctx, ICETrickle req);
  // UpdateSubscribers is used to notify the SFU about the list of video subscriptions// TODO: sync subscriptions based on this + update tracks using the dimension info sent by the user
  Future<UpdateSubscriptionsResponse> updateSubscriptions(
      twirp.Context ctx, UpdateSubscriptionsRequest req);

  Future<UpdateMuteStatesResponse> updateMuteStates(
      twirp.Context ctx, UpdateMuteStatesRequest req);
}

class SignalServerJSONClient implements SignalServer {
  String baseUrl;
  String prefix;
  late twirp.ClientHooks hooks;
  late twirp.Interceptor interceptor;

  SignalServerJSONClient(this.baseUrl, this.prefix,
      {twirp.ClientHooks? hooks, twirp.Interceptor? interceptor}) {
    if (!baseUrl.endsWith('/')) baseUrl += '/';
    if (!prefix.endsWith('/')) prefix += '/';
    if (prefix.startsWith('/')) prefix = prefix.substring(1);

    this.hooks = hooks ?? twirp.ClientHooks();
    this.interceptor = interceptor ?? twirp.chainInterceptor([]);
  }

  @override
  Future<SetPublisherResponse> setPublisher(
      twirp.Context ctx, SetPublisherRequest req) async {
    ctx = twirp.withPackageName(ctx, 'signal');
    ctx = twirp.withServiceName(ctx, 'SignalServer');
    ctx = twirp.withMethodName(ctx, 'SetPublisher');
    return interceptor((ctx, req) {
      return callSetPublisher(ctx, req);
    })(ctx, req);
  }

  Future<SetPublisherResponse> callSetPublisher(
      twirp.Context ctx, SetPublisherRequest req) async {
    try {
      Uri url = Uri.parse(baseUrl +
          prefix +
          'stream.video.sfu.signal.SignalServer/SetPublisher');
      final data = await doJSONRequest(ctx, url, hooks, req);
      final SetPublisherResponse res = SetPublisherResponse.create();
      res.mergeFromProto3Json(json.decode(data));
      return Future.value(res);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<SendAnswerResponse> sendAnswer(
      twirp.Context ctx, SendAnswerRequest req) async {
    ctx = twirp.withPackageName(ctx, 'signal');
    ctx = twirp.withServiceName(ctx, 'SignalServer');
    ctx = twirp.withMethodName(ctx, 'SendAnswer');
    return interceptor((ctx, req) {
      return callSendAnswer(ctx, req);
    })(ctx, req);
  }

  Future<SendAnswerResponse> callSendAnswer(
      twirp.Context ctx, SendAnswerRequest req) async {
    try {
      Uri url = Uri.parse(
          baseUrl + prefix + 'stream.video.sfu.signal.SignalServer/SendAnswer');
      final data = await doJSONRequest(ctx, url, hooks, req);
      final SendAnswerResponse res = SendAnswerResponse.create();
      res.mergeFromProto3Json(json.decode(data));
      return Future.value(res);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ICETrickleResponse> iceTrickle(
      twirp.Context ctx, ICETrickle req) async {
    ctx = twirp.withPackageName(ctx, 'signal');
    ctx = twirp.withServiceName(ctx, 'SignalServer');
    ctx = twirp.withMethodName(ctx, 'IceTrickle');
    return interceptor((ctx, req) {
      return callIceTrickle(ctx, req);
    })(ctx, req);
  }

  Future<ICETrickleResponse> callIceTrickle(
      twirp.Context ctx, ICETrickle req) async {
    try {
      Uri url = Uri.parse(
          baseUrl + prefix + 'stream.video.sfu.signal.SignalServer/IceTrickle');
      final data = await doJSONRequest(ctx, url, hooks, req);
      final ICETrickleResponse res = ICETrickleResponse.create();
      res.mergeFromProto3Json(json.decode(data));
      return Future.value(res);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UpdateSubscriptionsResponse> updateSubscriptions(
      twirp.Context ctx, UpdateSubscriptionsRequest req) async {
    ctx = twirp.withPackageName(ctx, 'signal');
    ctx = twirp.withServiceName(ctx, 'SignalServer');
    ctx = twirp.withMethodName(ctx, 'UpdateSubscriptions');
    return interceptor((ctx, req) {
      return callUpdateSubscriptions(ctx, req);
    })(ctx, req);
  }

  Future<UpdateSubscriptionsResponse> callUpdateSubscriptions(
      twirp.Context ctx, UpdateSubscriptionsRequest req) async {
    try {
      Uri url = Uri.parse(baseUrl +
          prefix +
          'stream.video.sfu.signal.SignalServer/UpdateSubscriptions');
      final data = await doJSONRequest(ctx, url, hooks, req);
      final UpdateSubscriptionsResponse res =
          UpdateSubscriptionsResponse.create();
      res.mergeFromProto3Json(json.decode(data));
      return Future.value(res);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UpdateMuteStatesResponse> updateMuteStates(
      twirp.Context ctx, UpdateMuteStatesRequest req) async {
    ctx = twirp.withPackageName(ctx, 'signal');
    ctx = twirp.withServiceName(ctx, 'SignalServer');
    ctx = twirp.withMethodName(ctx, 'UpdateMuteStates');
    return interceptor((ctx, req) {
      return callUpdateMuteStates(ctx, req);
    })(ctx, req);
  }

  Future<UpdateMuteStatesResponse> callUpdateMuteStates(
      twirp.Context ctx, UpdateMuteStatesRequest req) async {
    try {
      Uri url = Uri.parse(baseUrl +
          prefix +
          'stream.video.sfu.signal.SignalServer/UpdateMuteStates');
      final data = await doJSONRequest(ctx, url, hooks, req);
      final UpdateMuteStatesResponse res = UpdateMuteStatesResponse.create();
      res.mergeFromProto3Json(json.decode(data));
      return Future.value(res);
    } catch (e) {
      rethrow;
    }
  }
}

class SignalServerProtobufClient implements SignalServer {
  String baseUrl;
  String prefix;
  late twirp.ClientHooks hooks;
  late twirp.Interceptor interceptor;

  SignalServerProtobufClient(this.baseUrl, this.prefix,
      {twirp.ClientHooks? hooks, twirp.Interceptor? interceptor}) {
    if (!baseUrl.endsWith('/')) baseUrl += '/';
    if (!prefix.endsWith('/')) prefix += '/';
    if (prefix.startsWith('/')) prefix = prefix.substring(1);

    this.hooks = hooks ?? twirp.ClientHooks();
    this.interceptor = interceptor ?? twirp.chainInterceptor([]);
  }

  @override
  Future<SetPublisherResponse> setPublisher(
      twirp.Context ctx, SetPublisherRequest req) async {
    ctx = twirp.withPackageName(ctx, 'signal');
    ctx = twirp.withServiceName(ctx, 'SignalServer');
    ctx = twirp.withMethodName(ctx, 'SetPublisher');
    return interceptor((ctx, req) {
      return callSetPublisher(ctx, req);
    })(ctx, req);
  }

  Future<SetPublisherResponse> callSetPublisher(
      twirp.Context ctx, SetPublisherRequest req) async {
    try {
      Uri url = Uri.parse(baseUrl +
          prefix +
          'stream.video.sfu.signal.SignalServer/SetPublisher');
      final data = await doProtobufRequest(ctx, url, hooks, req);
      final SetPublisherResponse res = SetPublisherResponse.create();
      res.mergeFromBuffer(data);
      return Future.value(res);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<SendAnswerResponse> sendAnswer(
      twirp.Context ctx, SendAnswerRequest req) async {
    ctx = twirp.withPackageName(ctx, 'signal');
    ctx = twirp.withServiceName(ctx, 'SignalServer');
    ctx = twirp.withMethodName(ctx, 'SendAnswer');
    return interceptor((ctx, req) {
      return callSendAnswer(ctx, req);
    })(ctx, req);
  }

  Future<SendAnswerResponse> callSendAnswer(
      twirp.Context ctx, SendAnswerRequest req) async {
    try {
      Uri url = Uri.parse(
          baseUrl + prefix + 'stream.video.sfu.signal.SignalServer/SendAnswer');
      final data = await doProtobufRequest(ctx, url, hooks, req);
      final SendAnswerResponse res = SendAnswerResponse.create();
      res.mergeFromBuffer(data);
      return Future.value(res);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ICETrickleResponse> iceTrickle(
      twirp.Context ctx, ICETrickle req) async {
    ctx = twirp.withPackageName(ctx, 'signal');
    ctx = twirp.withServiceName(ctx, 'SignalServer');
    ctx = twirp.withMethodName(ctx, 'IceTrickle');
    return interceptor((ctx, req) {
      return callIceTrickle(ctx, req);
    })(ctx, req);
  }

  Future<ICETrickleResponse> callIceTrickle(
      twirp.Context ctx, ICETrickle req) async {
    try {
      Uri url = Uri.parse(
          baseUrl + prefix + 'stream.video.sfu.signal.SignalServer/IceTrickle');
      final data = await doProtobufRequest(ctx, url, hooks, req);
      final ICETrickleResponse res = ICETrickleResponse.create();
      res.mergeFromBuffer(data);
      return Future.value(res);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UpdateSubscriptionsResponse> updateSubscriptions(
      twirp.Context ctx, UpdateSubscriptionsRequest req) async {
    ctx = twirp.withPackageName(ctx, 'signal');
    ctx = twirp.withServiceName(ctx, 'SignalServer');
    ctx = twirp.withMethodName(ctx, 'UpdateSubscriptions');
    return interceptor((ctx, req) {
      return callUpdateSubscriptions(ctx, req);
    })(ctx, req);
  }

  Future<UpdateSubscriptionsResponse> callUpdateSubscriptions(
      twirp.Context ctx, UpdateSubscriptionsRequest req) async {
    try {
      Uri url = Uri.parse(baseUrl +
          prefix +
          'stream.video.sfu.signal.SignalServer/UpdateSubscriptions');
      final data = await doProtobufRequest(ctx, url, hooks, req);
      final UpdateSubscriptionsResponse res =
          UpdateSubscriptionsResponse.create();
      res.mergeFromBuffer(data);
      return Future.value(res);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UpdateMuteStatesResponse> updateMuteStates(
      twirp.Context ctx, UpdateMuteStatesRequest req) async {
    ctx = twirp.withPackageName(ctx, 'signal');
    ctx = twirp.withServiceName(ctx, 'SignalServer');
    ctx = twirp.withMethodName(ctx, 'UpdateMuteStates');
    return interceptor((ctx, req) {
      return callUpdateMuteStates(ctx, req);
    })(ctx, req);
  }

  Future<UpdateMuteStatesResponse> callUpdateMuteStates(
      twirp.Context ctx, UpdateMuteStatesRequest req) async {
    try {
      Uri url = Uri.parse(baseUrl +
          prefix +
          'stream.video.sfu.signal.SignalServer/UpdateMuteStates');
      final data = await doProtobufRequest(ctx, url, hooks, req);
      final UpdateMuteStatesResponse res = UpdateMuteStatesResponse.create();
      res.mergeFromBuffer(data);
      return Future.value(res);
    } catch (e) {
      rethrow;
    }
  }
}

Future<List<int>> doProtobufRequest(twirp.Context ctx, Uri url,
    twirp.ClientHooks hooks, GeneratedMessage msgReq) async {
  // setup http client
  final httpClient = http.Client();

  try {
    // create http request
    final req = createRequest(url, ctx, 'application/protobuf');

    // add request data to body
    req.bodyBytes = msgReq.writeToBuffer();

    // call onRequestPrepared hook for user to modify request
    ctx = hooks.onRequestPrepared(ctx, req);

    // send data
    final res = await httpClient.send(req);

    // if success, parse and return response
    if (res.statusCode == 200) {
      List<int> data = <int>[];
      await res.stream.listen((value) {
        data.addAll(value);
      }).asFuture();
      hooks.onResponseReceived(ctx);
      return Future.value(data);
    }

    // we received a twirp related error
    throw twirp.TwirpError.fromJson(
        json.decode(await res.stream.transform(utf8.decoder).join()), ctx);
  } on twirp.TwirpError catch (twirpErr) {
    hooks.onError(ctx, twirpErr);
    rethrow;
  } catch (e) {
    // catch http connection error or from onRequestPrepared
    final twirpErr = twirp.TwirpError.fromConnectionError(e.toString(), ctx);
    hooks.onError(ctx, twirpErr);
    throw twirpErr;
  } finally {
    httpClient.close();
  }
}

Future<String> doJSONRequest(twirp.Context ctx, Uri url,
    twirp.ClientHooks hooks, GeneratedMessage msgReq) async {
  // setup http client
  final httpClient = http.Client();

  try {
    // create http request
    final req = createRequest(url, ctx, 'application/json');

    // add request data to body
    req.body = json.encode(msgReq.toProto3Json());

    // call onRequestPrepared hook for user to modify request
    ctx = hooks.onRequestPrepared(ctx, req);

    // send data
    final res = await httpClient.send(req);

    // if success, parse and return response
    if (res.statusCode == 200) {
      final data = await res.stream.transform(utf8.decoder).join().then((data) {
        hooks.onResponseReceived(ctx);
        return data;
      });
      return Future.value(data);
    }

    // we received a twirp related error
    throw twirp.TwirpError.fromJson(
        json.decode(await res.stream.transform(utf8.decoder).join()), ctx);
  } on twirp.TwirpError catch (twirpErr) {
    hooks.onError(ctx, twirpErr);
    rethrow;
  } catch (e) {
    // catch http connection error or from onRequestPrepared
    final twirpErr = twirp.TwirpError.fromConnectionError(e.toString(), ctx);
    hooks.onError(ctx, twirpErr);
    throw twirpErr;
  } finally {
    httpClient.close();
  }
}

http.Request createRequest(
    Uri url, twirp.Context ctx, String applicationHeader) {
  // setup request
  final req = http.Request("POST", url);

  // add headers from context
  final headersFromCtx = twirp.retrieveHttpRequestHeaders(ctx) ?? {};
  req.headers.addAll(headersFromCtx);

  // add required headers
  req.headers['Accept'] = applicationHeader;
  req.headers['Content-Type'] = applicationHeader;

  return req;
}
