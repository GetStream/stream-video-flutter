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
        guard let call = store.call(forCallKit: action.callUUID) else {
            action.fail()
            return
        }
        configureAudioSession(call.options)
        // Applies the call's options again shortly after answering, unless by then it has ended
        // or another call was answered.
        DispatchQueue.main.asyncAfter(deadline: .now() + reconfigureAfterAnswerDelay) {
            [weak self] in
            guard let self = self, self.store.answeredCall === call, !call.phase.isEnded else {
                return
            }
            self.configureAudioSession(call.options)
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
