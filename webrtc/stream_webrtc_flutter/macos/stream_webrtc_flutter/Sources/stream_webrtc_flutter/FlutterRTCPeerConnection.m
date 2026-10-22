#import "include/stream_webrtc_flutter/FlutterRTCPeerConnection.h"
#import <objc/runtime.h>
#import <StreamWebRTC/StreamWebRTC.h>
#import "include/stream_webrtc_flutter/FlutterRTCDataChannel.h"
#import "include/stream_webrtc_flutter/FlutterWebRTCPlugin.h"
#import "include/stream_webrtc_flutter/NativePeerConnectionFactory.h"

@implementation RTCPeerConnection (Flutter)

@dynamic eventSink;

- (NSString*)flutterId {
  return objc_getAssociatedObject(self, _cmd);
}

- (void)setFlutterId:(NSString*)flutterId {
  objc_setAssociatedObject(self, @selector(flutterId), flutterId,
                           OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (FlutterEventSink)eventSink {
  return objc_getAssociatedObject(self, _cmd);
}

- (void)setEventSink:(FlutterEventSink)eventSink {
  // Atomic: WebRTC's threads read the sink while main sets or clears it, and an
  // atomic association hands the reader a retained reference.
  objc_setAssociatedObject(self, @selector(eventSink), eventSink, OBJC_ASSOCIATION_RETAIN);
}

- (FlutterEventChannel*)eventChannel {
  return objc_getAssociatedObject(self, _cmd);
}

- (void)setEventChannel:(FlutterEventChannel*)eventChannel {
  objc_setAssociatedObject(self, @selector(eventChannel), eventChannel,
                           OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (dispatch_queue_t)operationQueue {
  return objc_getAssociatedObject(self, _cmd);
}

- (void)setOperationQueue:(dispatch_queue_t)operationQueue {
  objc_setAssociatedObject(self, @selector(operationQueue), operationQueue,
                           OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary<NSString*, RTCDataChannel*>*)dataChannels {
  return objc_getAssociatedObject(self, _cmd);
}

- (void)setDataChannels:(NSMutableDictionary<NSString*, RTCDataChannel*>*)dataChannels {
  objc_setAssociatedObject(self, @selector(dataChannels), dataChannels,
                           OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary<NSString*, RTCMediaStream*>*)remoteStreams {
  return objc_getAssociatedObject(self, _cmd);
}

- (void)setRemoteStreams:(NSMutableDictionary<NSString*, RTCMediaStream*>*)remoteStreams {
  objc_setAssociatedObject(self, @selector(remoteStreams), remoteStreams,
                           OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary<NSString*, RTCMediaStreamTrack*>*)remoteTracks {
  return objc_getAssociatedObject(self, _cmd);
}

- (void)setRemoteTracks:(NSMutableDictionary<NSString*, RTCMediaStreamTrack*>*)remoteTracks {
  objc_setAssociatedObject(self, @selector(remoteTracks), remoteTracks,
                           OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - FlutterStreamHandler methods

- (FlutterError* _Nullable)onCancelWithArguments:(id _Nullable)arguments {
  self.eventSink = nil;
  return nil;
}

- (FlutterError* _Nullable)onListenWithArguments:(id _Nullable)arguments
                                       eventSink:(nonnull FlutterEventSink)sink {
  self.eventSink = sink;
  return nil;
}

@end

@implementation FlutterWebRTCPlugin (RTCPeerConnection)

- (void)peerConnectionSetConfiguration:(RTCConfiguration*)configuration
                        peerConnection:(RTCPeerConnection*)peerConnection {
  [peerConnection setConfiguration:configuration];
}

/**
 * Wraps a method-channel reply so it is delivered on the main thread. WebRTC
 * calls completion handlers on its signaling thread.
 */
FlutterResult FlutterRTCReplyOnMain(FlutterResult result) {
  return ^(id _Nullable value) {
    dispatch_async(dispatch_get_main_queue(), ^{
      result(value);
    });
  };
}

/**
 * Runs `operation` on the connection's serial `operationQueue` instead of the
 * caller's thread. The WebRTC Objective-C API blocks its caller until the
 * signaling and worker threads have handled a call, and setting a description
 * can wait there for the RTCAudioSession lock that an audio session
 * reconfiguration holds for its whole duration. Since Flutter 3.29 the main
 * thread also runs Dart, so these calls must not run on it.
 *
 * Main thread only: the operations of one connection then run in the order the
 * method calls arrived. Every call that reaches into the connection or its
 * senders and transceivers goes through here, so a call made without awaiting
 * an earlier one still reaches WebRTC after it. The block retains the connection, so a close requested
 * meanwhile cannot free it, and close itself goes through the same queue.
 */
void FlutterRTCRunOnOperationQueue(RTCPeerConnection* peerConnection, dispatch_block_t operation) {
  dispatch_queue_t queue = peerConnection.operationQueue;
  if (queue == nil) {
    operation();
    return;
  }
  dispatch_async(queue, operation);
}

- (void)peerConnectionCreateOffer:(NSDictionary*)constraints
                   peerConnection:(RTCPeerConnection*)peerConnection
                           result:(FlutterResult)result {
  RTCMediaConstraints* mediaConstraints = [self parseMediaConstraints:constraints];
  FlutterResult reply = FlutterRTCReplyOnMain(result);
  FlutterRTCRunOnOperationQueue(peerConnection, ^{
    [peerConnection
        offerForConstraints:mediaConstraints
          completionHandler:^(RTCSessionDescription* sdp, NSError* error) {
            if (error) {
              reply([FlutterError
                  errorWithCode:@"CreateOfferFailed"
                        message:[NSString stringWithFormat:@"Error %@", error.userInfo[@"error"]]
                        details:nil]);
            } else {
              NSString* type = [RTCSessionDescription stringForType:sdp.type];
              reply(@{@"sdp" : sdp.sdp, @"type" : type});
            }
          }];
  });
}

- (void)peerConnectionCreateAnswer:(NSDictionary*)constraints
                    peerConnection:(RTCPeerConnection*)peerConnection
                            result:(FlutterResult)result {
  RTCMediaConstraints* mediaConstraints = [self parseMediaConstraints:constraints];
  FlutterResult reply = FlutterRTCReplyOnMain(result);
  FlutterRTCRunOnOperationQueue(peerConnection, ^{
    [peerConnection
        answerForConstraints:mediaConstraints
           completionHandler:^(RTCSessionDescription* sdp, NSError* error) {
             if (error) {
               reply([FlutterError
                   errorWithCode:@"CreateAnswerFailed"
                         message:[NSString stringWithFormat:@"Error %@", error.userInfo[@"error"]]
                         details:nil]);
             } else {
               NSString* type = [RTCSessionDescription stringForType:sdp.type];
               reply(@{@"sdp" : sdp.sdp, @"type" : type});
             }
           }];
  });
}

- (void)peerConnectionSetLocalDescription:(RTCSessionDescription*)sdp
                           peerConnection:(RTCPeerConnection*)peerConnection
                                   result:(FlutterResult)result {
  FlutterResult reply = FlutterRTCReplyOnMain(result);
  FlutterRTCRunOnOperationQueue(peerConnection, ^{
    [peerConnection
        setLocalDescription:sdp
          completionHandler:^(NSError* error) {
            if (error) {
              reply([FlutterError
                  errorWithCode:@"SetLocalDescriptionFailed"
                        message:[NSString stringWithFormat:@"Error %@", error.localizedDescription]
                        details:nil]);
            } else {
              reply(nil);
            }
          }];
  });
}

- (void)peerConnectionSetRemoteDescription:(RTCSessionDescription*)sdp
                            peerConnection:(RTCPeerConnection*)peerConnection
                                    result:(FlutterResult)result {
  FlutterResult reply = FlutterRTCReplyOnMain(result);
  FlutterRTCRunOnOperationQueue(peerConnection, ^{
    [peerConnection
        setRemoteDescription:sdp
           completionHandler:^(NSError* error) {
             if (error) {
               reply([FlutterError
                   errorWithCode:@"SetRemoteDescriptionFailed"
                         message:[NSString stringWithFormat:@"Error %@", error.localizedDescription]
                         details:nil]);
             } else {
               reply(nil);
             }
           }];
  });
}

- (void)peerConnectionAddICECandidate:(RTCIceCandidate*)candidate
                       peerConnection:(RTCPeerConnection*)peerConnection
                               result:(FlutterResult)result {
  // Same queue as the descriptions: a candidate sent right after
  // setRemoteDescription, without awaiting it, must not reach WebRTC first.
  FlutterResult reply = FlutterRTCReplyOnMain(result);
  FlutterRTCRunOnOperationQueue(peerConnection, ^{
    [peerConnection
          addIceCandidate:candidate
        completionHandler:^(NSError* _Nullable error) {
          if (error) {
            reply([FlutterError
                errorWithCode:@"AddIceCandidateFailed"
                      message:[NSString stringWithFormat:@"Error %@", error.localizedDescription]
                      details:nil]);
          } else {
            reply(nil);
          }
        }];
  });
}

- (void)peerConnectionClose:(RTCPeerConnection*)peerConnection {
  [peerConnection close];

  for (NSString* trackId in peerConnection.remoteTracks) {
    [self.pausedTrackVolumes removeObjectForKey:trackId];
    [self.trackVolumeCache removeObjectForKey:trackId];
  }

  // Clean up peerConnection's streams and tracks
  [peerConnection.remoteStreams removeAllObjects];
  [peerConnection.remoteTracks removeAllObjects];

  // Clean up peerConnection's dataChannels.
  NSMutableDictionary<NSString*, RTCDataChannel*>* dataChannels = peerConnection.dataChannels;
  for (NSString* dataChannelId in dataChannels) {
    dataChannels[dataChannelId].delegate = nil;
    // There is no need to close the RTCDataChannel because it is owned by the
    // RTCPeerConnection and the latter will close the former.
  }
  [dataChannels removeAllObjects];
}

- (void)peerConnectionGetStatsForTrackId:(nonnull NSString*)trackID
                          peerConnection:(nonnull RTCPeerConnection*)peerConnection
                                  result:(nonnull FlutterResult)result {
  RTCRtpSender* sender = nil;
  RTCRtpReceiver* receiver = nil;

  for (RTCRtpSender* s in peerConnection.senders) {
    if (s.track != nil && [s.track.trackId isEqualToString:trackID]) {
      sender = s;
    }
  }

  for (RTCRtpReceiver* r in peerConnection.receivers) {
    if (r.track != nil && [r.track.trackId isEqualToString:trackID]) {
      receiver = r;
    }
  }

  if (sender != nil) {
    [peerConnection statisticsForSender:sender
                      completionHandler:^(RTCStatisticsReport* statsReport) {
                        NSMutableArray* stats = [NSMutableArray array];
                        for (id key in statsReport.statistics) {
                          RTCStatistics* report = [statsReport.statistics objectForKey:key];
                          [stats addObject:@{
                            @"id" : report.id,
                            @"type" : report.type,
                            @"timestamp" : @(report.timestamp_us),
                            @"values" : report.values
                          }];
                        }
                        result(@{@"stats" : stats});
                      }];
  } else if (receiver != nil) {
    [peerConnection statisticsForReceiver:receiver
                        completionHandler:^(RTCStatisticsReport* statsReport) {
                          NSMutableArray* stats = [NSMutableArray array];
                          for (id key in statsReport.statistics) {
                            RTCStatistics* report = [statsReport.statistics objectForKey:key];
                            [stats addObject:@{
                              @"id" : report.id,
                              @"type" : report.type,
                              @"timestamp" : @(report.timestamp_us),
                              @"values" : report.values
                            }];
                          }
                          result(@{@"stats" : stats});
                        }];
  } else {
    result([FlutterError errorWithCode:@"GetStatsFailed"
                               message:[NSString stringWithFormat:@"Error %@", @""]
                               details:nil]);
  }
}

- (void)peerConnectionGetStats:(nonnull RTCPeerConnection*)peerConnection
                        result:(nonnull FlutterResult)result {
  [peerConnection statisticsWithCompletionHandler:^(RTCStatisticsReport* statsReport) {
    NSMutableArray* stats = [NSMutableArray array];
    for (id key in statsReport.statistics) {
      RTCStatistics* report = [statsReport.statistics objectForKey:key];
      [stats addObject:@{
        @"id" : report.id,
        @"type" : report.type,
        @"timestamp" : @(report.timestamp_us),
        @"values" : report.values
      }];
    }
    result(@{@"stats" : stats});
  }];
}

- (NSString*)stringForICEConnectionState:(RTCIceConnectionState)state {
  switch (state) {
    case RTCIceConnectionStateNew:
      return @"new";
    case RTCIceConnectionStateChecking:
      return @"checking";
    case RTCIceConnectionStateConnected:
      return @"connected";
    case RTCIceConnectionStateCompleted:
      return @"completed";
    case RTCIceConnectionStateFailed:
      return @"failed";
    case RTCIceConnectionStateDisconnected:
      return @"disconnected";
    case RTCIceConnectionStateClosed:
      return @"closed";
    case RTCIceConnectionStateCount:
      return @"count";
  }
  return nil;
}

- (NSString*)stringForICEGatheringState:(RTCIceGatheringState)state {
  switch (state) {
    case RTCIceGatheringStateNew:
      return @"new";
    case RTCIceGatheringStateGathering:
      return @"gathering";
    case RTCIceGatheringStateComplete:
      return @"complete";
  }
  return nil;
}

- (NSString*)stringForSignalingState:(RTCSignalingState)state {
  switch (state) {
    case RTCSignalingStateStable:
      return @"stable";
    case RTCSignalingStateHaveLocalOffer:
      return @"have-local-offer";
    case RTCSignalingStateHaveLocalPrAnswer:
      return @"have-local-pranswer";
    case RTCSignalingStateHaveRemoteOffer:
      return @"have-remote-offer";
    case RTCSignalingStateHaveRemotePrAnswer:
      return @"have-remote-pranswer";
    case RTCSignalingStateClosed:
      return @"closed";
  }
  return nil;
}

- (NSString*)stringForPeerConnectionState:(RTCPeerConnectionState)state {
  switch (state) {
    case RTCPeerConnectionStateNew:
      return @"new";
    case RTCPeerConnectionStateConnecting:
      return @"connecting";
    case RTCPeerConnectionStateConnected:
      return @"connected";
    case RTCPeerConnectionStateDisconnected:
      return @"disconnected";
    case RTCPeerConnectionStateFailed:
      return @"failed";
    case RTCPeerConnectionStateClosed:
      return @"closed";
  }
  return nil;
}

/**
 * Parses the constraint keys and values of a specific JavaScript object into
 * a specific <tt>NSMutableDictionary</tt> in a format suitable for the
 * initialization of a <tt>RTCMediaConstraints</tt> instance.
 *
 * @param src The JavaScript object which defines constraint keys and values and
 * which is to be parsed into the specified <tt>dst</tt>.
 * @param dst The <tt>NSMutableDictionary</tt> into which the constraint keys
 * and values defined by <tt>src</tt> are to be written in a format suitable for
 * the initialization of a <tt>RTCMediaConstraints</tt> instance.
 */
- (void)parseJavaScriptConstraints:(NSDictionary*)src
             intoWebRTCConstraints:(NSMutableDictionary<NSString*, NSString*>*)dst {
  for (id srcKey in src) {
    id srcValue = src[srcKey];
    NSString* dstValue;

    if ([srcValue isKindOfClass:[NSNumber class]]) {
      dstValue = [srcValue boolValue] ? @"true" : @"false";
    } else {
      dstValue = [srcValue description];
    }
    dst[[srcKey description]] = dstValue;
  }
}

/**
 * Parses a JavaScript object into a new <tt>RTCMediaConstraints</tt> instance.
 *
 * @param constraints The JavaScript object to parse into a new
 * <tt>RTCMediaConstraints</tt> instance.
 * @returns A new <tt>RTCMediaConstraints</tt> instance initialized with the
 * mandatory and optional constraint keys and values specified by
 * <tt>constraints</tt>.
 */
- (RTCMediaConstraints*)parseMediaConstraints:(NSDictionary*)constraints {
  id mandatory = constraints[@"mandatory"];
  NSMutableDictionary<NSString*, NSString*>* mandatory_ = [NSMutableDictionary new];

  if ([mandatory isKindOfClass:[NSDictionary class]]) {
    [self parseJavaScriptConstraints:(NSDictionary*)mandatory intoWebRTCConstraints:mandatory_];
  }

  id optional = constraints[@"optional"];
  NSMutableDictionary<NSString*, NSString*>* optional_ = [NSMutableDictionary new];

  if ([optional isKindOfClass:[NSArray class]]) {
    for (id o in (NSArray*)optional) {
      if ([o isKindOfClass:[NSDictionary class]]) {
        [self parseJavaScriptConstraints:(NSDictionary*)o intoWebRTCConstraints:optional_];
      }
    }
  }

  return [[RTCMediaConstraints alloc] initWithMandatoryConstraints:mandatory_
                                               optionalConstraints:optional_];
}

#pragma mark - RTCPeerConnectionDelegate methods
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
- (void)peerConnection:(RTCPeerConnection*)peerConnection
    didChangeSignalingState:(RTCSignalingState)newState {
  FlutterEventSink eventSink = peerConnection.eventSink;
  if (eventSink) {
    postEvent(eventSink,
              @{@"event" : @"signalingState", @"state" : [self stringForSignalingState:newState]});
  }
}

- (void)peerConnection:(RTCPeerConnection*)peerConnection
           mediaStream:(RTCMediaStream*)stream
           didAddTrack:(RTCVideoTrack*)track {
  peerConnection.remoteTracks[track.trackId] = track;
  NSString* streamId = stream.streamId;
  peerConnection.remoteStreams[streamId] = stream;

  if ([track isKindOfClass:[RTCAudioTrack class]]) {
    RTCAudioTrack* audioTrack = (RTCAudioTrack*)track;
    NSString* trackId = track.trackId;
    if (self.trackVolumeCache[trackId] == nil) {
      self.trackVolumeCache[trackId] = @(1.0);
    }
    if (self.isAudioPlayoutPaused) {
      self.pausedTrackVolumes[trackId] = self.trackVolumeCache[trackId];
      audioTrack.source.volume = 0.0;
    }
  }

  FlutterEventSink eventSink = peerConnection.eventSink;
  if (eventSink) {
    postEvent(eventSink, @{
      @"event" : @"onAddTrack",
      @"streamId" : streamId,
      @"trackId" : track.trackId,
      @"track" : @{
        @"id" : track.trackId,
        @"kind" : track.kind,
        @"label" : track.trackId,
        @"enabled" : @(track.isEnabled),
        @"remote" : @(YES),
        @"readyState" : @"live"
      }
    });
  }
}

- (void)peerConnection:(RTCPeerConnection*)peerConnection
           mediaStream:(RTCMediaStream*)stream
        didRemoveTrack:(RTCVideoTrack*)track {
  [peerConnection.remoteTracks removeObjectForKey:track.trackId];
  [self.pausedTrackVolumes removeObjectForKey:track.trackId];
  [self.trackVolumeCache removeObjectForKey:track.trackId];
  NSString* streamId = stream.streamId;
  FlutterEventSink eventSink = peerConnection.eventSink;
  if (eventSink) {
    postEvent(eventSink, @{
      @"event" : @"onRemoveTrack",
      @"streamId" : streamId,
      @"trackId" : track.trackId,
      @"track" : @{
        @"id" : track.trackId,
        @"kind" : track.kind,
        @"label" : track.trackId,
        @"enabled" : @(track.isEnabled),
        @"remote" : @(YES),
        @"readyState" : @"live"
      }
    });
  }
}

- (void)peerConnection:(RTCPeerConnection*)peerConnection didAddStream:(RTCMediaStream*)stream {
  NSMutableArray* audioTracks = [NSMutableArray array];
  NSMutableArray* videoTracks = [NSMutableArray array];
  NSArray<RTCAudioTrack*>* streamAudioTracks = stream.audioTracks;
  NSArray<RTCVideoTrack*>* streamVideoTracks = stream.videoTracks;

  for (RTCAudioTrack* track in streamAudioTracks) {
    [audioTracks addObject:@{
      @"id" : track.trackId,
      @"kind" : track.kind,
      @"label" : track.trackId,
      @"enabled" : @(track.isEnabled),
      @"remote" : @(YES),
      @"readyState" : @"live"
    }];
  }

  for (RTCVideoTrack* track in streamVideoTracks) {
    [videoTracks addObject:@{
      @"id" : track.trackId,
      @"kind" : track.kind,
      @"label" : track.trackId,
      @"enabled" : @(track.isEnabled),
      @"remote" : @(YES),
      @"readyState" : @"live"
    }];
  }

  NSString* streamId = stream.streamId;

  // The track bookkeeping is owned by main; see peerConnection:didAddReceiver:.
  dispatch_async(dispatch_get_main_queue(), ^{
    for (RTCAudioTrack* track in streamAudioTracks) {
      NSString* trackId = track.trackId;
      peerConnection.remoteTracks[trackId] = track;
      if (self.trackVolumeCache[trackId] == nil) {
        self.trackVolumeCache[trackId] = @(1.0);
      }
      if (self.isAudioPlayoutPaused) {
        self.pausedTrackVolumes[trackId] = self.trackVolumeCache[trackId];
        track.source.volume = 0.0;
      }
    }
    for (RTCVideoTrack* track in streamVideoTracks) {
      peerConnection.remoteTracks[track.trackId] = track;
    }
    peerConnection.remoteStreams[streamId] = stream;

    if (streamAudioTracks.count > 0) {
      [self ensureAudioSession];
    }

    FlutterEventSink eventSink = peerConnection.eventSink;
    if (eventSink) {
      eventSink(@{
        @"event" : @"onAddStream",
        @"streamId" : streamId,
        @"audioTracks" : audioTracks,
        @"videoTracks" : videoTracks,
      });
    }
  });
}

- (void)peerConnection:(RTCPeerConnection*)peerConnection didRemoveStream:(RTCMediaStream*)stream {
  NSString* streamId = stream.streamId;
  NSArray<RTCAudioTrack*>* streamAudioTracks = stream.audioTracks;
  NSArray<RTCVideoTrack*>* streamVideoTracks = stream.videoTracks;

  // The track bookkeeping is owned by main; see peerConnection:didAddReceiver:.
  dispatch_async(dispatch_get_main_queue(), ^{
    NSArray* keysArray = [peerConnection.remoteStreams allKeysForObject:stream];
    // We assume there can be only one object for 1 key
    if (keysArray.count > 1) {
      NSLog(@"didRemoveStream - more than one stream entry found for stream instance with id: %@",
            streamId);
    }

    for (RTCVideoTrack* track in streamVideoTracks) {
      [peerConnection.remoteTracks removeObjectForKey:track.trackId];
    }
    for (RTCAudioTrack* track in streamAudioTracks) {
      [peerConnection.remoteTracks removeObjectForKey:track.trackId];
      [self.pausedTrackVolumes removeObjectForKey:track.trackId];
      [self.trackVolumeCache removeObjectForKey:track.trackId];
    }

    FlutterEventSink eventSink = peerConnection.eventSink;
    if (eventSink) {
      eventSink(@{
        @"event" : @"onRemoveStream",
        @"streamId" : streamId,
      });
    }
  });
}

- (void)peerConnectionShouldNegotiate:(RTCPeerConnection*)peerConnection {
  FlutterEventSink eventSink = peerConnection.eventSink;
  if (eventSink) {
    postEvent(eventSink, @{
      @"event" : @"onRenegotiationNeeded",
    });
  }
}

- (void)peerConnection:(RTCPeerConnection*)peerConnection
    didChangeIceConnectionState:(RTCIceConnectionState)newState {
  FlutterEventSink eventSink = peerConnection.eventSink;
  if (eventSink) {
    postEvent(eventSink, @{
      @"event" : @"iceConnectionState",
      @"state" : [self stringForICEConnectionState:newState]
    });
  }
}

- (void)peerConnection:(RTCPeerConnection*)peerConnection
    didChangeIceGatheringState:(RTCIceGatheringState)newState {
  FlutterEventSink eventSink = peerConnection.eventSink;
  if (eventSink) {
    postEvent(
        eventSink,
        @{@"event" : @"iceGatheringState", @"state" : [self stringForICEGatheringState:newState]});
  }
}

- (void)peerConnection:(RTCPeerConnection*)peerConnection
    didGenerateIceCandidate:(RTCIceCandidate*)candidate {
  FlutterEventSink eventSink = peerConnection.eventSink;
  if (eventSink) {
    postEvent(eventSink, @{
      @"event" : @"onCandidate",
      @"candidate" : @{
        @"candidate" : candidate.sdp,
        @"sdpMLineIndex" : @(candidate.sdpMLineIndex),
        @"sdpMid" : candidate.sdpMid
      }
    });
  }
}

- (void)peerConnection:(RTCPeerConnection*)peerConnection
    didOpenDataChannel:(RTCDataChannel*)dataChannel {
  if (-1 == dataChannel.channelId) {
    return;
  }

  NSString* flutterChannelId = [[NSUUID UUID] UUIDString];
  NSNumber* dataChannelId = [NSNumber numberWithInteger:dataChannel.channelId];
  dataChannel.peerConnectionId = peerConnection.flutterId;
  dataChannel.delegate = self;
  peerConnection.dataChannels[flutterChannelId] = dataChannel;

  FlutterEventChannel* eventChannel = [FlutterEventChannel
      eventChannelWithName:[NSString stringWithFormat:@"FlutterWebRTC/dataChannelEvent%1$@%2$@",
                                                      peerConnection.flutterId, flutterChannelId]
           binaryMessenger:self.messenger];

  dataChannel.eventChannel = eventChannel;
  dataChannel.flutterChannelId = flutterChannelId;
  dataChannel.eventQueue = nil;

  dispatch_async(dispatch_get_main_queue(), ^{
    // setStreamHandler on main thread
    [eventChannel setStreamHandler:dataChannel];
    FlutterEventSink eventSink = peerConnection.eventSink;
    if (eventSink) {
      postEvent(eventSink, @{
        @"event" : @"didOpenDataChannel",
        @"id" : dataChannelId,
        @"label" : dataChannel.label,
        @"flutterId" : flutterChannelId
      });
    }
  });
}

/** Called any time the PeerConnectionState changes. */
- (void)peerConnection:(RTCPeerConnection*)peerConnection
    didChangeConnectionState:(RTCPeerConnectionState)newState {
  FlutterEventSink eventSink = peerConnection.eventSink;
  if (eventSink) {
    postEvent(eventSink, @{
      @"event" : @"peerConnectionState",
      @"state" : [self stringForPeerConnectionState:newState]
    });
  }
}

- (void)peerConnection:(RTCPeerConnection*)peerConnection
    didStartReceivingOnTransceiver:(RTCRtpTransceiver*)transceiver {
}

/**
 * Called when a receiver and its track are created.
 *
 * WebRTC calls this on its signaling thread, typically from inside
 * setRemoteDescription. The event is built here, where reading the receiver and
 * the transceivers needs no thread hop, but the track bookkeeping
 * (`remoteTracks`, `remoteStreams`, the volume caches) is owned by main, which
 * reads and enumerates it, and the description calls no longer block main while
 * WebRTC runs these callbacks. So it is updated on main, and the event is sent
 * from that same block, straight to the sink: posting it again would let a
 * signaling-state event sent after it overtake it.
 */
- (void)peerConnection:(RTCPeerConnection*)peerConnection
        didAddReceiver:(RTCRtpReceiver*)rtpReceiver
               streams:(NSArray<RTCMediaStream*>*)mediaStreams {
  // For unified-plan
  NSMutableArray* streams = [NSMutableArray array];
  for (RTCMediaStream* stream in mediaStreams) {
    [streams addObject:[self mediaStreamToMap:stream ownerTag:peerConnection.flutterId]];
  }
  RTCMediaStreamTrack* track = rtpReceiver.track;
  NSMutableDictionary* event = [NSMutableDictionary dictionary];
  [event addEntriesFromDictionary:@{
    @"event" : @"onTrack",
    @"track" : [self mediaTrackToMap:track],
    @"receiver" : [self receiverToMap:rtpReceiver],
    @"streams" : streams,
  }];

  if (peerConnection.configuration.sdpSemantics == RTCSdpSemanticsUnifiedPlan) {
    for (RTCRtpTransceiver* transceiver in peerConnection.transceivers) {
      if (transceiver.receiver != nil &&
          [transceiver.receiver.receiverId isEqualToString:rtpReceiver.receiverId]) {
        [event setValue:[self transceiverToMap:transceiver] forKey:@"transceiver"];
      }
    }
  }

  dispatch_async(dispatch_get_main_queue(), ^{
    FlutterEventSink eventSink = peerConnection.eventSink;
    if (!eventSink) {
      return;
    }

    peerConnection.remoteTracks[track.trackId] = track;
    if (mediaStreams.count > 0) {
      peerConnection.remoteStreams[mediaStreams[0].streamId] = mediaStreams[0];
    }

    if ([track.kind isEqualToString:@"audio"]) {
      [self ensureAudioSession];
      NSString* trackId = track.trackId;
      if (self.trackVolumeCache[trackId] == nil) {
        self.trackVolumeCache[trackId] = @(1.0);
      }
      if (self.isAudioPlayoutPaused && [track isKindOfClass:[RTCAudioTrack class]]) {
        RTCAudioTrack* audioTrack = (RTCAudioTrack*)track;
        self.pausedTrackVolumes[trackId] = self.trackVolumeCache[trackId];
        // On main, like setVolume / pauseAudioPlayout / resumeAudioPlayout:
        // queued elsewhere it could land after a resume and mute the track.
        audioTrack.source.volume = 0.0;
      }
    }
    eventSink(event);
  });
}

/** Called when the receiver and its track are removed. */
- (void)peerConnection:(RTCPeerConnection*)peerConnection
     didRemoveReceiver:(RTCRtpReceiver*)rtpReceiver {
  NSString* trackId = rtpReceiver.track.trackId;
  if (trackId == nil) {
    return;
  }
  // Owned by main; see peerConnection:didAddReceiver:.
  dispatch_async(dispatch_get_main_queue(), ^{
    [self.pausedTrackVolumes removeObjectForKey:trackId];
    [self.trackVolumeCache removeObjectForKey:trackId];
  });
}

/** Called when the selected ICE candidate pair is changed. */
- (void)peerConnection:(RTCPeerConnection*)peerConnection
    didChangeLocalCandidate:(RTCIceCandidate*)local
            remoteCandidate:(RTCIceCandidate*)remote
             lastReceivedMs:(int)lastDataReceivedMs
               changeReason:(NSString*)reason {
  FlutterEventSink eventSink = peerConnection.eventSink;
  if (eventSink) {
    postEvent(eventSink, @{
      @"event" : @"onSelectedCandidatePairChanged",
      @"local" : @{
        @"candidate" : local.sdp,
        @"sdpMLineIndex" : @(local.sdpMLineIndex),
        @"sdpMid" : local.sdpMid
      },
      @"remote" : @{
        @"candidate" : remote.sdp,
        @"sdpMLineIndex" : @(remote.sdpMLineIndex),
        @"sdpMid" : remote.sdpMid
      },
      @"reason" : reason,
      @"lastDataReceivedMs" : @(lastDataReceivedMs)
    });
  }
}

- (void)peerConnection:(RTCPeerConnection*)peerConnection
    didRemoveIceCandidates:(NSArray<RTCIceCandidate*>*)candidates {
}

NSString* mediaTypeFromString(NSString* kind) {
  NSString* mediaType = kRTCMediaStreamTrackKindAudio;
  if ([kind isEqualToString:@"audio"]) {
    mediaType = kRTCMediaStreamTrackKindAudio;
  } else if ([kind isEqualToString:@"video"]) {
    mediaType = kRTCMediaStreamTrackKindVideo;
  }
  return mediaType;
}

NSString* parametersToString(NSDictionary<NSString*, NSString*>* parameters) {
  NSMutableArray* kvs = [NSMutableArray array];
  for (NSString* key in parameters) {
    if (key.length > 0) {
      [kvs addObject:[NSString stringWithFormat:@"%@=%@", key, parameters[key]]];
    } else {
      [kvs addObject:parameters[key]];
    }
  }
  return [kvs componentsJoinedByString:@";"];
}

NSDictionary<NSString*, NSString*>* stringToParameters(NSString* str) {
  NSMutableDictionary<NSString*, NSString*>* parameters = [NSMutableDictionary dictionary];
  NSArray<NSString*>* kvs = [str componentsSeparatedByString:@";"];
  for (NSString* kv in kvs) {
    NSArray<NSString*>* kvArr = [kv componentsSeparatedByString:@"="];
    if (kvArr.count == 2) {
      parameters[kvArr[0]] = kvArr[1];
    } else if (kvArr.count == 1) {
      parameters[@""] = kvArr[0];
    }
  }
  return parameters;
}

- (void)peerConnectionGetRtpReceiverCapabilities:(nonnull NSDictionary*)argsMap
                                          result:(nonnull FlutterResult)result {
  NSString* factoryId = argsMap[@"factoryId"];
  NativePeerConnectionFactory* nf = [self resolveFactoryForId:factoryId];
  if (factoryId == nil || factoryId.length == 0 || nf == nil || nf.factory == nil) {
    result([FlutterError errorWithCode:@"MISSING_FACTORY_ID"
                               message:@"getRtpReceiverCapabilities requires a valid factoryId"
                               details:@{@"factoryId" : factoryId ?: [NSNull null]}]);
    return;
  }
  NSString* kind = argsMap[@"kind"];
  RTCRtpCapabilities* caps = [nf.factory rtpReceiverCapabilitiesForKind:mediaTypeFromString(kind)];
  NSMutableArray* codecsMap = [NSMutableArray array];
  for (RTCRtpCodecCapability* c in caps.codecs) {
    if ([kind isEqualToString:@"audio"]) {
      [codecsMap addObject:@{
        @"channels" : c.numChannels,
        @"clockRate" : c.clockRate,
        @"mimeType" : c.mimeType,
        @"sdpFmtpLine" : parametersToString(c.parameters),
      }];
    } else if ([kind isEqualToString:@"video"]) {
      [codecsMap addObject:@{
        @"clockRate" : c.clockRate,
        @"mimeType" : c.mimeType,
        @"sdpFmtpLine" : parametersToString(c.parameters),
      }];
    }
  }
  result(@{
    @"codecs" : codecsMap,
    @"headerExtensions" : @[],
    @"fecMechanisms" : @[],
  });
}

- (void)peerConnectionGetRtpSenderCapabilities:(nonnull NSDictionary*)argsMap
                                        result:(nonnull FlutterResult)result {
  NSString* factoryId = argsMap[@"factoryId"];
  NativePeerConnectionFactory* nf = [self resolveFactoryForId:factoryId];
  if (factoryId == nil || factoryId.length == 0 || nf == nil || nf.factory == nil) {
    result([FlutterError errorWithCode:@"MISSING_FACTORY_ID"
                               message:@"getRtpSenderCapabilities requires a valid factoryId"
                               details:@{@"factoryId" : factoryId ?: [NSNull null]}]);
    return;
  }
  NSString* kind = argsMap[@"kind"];
  RTCRtpCapabilities* caps = [nf.factory rtpSenderCapabilitiesForKind:mediaTypeFromString(kind)];
  NSMutableArray* codecsMap = [NSMutableArray array];
  for (RTCRtpCodecCapability* c in caps.codecs) {
    if ([kind isEqualToString:@"audio"]) {
      [codecsMap addObject:@{
        @"channels" : c.numChannels,
        @"clockRate" : c.clockRate,
        @"mimeType" : c.mimeType,
        @"sdpFmtpLine" : parametersToString(c.parameters),
      }];
    } else if ([kind isEqualToString:@"video"]) {
      [codecsMap addObject:@{
        @"clockRate" : c.clockRate,
        @"mimeType" : c.mimeType,
        @"sdpFmtpLine" : parametersToString(c.parameters),
      }];
    }
  }
  result(@{
    @"codecs" : codecsMap,
    @"headerExtensions" : @[],
    @"fecMechanisms" : @[],
  });
}

- (RTC_OBJC_TYPE(RTCRtpCodecCapability) *)findCodecCapability:(NSString*)kind
                                                        codec:(NSString*)codec
                                                   parameters:(NSDictionary<NSString*, NSString*>*)
                                                                  parameters
                                                      factory:(RTCPeerConnectionFactory*)factory {
  if (factory == nil) return nil;
  RTCRtpCapabilities* caps = [factory
      rtpSenderCapabilitiesForKind:[kind isEqualToString:@"video"] ? kRTCMediaStreamTrackKindVideo
                                                                   : kRTCMediaStreamTrackKindAudio];
  for (RTCRtpCodecCapability* capCodec in caps.codecs) {
    if ([capCodec.name isEqualToString:codec] && [capCodec.kind isEqualToString:kind]) {
      BOOL matched = YES;
      for (NSString* key in capCodec.parameters) {
        NSString* value = [capCodec.parameters objectForKey:key];
        NSString* value2 = [parameters objectForKey:key];
        if (![value isEqualToString:value2]) {
          matched = NO;
        }
      }
      if (matched) {
        return capCodec;
      }
    }
  }
  return nil;
}

- (void)transceiverSetCodecPreferences:(nonnull NSDictionary*)argsMap
                                result:(nonnull FlutterResult)result {
  NSString* peerConnectionId = argsMap[@"peerConnectionId"];
  RTCPeerConnection* peerConnection = self.peerConnections[peerConnectionId];
  if (peerConnection == nil) {
    result([FlutterError
        errorWithCode:@"transceiverSetCodecPreferencesFailed"
              message:[NSString stringWithFormat:@"Error: peerConnection not found!"]
              details:nil]);
    return;
  }
  // Resolve the per-call factory that built this peer connection so the
  // capability lookup runs against the correct codec set.
  NSString* factoryIdForPc = self.pcFactoryId[peerConnectionId];
  NativePeerConnectionFactory* nf = [self resolveFactoryForId:factoryIdForPc];
  RTCPeerConnectionFactory* factory = nf.factory;
  NSString* transceiverId = argsMap[@"transceiverId"];
  id codecs = argsMap[@"codecs"];
  // On the connection's queue, in order with the description calls: the
  // preferences must be set before the offer that should carry them.
  FlutterResult reply = FlutterRTCReplyOnMain(result);
  FlutterRTCRunOnOperationQueue(peerConnection, ^{
    RTCRtpTransceiver* transcevier = [self getRtpTransceiverById:peerConnection Id:transceiverId];
    if (transcevier == nil) {
      reply([FlutterError errorWithCode:@"transceiverSetCodecPreferencesFailed"
                                message:[NSString stringWithFormat:@"Error: transcevier not found!"]
                                details:nil]);
      return;
    }
    NSMutableArray* codecCaps = [NSMutableArray array];
    for (id c in codecs) {
      NSArray* kindAndName = [c[@"mimeType"] componentsSeparatedByString:@"/"];
      NSString* kind = [kindAndName[0] lowercaseString];
      NSString* name = kindAndName[1];
      NSLog(@"codec %@/%@", kind, name);
      NSDictionary<NSString*, NSString*>* parameters = nil;
      if (c[@"sdpFmtpLine"] != nil && ![((NSString*)c[@"sdpFmtpLine"]) isEqualToString:@""]) {
        parameters = stringToParameters((NSString*)c[@"sdpFmtpLine"]);
      }
      RTCRtpCodecCapability* codec = [self findCodecCapability:kind
                                                         codec:name
                                                    parameters:parameters
                                                       factory:factory];
      if (codec != nil) {
        [codecCaps addObject:codec];
      }
    }
    NSError* error = nil;
    [transcevier setCodecPreferences:codecCaps error:&error];
    if (error) {
      reply([FlutterError errorWithCode:@"SetCodecPreferencesError"
                                message:error.localizedDescription
                                details:nil]);
    } else {
      reply(nil);
    }
  });
}

@end
