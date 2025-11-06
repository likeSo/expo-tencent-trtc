import ExpoModulesCore
import TXLiteAVSDK_TRTC

let notInitializedException = Exception(name: "ERR_NOT_INITIALIZED", description: "请先调用initTRTCCloud()方法初始化。")

public class ExpoTencentTRTCModule: Module, TRTCCloudDelegateWrapperDelegate {
    var trtcCloud: TRTCCloud?
    
    public func definition() -> ModuleDefinition {
        Name("ExpoTencentTRTC")
        
        OnDestroy {
            TRTCCloud.destroySharedInstance()
        }
        
        Events("onTRTCEvent")
        
        /// 初始化SDK
        AsyncFunction("initTRTCCloud") {
            self.trtcCloud = TRTCCloud.sharedInstance()
            let delegate = TRTCCloudDelegateWrapper()
            delegate.delegate = self
            
            self.trtcCloud?.addDelegate(delegate)
            
        }
        /// 进入房间，开始拉流
        AsyncFunction("enterRoom") { (options: EnterRoomParams) in
            if self.trtcCloud == nil {
                throw notInitializedException
            }
            let params = TRTCParams()
            params.sdkAppId = options.sdkAppId
            params.roomId = options.roomId ?? 0
            params.strRoomId = options.strRoomId ?? ""
            params.userId = options.userId
            params.userSig = options.userSig
            params.role = TRTCRoleType(rawValue: options.role.rawValue) ?? .audience
            
            self.trtcCloud?.enterRoom(params, appScene: TRTCAppScene(rawValue: options.scene.rawValue) ?? .voiceChatRoom)
        }
        
        AsyncFunction("switchRole") { (role: TRTCRole, privateMapKey: String?) in
            if self.trtcCloud == nil {
                throw notInitializedException
            }
            if let role = TRTCRoleType(rawValue: role.rawValue) {
                if privateMapKey != nil {
                    self.trtcCloud?.switch(role, privateMapKey: privateMapKey!)
                } else {
                    self.trtcCloud?.switch(role)
                }
            }
        }
        
        AsyncFunction("startLocalAudio") { (audioQuality: AudioQuality) in
            if self.trtcCloud == nil {
                throw notInitializedException
            }
            if let quality = TRTCAudioQuality(rawValue: audioQuality.rawValue) {
                self.trtcCloud?.startLocalAudio(quality)
            }
        }
        
        AsyncFunction("exitRoom") {
            if self.trtcCloud == nil {
                throw notInitializedException
            }
            self.trtcCloud?.exitRoom()
        }
        
        AsyncFunction("setAudioPlaybackVolume") { (volume: Int) in
            if self.trtcCloud == nil {
                throw notInitializedException
            }
            self.trtcCloud?.setAudioPlayoutVolume(volume)
        }
        
        AsyncFunction("muteLocalAudio") { (mute: Bool) in
            if self.trtcCloud == nil {
                throw notInitializedException
            }
            self.trtcCloud?.muteLocalAudio(mute)
        }
        
        AsyncFunction("switchRoom") { (options: SwitchRoomParams) in
            if self.trtcCloud == nil {
                throw notInitializedException
            }
            let config = TRTCSwitchRoomConfig()
            config.roomId = options.roomId ?? 0
            config.strRoomId = options.strRoomId ?? ""
            config.userSig = options.userSig
            config.privateMapKey = options.privateMapKey
            self.trtcCloud?.switchRoom(config)
        }
        
        AsyncFunction("muteRemoteAudio") { (userId: String, mute: Bool) in
            if self.trtcCloud == nil {
                throw notInitializedException
            }
            self.trtcCloud?.muteRemoteAudio(userId, mute: mute)
        }
        
        AsyncFunction("muteAllRemoteAudio") { (mute: Bool) in
            if self.trtcCloud == nil {
                throw notInitializedException
            }
            self.trtcCloud?.muteAllRemoteAudio(mute)
        }
        
        AsyncFunction("setRemoteAudioVolume") { (userId: String, volumn: Int32) in
            if self.trtcCloud == nil {
                throw notInitializedException
            }
            self.trtcCloud?.setRemoteAudioVolume(userId, volume: volumn)
        }
        
        
        AsyncFunction("enableAudioVolumeEvaluation") { (options: AudioVolumeEvaluationOptions) in
            if self.trtcCloud == nil {
                throw notInitializedException
            }
            let params = TRTCAudioVolumeEvaluateParams()
            params.interval = options.interval
            params.enableVadDetection = options.enableVadDetection
            params.enablePitchCalculation = options.enablePitchCalculation
            params.enableSpectrumCalculation = options.enableSpectrumCalculation
            self.trtcCloud?.enableAudioVolumeEvaluation(options.enable, with: params)
        }
        
        AsyncFunction("setConsoleLogEnabled") { (enabled: Bool) in
            if self.trtcCloud == nil {
                throw notInitializedException
            }
            TRTCCloud.setConsoleEnabled(enabled)
        }
        
        AsyncFunction("setConsoleLogLevel") { (level: Int) in
            if self.trtcCloud == nil {
                throw notInitializedException
            }
            if let level = TRTCLogLevel(rawValue: level) {
                TRTCCloud.setLogLevel(level)
            }
        }
        
        
        AsyncFunction("setVoiceReverbType") { (reverbType: ReverbType) in
            if self.trtcCloud == nil {
                throw notInitializedException
            }
            
            if let reverbType = TXVoiceReverbType(rawValue: reverbType.rawValue) {
                self.trtcCloud?.getAudioEffectManager().setVoiceReverbType(reverbType)
            }
        }
        
        AsyncFunction("setVoiceChangerType") { (changeType: VoiceChangerType) in
            if self.trtcCloud == nil {
                throw notInitializedException
            }
            
            if let changeType = TXVoiceChangeType(rawValue: changeType.rawValue) {
                self.trtcCloud?.getAudioEffectManager().setVoiceChangerType(changeType)
                
            }
        }
        
        AsyncFunction("switchCamera") { (useFrontCamera: Bool) in
            if self.trtcCloud == nil {
                throw notInitializedException
            }
            let deviceManager = trtcCloud?.getDeviceManager()
            deviceManager?.switchCamera(useFrontCamera)
        }
        
        View(ExpoTencentTRTCView.self) {
            
            AsyncFunction("startLocalPreview") { (view: ExpoTencentTRTCView, useFrontCamera: Bool) in
                self.trtcCloud?.startLocalPreview(useFrontCamera, view: view.contentView)
            }
            
            AsyncFunction("stopLocalPreview") { (view: ExpoTencentTRTCView) in
                self.trtcCloud?.stopLocalPreview()
            }
            
            AsyncFunction("startRemoteView") { (view: ExpoTencentTRTCView,
                                                userId: String,
                                                streamType: VideoStreamType) in
                self.trtcCloud?.startRemoteView(userId,
                                                streamType: TRTCVideoStreamType(rawValue: streamType.rawValue) ?? .small,
                                                view: view.contentView)
            }
            
            AsyncFunction("stopRemoteView") { (view: ExpoTencentTRTCView,
                                               userId: String,
                                               streamType: VideoStreamType) in
                self.trtcCloud?.stopRemoteView(userId,
                                               streamType: TRTCVideoStreamType(rawValue: streamType.rawValue) ?? .small)
            }
            
            AsyncFunction("updateRemoteView") { (view: ExpoTencentTRTCView,
                                                 userId: String,
                                                 streamType: VideoStreamType) in
                self.trtcCloud?.updateRemoteView(view.contentView,
                                                 streamType: TRTCVideoStreamType(rawValue: streamType.rawValue) ?? .small,
                                                 forUser: userId)
            }
            
        }
    }
    
