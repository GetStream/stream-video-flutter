package io.getstream.webrtc.flutter.audio;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

import org.junit.Test;

public class AudioFocusHoldingTest {

    private final AudioFocusHolding holding = new AudioFocusHolding();

    @Test
    public void holdsFocusFromAManagedStart() {
        holding.onStart(true);

        assertTrue(holding.isHeld());
    }

    @Test
    public void holdsNoFocusFromAnUnmanagedStart() {
        holding.onStart(false);

        assertFalse(holding.isHeld());
    }

    @Test
    public void switchingOffDuringTheCallGivesUpTheFocus() {
        holding.onStart(true);

        assertEquals(AudioFocusHolding.Action.ABANDON, holding.onManagedChanged(false, true));
    }

    @Test
    public void switchingOnDuringTheCallRequestsFocus() {
        holding.onStart(false);

        assertEquals(AudioFocusHolding.Action.REQUEST, holding.onManagedChanged(true, true));
    }

    @Test
    public void switchingToTheCurrentStateDoesNothing() {
        holding.onStart(true);
        assertEquals(AudioFocusHolding.Action.NONE, holding.onManagedChanged(true, true));

        holding.onAbandoned();
        assertEquals(AudioFocusHolding.Action.NONE, holding.onManagedChanged(false, true));
    }

    @Test
    public void switchingWithNoCallAudioDoesNothing() {
        assertEquals(AudioFocusHolding.Action.NONE, holding.onManagedChanged(true, false));
        assertEquals(AudioFocusHolding.Action.NONE, holding.onManagedChanged(false, false));
    }

    @Test
    public void stoppingGivesUpFocusRequestedDuringTheCall() {
        holding.onStart(false);
        holding.onRequested(false);

        assertTrue(holding.onStop());
        assertFalse(holding.isHeld());
    }

    @Test
    public void aRefusedRequestKeepsAnEarlierOneHeld() {
        holding.onStart(false);
        holding.onRequested(false);
        holding.onRequested(true);

        assertTrue(holding.isHeld());
        assertEquals(AudioFocusHolding.Action.ABANDON, holding.onManagedChanged(false, true));
    }

    @Test
    public void aRefusedFirstRequestHoldsNothing() {
        holding.onStart(false);
        holding.onRequested(true);

        assertFalse(holding.isHeld());
    }

    @Test
    public void stoppingWithNoFocusGivesUpNothing() {
        holding.onStart(false);

        assertFalse(holding.onStop());
    }
}
