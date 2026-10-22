package io.getstream.webrtc.flutter;

import io.getstream.webrtc.flutter.utils.AnyThreadSink;
import io.getstream.webrtc.flutter.utils.ConstraintsMap;

import org.webrtc.DataChannel;

import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;

class DataChannelObserver implements DataChannel.Observer, EventChannel.StreamHandler {

    private final String flutterId;
    private final DataChannel dataChannel;

    private final EventChannel eventChannel;
    private volatile EventChannel.EventSink eventSink;
    private final ArrayList eventQueue = new ArrayList();

    DataChannelObserver(BinaryMessenger messenger, String peerConnectionId, String flutterId,
                        DataChannel dataChannel) {
        this.flutterId = flutterId;
        this.dataChannel = dataChannel;
        eventChannel =
                new EventChannel(messenger, "FlutterWebRTC/dataChannelEvent" + peerConnectionId + flutterId);
        eventChannel.setStreamHandler(this);
    }

    private String dataChannelStateString(DataChannel.State dataChannelState) {
        switch (dataChannelState) {
            case CONNECTING:
                return "connecting";
            case OPEN:
                return "open";
            case CLOSING:
                return "closing";
            case CLOSED:
                return "closed";
        }
        return "";
    }

    @Override
    public void onListen(Object o, EventChannel.EventSink sink) {
        final EventChannel.EventSink target = new AnyThreadSink(sink);
        // Events are sent from WebRTC's signaling thread; hold the queue lock so
        // none is queued after the flush or appended while it is iterated.
        synchronized (eventQueue) {
            for(Object event : eventQueue) {
                target.success(event);
            }
            eventQueue.clear();
            eventSink = target;
        }
    }

    @Override
    public void onCancel(Object o) {
        eventSink = null;
    }
    
    @Override
    public void onBufferedAmountChange(long amount) {
        ConstraintsMap params = new ConstraintsMap();
        params.putString("event", "dataChannelBufferedAmountChange");
        params.putInt("id", dataChannel.id());
        params.putLong("bufferedAmount", dataChannel.bufferedAmount());
        params.putLong("changedAmount", amount);
        sendEvent(params);
    }

    @Override
    public void onStateChange() {
        ConstraintsMap params = new ConstraintsMap();
        params.putString("event", "dataChannelStateChanged");
        params.putInt("id", dataChannel.id());
        params.putString("state", dataChannelStateString(dataChannel.state()));
        sendEvent(params);
    }

    @Override
    public void onMessage(DataChannel.Buffer buffer) {
        ConstraintsMap params = new ConstraintsMap();
        params.putString("event", "dataChannelReceiveMessage");
        params.putInt("id", dataChannel.id());

        byte[] bytes;
        if (buffer.data.hasArray()) {
            bytes = buffer.data.array();
        } else {
            bytes = new byte[buffer.data.remaining()];
            buffer.data.get(bytes);
        }

        if (buffer.binary) {
            params.putString("type", "binary");
            params.putByte("data", bytes);
        } else {
            params.putString("type", "text");
            params.putString("data", new String(bytes, StandardCharsets.UTF_8));
        }

        sendEvent(params);
    }

    private void sendEvent(ConstraintsMap params) {
        synchronized (eventQueue) {
            final EventChannel.EventSink sink = eventSink;
            if (sink != null) {
                sink.success(params.toMap());
            } else {
                eventQueue.add(params.toMap());
            }
        }
    }
}
