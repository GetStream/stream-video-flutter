import CallKit

extension StreamVideoCallkitManager {

    //MARK: - CXProviderDelegate
    func providerDidReset(_ provider: CXProvider) {
        store.reset()
        callsRemoved()
        restoreRecentsIfNoCallLeft()
    }

    func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
        if let call = store.reRegistrationPerformed(uuid: action.callUUID) {
            action.fulfill()
            reRegistrationStarted(call)
            return
        }
        if store.isReRegistrationUUID(action.callUUID) {
            // The call ended while CallKit was starting it again.
            action.fail()
            return
        }
        guard let (call, effects) = store.startPerformed(uuid: action.callUUID) else {
            NSLog("startCall: no call data for \(action.callUUID), failing the start action")
            action.fail()
            return
        }
        configureAudioSession(call.options)
        apply(effects)
        action.fulfill()
    }

    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
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

    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        // Before the end reaches Dart: once CallKit has no call left, iOS can suspend the app
        // before Dart tells the backend.
        callEndGracePeriod.callEnded()
        suppressRecentsIfRegisteredAgain(store.call(forCallKit: action.callUUID))
        let outcome = store.endPerformed(uuid: action.callUUID)
        callsRemoved()
        apply(outcome.effects)
        if outcome.fulfills {
            action.fulfill()
        } else {
            action.fail()
        }
    }

    func provider(_ provider: CXProvider, perform action: CXSetHeldCallAction) {
        let previousPhase = store.call(forCallKit: action.callUUID)?.phase
        let origin = action.isOnHold ? holdRecovery.holdOrigin(for: action.callUUID) : .requested
        guard
            let effects = store.holdPerformed(
                uuid: action.callUUID, onHold: action.isOnHold, origin: origin)
        else {
            action.fail()
            return
        }
        apply(effects)
        action.fulfill()
        if case .held(let heldFor) = previousPhase, let call = store.call(forCallKit: action.callUUID),
            call.phase == .resumed(activated: false)
        {
            holdRecovery.callResumed(call, heldFor: heldFor)
        }
    }

    func provider(_ provider: CXProvider, perform action: CXSetMutedCallAction) {
        guard let effects = store.mutePerformed(uuid: action.callUUID, muted: action.isMuted) else {
            action.fail()
            return
        }
        apply(effects)
        action.fulfill()
    }

    /// Refused: calls are never offered for merging, and a merged CallKit call would not be one
    /// Stream call.
    func provider(_ provider: CXProvider, perform action: CXSetGroupCallAction) {
        action.fail()
    }

    func provider(_ provider: CXProvider, perform action: CXPlayDTMFCallAction) {
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

    func provider(_ provider: CXProvider, timedOutPerforming action: CXAction) {
        // Looked up by the action's own uuid, which never names a call, so this always fails.
        guard store.call(forCallKit: action.uuid) != nil else {
            action.fail()
            return
        }
        sendEvent(StreamVideoIncomingCallConstants.ACTION_CALL_TIMEOUT, store.lastOptions?.toJSON())
        action.fulfill()
    }
}
