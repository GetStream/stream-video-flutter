import CallKit

extension StreamVideoCallkitManager {

    //MARK: - CXProviderDelegate
    public func providerDidReset(_ provider: CXProvider) {
        for call in self.callController.calls {
            call.endCall()
        }
        self.callController.removeAllCalls()
    }

    public func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
        guard
            let data = self.callController.takePendingOutgoingCall(uuid: action.callUUID)
                ?? self.data
        else {
            NSLog("startCall: no call data for \(action.callUUID), failing the start action")
            action.fail()
            return
        }
        let call = Call(uuid: action.callUUID, data: data, isOutGoing: true)
        call.handle = action.handle.value
        configureAudioSession(data)
        call.hasStartedConnectDidChange = { [weak self] in
            self?.sharedProvider?.reportOutgoingCall(
                with: call.uuid, startedConnectingAt: call.connectData)
        }
        call.hasConnectDidChange = { [weak self] in
            self?.sharedProvider?.reportOutgoingCall(
                with: call.uuid, connectedAt: call.connectedData)
        }
        self.outgoingCall = call
        self.callController.addCall(call)
        self.sendEvent(StreamVideoIncomingCallConstants.ACTION_CALL_START, data.toJSON())
        action.fulfill()
    }

    public func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        guard let call = self.callController.callWithUUID(uuid: action.callUUID) else {
            action.fail()
            return
        }
        self.configureAudioSession()
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1200)) {
            self.configureAudioSession()
        }

        call.hasConnectDidChange = { [weak self] in
            self?.sharedProvider?.reportOutgoingCall(
                with: call.uuid, connectedAt: call.connectedData)
        }
        self.data?.isAccepted = true
        self.answerCall = call
        sendEvent(StreamVideoIncomingCallConstants.ACTION_CALL_ACCEPT, self.data?.toJSON())
        action.fulfill()
    }

    public func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        guard let call = self.callController.callWithUUID(uuid: action.callUUID) else {
            if self.answerCall == nil && self.outgoingCall == nil {
                sendEvent(
                    StreamVideoIncomingCallConstants.ACTION_CALL_TIMEOUT, self.data?.toJSON())
            } else {
                sendEvent(StreamVideoIncomingCallConstants.ACTION_CALL_ENDED, self.data?.toJSON())
            }
            action.fail()
            return
        }
        call.endCall()
        self.callController.removeCall(call)
        if self.answerCall == nil && self.outgoingCall == nil {
            sendEvent(StreamVideoIncomingCallConstants.ACTION_CALL_DECLINE, self.data?.toJSON())
            action.fulfill()
        } else {
            self.answerCall = nil
            sendEvent(StreamVideoIncomingCallConstants.ACTION_CALL_ENDED, call.data.toJSON())
            action.fulfill()
        }
    }

    public func provider(_ provider: CXProvider, perform action: CXSetHeldCallAction) {
        guard let call = self.callController.callWithUUID(uuid: action.callUUID) else {
            action.fail()
            return
        }
        call.isOnHold = action.isOnHold
        call.isMuted = action.isOnHold
        sendHoldEvent(self.callController.reportedId(for: action.callUUID), action.isOnHold)
        action.fulfill()
    }

    public func provider(_ provider: CXProvider, perform action: CXSetMutedCallAction) {
        guard let call = self.callController.callWithUUID(uuid: action.callUUID) else {
            action.fail()
            return
        }
        call.isMuted = action.isMuted
        sendMuteEvent(self.callController.reportedId(for: action.callUUID), action.isMuted)
        action.fulfill()
    }

    public func provider(_ provider: CXProvider, perform action: CXSetGroupCallAction) {
        guard (self.callController.callWithUUID(uuid: action.callUUID)) != nil else {
            action.fail()
            return
        }
        self.sendEvent(
            StreamVideoIncomingCallConstants.ACTION_CALL_TOGGLE_GROUP,
            [
                "id": self.callController.reportedId(for: action.callUUID),
                "callUUIDToGroupWith": action.callUUIDToGroupWith.map {
                    self.callController.reportedId(for: $0)
                },
            ])
        action.fulfill()
    }

    public func provider(_ provider: CXProvider, perform action: CXPlayDTMFCallAction) {
        guard (self.callController.callWithUUID(uuid: action.callUUID)) != nil else {
            action.fail()
            return
        }
        self.sendEvent(
            StreamVideoIncomingCallConstants.ACTION_CALL_TOGGLE_DTMF,
            [
                "id": self.callController.reportedId(for: action.callUUID),
                "digits": action.digits,
                "type": action.type.rawValue,
            ])
        action.fulfill()
    }

    public func provider(_ provider: CXProvider, timedOutPerforming action: CXAction) {
        guard let call = self.callController.callWithUUID(uuid: action.uuid) else {
            action.fail()
            return
        }
        sendEvent(StreamVideoIncomingCallConstants.ACTION_CALL_TIMEOUT, self.data?.toJSON())
        action.fulfill()
    }
}
