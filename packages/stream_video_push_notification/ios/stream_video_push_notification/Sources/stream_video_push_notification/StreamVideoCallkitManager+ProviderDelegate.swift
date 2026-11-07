import CallKit

extension StreamVideoCallkitManager {

    //MARK: - CXProviderDelegate
    public func providerDidReset(_ provider: CXProvider) {
        store.reset()
        audio.callsRemoved(store)
    }

    public func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
        guard let (call, effects) = store.startPerformed(uuid: action.callUUID) else {
            NSLog("startCall: no call data for \(action.callUUID), failing the start action")
            action.fail()
            return
        }
        configureAudioSession(call.options)
        apply(effects)
        action.fulfill()
    }

    public func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        guard store.call(forCallKit: action.callUUID) != nil else {
            action.fail()
            return
        }
        self.configureAudioSession()
        // Applies the options again 1.2 s after answering.
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1200)) {
            self.configureAudioSession()
        }
        apply(store.answerPerformed(uuid: action.callUUID) ?? [])
        action.fulfill()
    }

    public func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        let outcome = store.endPerformed(uuid: action.callUUID)
        audio.callsRemoved(store)
        apply(outcome.effects)
        if outcome.fulfills {
            action.fulfill()
        } else {
            action.fail()
        }
    }

    public func provider(_ provider: CXProvider, perform action: CXSetHeldCallAction) {
        guard let effects = store.holdPerformed(uuid: action.callUUID, onHold: action.isOnHold)
        else {
            action.fail()
            return
        }
        apply(effects)
        action.fulfill()
    }

    public func provider(_ provider: CXProvider, perform action: CXSetMutedCallAction) {
        guard let effects = store.mutePerformed(uuid: action.callUUID, muted: action.isMuted) else {
            action.fail()
            return
        }
        apply(effects)
        action.fulfill()
    }

    public func provider(_ provider: CXProvider, perform action: CXSetGroupCallAction) {
        guard
            let effects = store.groupPerformed(
                uuid: action.callUUID, groupWith: action.callUUIDToGroupWith)
        else {
            action.fail()
            return
        }
        apply(effects)
        action.fulfill()
    }

    public func provider(_ provider: CXProvider, perform action: CXPlayDTMFCallAction) {
        guard
            let effects = store.dtmfPerformed(
                uuid: action.callUUID, digits: action.digits, type: action.type.rawValue)
        else {
            action.fail()
            return
        }
        apply(effects)
        action.fulfill()
    }

    public func provider(_ provider: CXProvider, timedOutPerforming action: CXAction) {
        // Looked up by the action's own uuid, which never names a call, so this always fails.
        guard store.call(forCallKit: action.uuid) != nil else {
            action.fail()
            return
        }
        sendEvent(StreamVideoIncomingCallConstants.ACTION_CALL_TIMEOUT, store.lastOptions?.toJSON())
        action.fulfill()
    }
}