    // Delegate
    func onError(_ errCode: TXLiteAVError, errMsg: String?, extInfo: [AnyHashable : Any]?) {
        sendEvent("onTRTCEvent", ["name": "onError",
                                  "code": errCode.rawValue,
                                  "message": errMsg,
                                  "extraInfo": extInfo])
    }
    
    func onEnterRoom(_ result: Int) {
        sendEvent("onTRTCEvent", ["name": "onEnterRoom", "result": result])
    }
    
    func onExitRoom(_ reason: Int) {
        sendEvent("onTRTCEvent", ["name": "onExitRoom", "reason": reason])
    }
    
    func onUserVoiceVolume(_ userVolumes: [TRTCVolumeInfo], totalVolume: Int) {
        let userVolumesMap: [[String: Any?]] = userVolumes.map { volumeInfo in
            return ["pitch": volumeInfo.pitch,
                    "spectrumData": volumeInfo.spectrumData,
                    "userId": volumeInfo.userId,
                    "vad": volumeInfo.vad,
                    "volume": volumeInfo.volume]
        }
        sendEvent("onTRTCEvent", ["name": "onUserVoiceVolume",
                                  "userVolumes": userVolumesMap,
                                  "totalVolume": totalVolume])
    }
    
    func onNetworkQuality(_ localQuality: TRTCQualityInfo, remoteQuality: [TRTCQualityInfo]) {
        let localQualityMap: [String: Any?] = ["userId": localQuality.userId, "quality": localQuality.quality.rawValue]
        let remoteQualityMap: [[String: Any?]] = remoteQuality.map{["userId": $0.userId, "quality": $0.quality.rawValue]}
        
        sendEvent("onTRTCEvent", ["name": "onNetworkQuality",
                                  "localQuality": localQualityMap,
                                  "remoteQuality": remoteQualityMap])
    }
}


@objc protocol TRTCCloudDelegateWrapperDelegate {
    func onError(_ errCode: TXLiteAVError, errMsg: String?, extInfo: [AnyHashable : Any]?)
    func onEnterRoom(_ result: Int)
    func onExitRoom(_ reason: Int)
    func onUserVoiceVolume(_ userVolumes: [TRTCVolumeInfo], totalVolume: Int)
    func onNetworkQuality(_ localQuality: TRTCQualityInfo, remoteQuality: [TRTCQualityInfo])
}

class TRTCCloudDelegateWrapper: NSObject, TRTCCloudDelegate {
    weak var delegate: TRTCCloudDelegateWrapperDelegate?
    
    func onError(_ errCode: TXLiteAVError, errMsg: String?, extInfo: [AnyHashable : Any]?) {
        delegate?.onError(errCode, errMsg: errMsg, extInfo: extInfo)
    }
    
    func onEnterRoom(_ result: Int) {
        delegate?.onEnterRoom(result)
    }
    
    func onExitRoom(_ reason: Int) {
        delegate?.onExitRoom(reason)
    }
    
    func onUserVoiceVolume(_ userVolumes: [TRTCVolumeInfo], totalVolume: Int) {
        delegate?.onUserVoiceVolume(userVolumes, totalVolume: totalVolume)
    }
    
    func onNetworkQuality(_ localQuality: TRTCQualityInfo, remoteQuality: [TRTCQualityInfo]) {
        delegate?.onNetworkQuality(localQuality, remoteQuality: remoteQuality)
    }
}
