package io.getstream.video.flutter.stream_video_push_notification.core

import android.content.Context
import androidx.test.core.app.ApplicationProvider
import com.fasterxml.jackson.databind.JsonNode
import com.fasterxml.jackson.databind.ObjectMapper
import com.fasterxml.jackson.databind.node.ObjectNode
import java.util.concurrent.CountDownLatch
import java.util.concurrent.Executors
import java.util.concurrent.TimeUnit
import org.junit.After
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Assert.assertTrue
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner

/**
 * Pins the active-calls store: what it keeps, the JSON it keeps it as, and that concurrent
 * writers lose nothing.
 */
@RunWith(RobolectricTestRunner::class)
class PrefsCallStoreTest {

    private val context: Context get() = ApplicationProvider.getApplicationContext()
    private val prefs
        get() = context.getSharedPreferences(
            PrefsCallStore.PREFERENCES_FILE_NAME,
            Context.MODE_PRIVATE,
        )
    private lateinit var store: PrefsCallStore

    @Before
    fun createStore() {
        store = PrefsCallStore(context)
        store.removeAll()
    }

    @After
    fun clearStore() {
        store.removeAll()
    }

    private fun call(id: String, callCid: String = "default:$id") =
        RingingCall(id = id, callerName = "Ada", extra = mapOf("callCid" to callCid))

    @Test
    fun `a stored call reads back with every field`() {
        store.add(FULL_CALL)

        assertEquals(listOf(FULL_CALL), PrefsCallStore(context).all())
    }

    @Test
    fun `adding a call with a stored id updates only its accepted flag`() {
        store.add(call("a"))
        store.add(call("a").copy(callerName = "Renamed", isAccepted = true))

        val stored = store.all().single()
        assertTrue(stored.isAccepted)
        assertEquals("Ada", stored.callerName)
    }

    @Test
    fun `calls are found by id and by call cid, in the order they were added`() {
        store.add(call("a", callCid = "default:shared"))
        store.add(call("b"))
        store.add(call("c", callCid = "default:shared"))

        assertEquals(listOf("a", "b", "c"), store.all().map { it.id })
        assertEquals("b", store.byId("b")?.id)
        assertNull(store.byId("missing"))
        assertEquals(listOf("a", "c"), store.byCallCid("default:shared").map { it.id })
        assertEquals(emptyList<RingingCall>(), store.byCallCid("default:missing"))
    }

    @Test
    fun `removing one call keeps the others and removing all empties the store`() {
        store.add(call("a"))
        store.add(call("b"))

        store.remove("a")
        assertEquals(listOf("b"), store.all().map { it.id })

        store.removeAll()
        assertEquals(emptyList<RingingCall>(), store.all())
        assertNull(prefs.getString(PrefsCallStore.KEY, null))
    }

    @Test
    fun `two writers adding at the same time lose no call`() {
        val pool = Executors.newFixedThreadPool(2)
        val start = CountDownLatch(1)
        repeat(2) { writer ->
            pool.execute {
                start.await()
                repeat(50) { store.add(call("w$writer-$it")) }
            }
        }
        start.countDown()
        pool.shutdown()
        assertTrue(pool.awaitTermination(30, TimeUnit.SECONDS))

        assertEquals(100, store.all().size)
    }

    // The stored format.

    private fun legacyJson(): String =
        javaClass.classLoader!!.getResource(LEGACY_FIXTURE)!!.readText()

    @Test
    fun `reads the list the Data class stored`() {
        prefs.edit().putString(PrefsCallStore.KEY, legacyJson()).commit()

        assertEquals(
            listOf(
                FULL_CALL,
                // The Data class stored a missing missed-call id as 0 and missing missed-call
                // texts as empty strings.
                RingingCall(
                    id = "call-2",
                    missedNotificationId = 0,
                    missedNotificationSubtitle = "",
                    missedNotificationCallbackText = "",
                ),
            ),
            store.all(),
        )
    }

    @Test
    fun `writes the keys and values the Data class stored, without its duplicate keys`() {
        store.add(FULL_CALL)

        val mapper = ObjectMapper()
        val written = mapper.readTree(prefs.getString(PrefsCallStore.KEY, null)).single()
        val legacy = mapper.readTree(legacyJson()).first() as ObjectNode
        // Jackson wrote the is-prefixed Booleans a second time under their bean names, plus the
        // Data constructor's argument map and an id copy no code read.
        legacy.remove(listOf("args", "uuid", "accepted", "important", "bot", "showMissedCallNotification"))

        assertEquals(legacy as JsonNode, written)
    }

    @Test
    fun `writes a missing missed-call id and missing missed-call texts as null`() {
        store.add(RingingCall(id = "call-2"))

        val written = ObjectMapper().readTree(prefs.getString(PrefsCallStore.KEY, null)).single()
        assertTrue(written["missedNotificationId"].isNull)
        assertTrue(written["missedNotificationSubtitle"].isNull)
        assertTrue(written["missedNotificationCallbackText"].isNull)
    }

    private companion object {
        /** The active-calls list as the Jackson-serialized Data class stored it. */
        const val LEGACY_FIXTURE = "active_calls_stored_by_data_class.json"

        /** The call the fixture's first entry was written for, accepted. */
        val FULL_CALL = CallPayloadMapperTest.FULL_CALL.copy(isAccepted = true)
    }
}
