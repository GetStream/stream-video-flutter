package io.getstream.webrtc.flutter;

import android.app.Activity;
import android.content.Context;

import androidx.annotation.Nullable;
import java.util.Map;
import org.webrtc.AudioTrack;
import org.webrtc.MediaStream;
import org.webrtc.MediaStreamTrack;
import org.webrtc.PeerConnectionFactory;

import io.flutter.plugin.common.BinaryMessenger;

/**
 * Provides interested components with access to the current application state.
 *
 * It is encouraged to use this class instead of a component directly.
 */
public interface StateProvider {

  boolean putLocalStream(String streamId, MediaStream stream);

  boolean putLocalTrack(String trackId, LocalTrack track);

  LocalTrack getLocalTrack(String trackId);

  String getNextStreamUUID();

  String getNextTrackUUID();

  PeerConnectionObserver getPeerConnectionObserver(String peerConnectionId);

  @Nullable
  Activity getActivity();

  @Nullable
  Context getApplicationContext();

  BinaryMessenger getMessenger();

  void onRemoteAudioTrackAdded(AudioTrack track);

  void onRemoteAudioTrackRemoved(String trackId);
}
