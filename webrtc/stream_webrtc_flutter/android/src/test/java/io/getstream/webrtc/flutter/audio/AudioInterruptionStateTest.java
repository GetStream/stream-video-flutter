package io.getstream.webrtc.flutter.audio;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.junit.Before;
import org.junit.Test;

public class AudioInterruptionStateTest {

    private final List<String> reported = new ArrayList<>();
    private final AudioInterruptionState state = new AudioInterruptionState();

    private final AudioInterruptionState.Listener listener = new AudioInterruptionState.Listener() {
        @Override
        public void onInterruptionStart() {
            reported.add("start");
        }

        @Override
        public void onInterruptionEnd() {
            reported.add("end");
        }
    };

    @Before
    public void setUp() {
        state.setListener(listener);
    }

    @Test
    public void reportsAStartAndItsEnd() {
        assertEquals(AudioInterruptionState.Outcome.REPORTED, state.start());
        assertTrue(state.isActive());
        assertEquals(AudioInterruptionState.Outcome.REPORTED, state.end());
        assertFalse(state.isActive());

        assertEquals(Arrays.asList("start", "end"), reported);
    }

    @Test
    public void dropsARepeatedStart() {
        state.start();

        assertEquals(AudioInterruptionState.Outcome.IGNORED, state.start());
        assertEquals(Arrays.asList("start"), reported);
    }

    @Test
    public void dropsAnEndWithoutAStart() {
        assertEquals(AudioInterruptionState.Outcome.IGNORED, state.end());
        assertTrue(reported.isEmpty());
    }

    @Test
    public void startsAgainAfterAnEnd() {
        state.start();
        state.end();
        state.start();

        assertEquals(Arrays.asList("start", "end", "start"), reported);
    }

    @Test
    public void tracksNothingWithoutAListener() {
        state.setListener(null);

        assertEquals(AudioInterruptionState.Outcome.NO_LISTENER, state.start());
        assertFalse(state.isActive());
        assertEquals(AudioInterruptionState.Outcome.NO_LISTENER, state.end());
        assertTrue(reported.isEmpty());
    }

    @Test
    public void aNewListenerStartsWithNoInterruption() {
        state.start();
        state.setListener(listener);

        assertFalse(state.isActive());
        assertEquals(AudioInterruptionState.Outcome.IGNORED, state.end());
        assertEquals(Arrays.asList("start"), reported);
    }
}
