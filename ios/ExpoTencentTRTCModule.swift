import ExpoModulesCore
import TXLiteAVSDK_Professional

public class ExpoTencentTRTCModule: Module, TRTCCloudDelegateWrapperDelegate {
    var trtcCloud: TRTCCloud?
    
  // Each module class must implement the definition function. The definition consists of components
  // that describes the module's functionality and behavior.
  // See https://docs.expo.dev/modules/module-api for more details about available components.
    public func definition() -> ModuleDefinition {
        // Sets the name of the module that JavaScript code will use to refer to the module. Takes a string as an argument.
        // Can be inferred from module's class name, but it's recommended to set it explicitly for clarity.
        // The module will be accessible from `requireNativeModule('ExpoTencentTRTC')` in JavaScript.
        Name("ExpoTencentTRTC")
        
        // Sets constant properties on the module. Can take a dictionary or a closure that returns a dictionary.
        Constants([:])
        
        OnCreate {
            
        }
        
        // Defines event names that the module can send to JavaScript.
        Events("onTRTCEvent")
        
        Function("initTRTCCloud") {
            
            trtcCloud = TRTCCloud.sharedInstance()
            
            let delegate = TRTCCloudDelegateWrapper()
            delegate.delegate = self
            
            trtcCloud?.addDelegate(delegate)
            
        }
        
        Function("enterRoom") { (sdkAppId: UInt32, 
                                 userId: String,
                                 roomId: UInt32?,
                                 strRoomId: String?,
                                 userSig: String,
                                 role: Int,
                                 scene: Int) in
            if trtcCloud == nil {
                return
            }
            let params = TRTCParams()
            params.sdkAppId = sdkAppId
            params.roomId = roomId ?? 0
            params.strRoomId = strRoomId ?? ""
            params.userId = userId
            params.userSig = userSig
            params.role = TRTCRoleType(rawValue: role) ?? .audience
            
            if let scene = TRTCAppScene(rawValue: scene) {
                trtcCloud?.enterRoom(params, appScene: scene)
            } else {
                #if DEBUG
                print("请输入正确的TRTCAppScene！")
                #endif
            }
        }
        
        Function("switchRole") { (role: Int, privateMapKey: String?) in
            if trtcCloud == nil {
                return
            }
            if let role = TRTCRoleType(rawValue: role) {
                if privateMapKey != nil {
                    trtcCloud?.switch(role, privateMapKey: privateMapKey!)
                } else {
                    trtcCloud?.switch(role)
                }
            }
        }
        
        Function("startLocalAudio") { (audioQuality: Int) in
            if trtcCloud == nil {
                return
            }
            if let quality = TRTCAudioQuality(rawValue: audioQuality) {
                trtcCloud?.startLocalAudio(quality)
            }
        }
        
        Function("exitRoom") {
            if trtcCloud == nil {
                return
            }
            trtcCloud?.exitRoom()
        }
        
        Function("setAudioPlaybackVolume") { (volume: Int) in
            if trtcCloud == nil {
                return
            }
            
            trtcCloud?.setAudioPlayoutVolume(volume)
        }
        
        Function("muteLocalAudio") { (mute: Bool) in
            if trtcCloud == nil {
                return
            }
            trtcCloud?.muteLocalAudio(mute)
        }
        
        Function("switchRoom") { (roomId: UInt32?, strRoomId: String?, userSig: String?, privateMapKey: String?) in
            if trtcCloud == nil {
                return
            }
            let config = TRTCSwitchRoomConfig()
            config.roomId = roomId ?? 0
            config.strRoomId = strRoomId
            config.privateMapKey = privateMapKey
            trtcCloud?.switchRoom(config)
            
        }
        
        Function("muteRemoteAudio") { (userId: String, mute: Bool) in
            if trtcCloud == nil {
                return
            }
            trtcCloud?.muteRemoteAudio(userId, mute: mute)
        }
        
        Function("muteAllRemoteAudio") { (mute: Bool) in
            if trtcCloud == nil {
                return
            }
            trtcCloud?.muteAllRemoteAudio(mute)
        }
        
        Function("setRemoteAudioVolume") { (userId: String, volumn: Int32) in
            if (trtcCloud == nil) {
                return
            }
            trtcCloud?.setRemoteAudioVolume(userId, volume: volumn)
        }
        
        
        Function("enableAudioVolumeEvaluation") { (enable: Bool, interval: UInt, enableVadDetection: Bool, enablePitchCalculation: Bool, enableSpectrumCalculation: Bool) in
            if (trtcCloud == nil) {
                return
            }
            let params = TRTCAudioVolumeEvaluateParams()
            params.interval = interval
            params.enableVadDetection = enableVadDetection
            params.enablePitchCalculation = enablePitchCalculation
            params.enableSpectrumCalculation = enableSpectrumCalculation
            trtcCloud?.enableAudioVolumeEvaluation(enable, with: params)
        }
        
        Function("setConsoleLogEnabled") { (enabled: Bool) in
            if (trtcCloud == nil) {
                return
            }
            TRTCCloud.setConsoleEnabled(enabled)
        }
        
        Function("setConsoleLogLevel") { (level: Int) in
            if (trtcCloud == nil) {
                return
            }
            if let level = TRTCLogLevel(rawValue: level) {
                TRTCCloud.setLogLevel(level)
            }
        }
        
        
        Function("setVoiceReverbType") { (reverbType: Int) in
            if (trtcCloud == nil) {
                return
            }
            
            if let reverbType = TXVoiceReverbType(rawValue: reverbType) {
                trtcCloud?.getAudioEffectManager().setVoiceReverbType(reverbType)
            }
        }
        
        Function("setVoiceChangerType") { (changeType: Int) in
            if (trtcCloud == nil) {
                return
            }
            
            if let changeType = TXVoiceChangeType(rawValue: changeType) {
                trtcCloud?.getAudioEffectManager().setVoiceChangerType(changeType)
            }
        }
        
        
        
        
        
        
        
        
        // Enables the module to be used as a native view. Definition components that are accepted as part of the
        // view definition: Prop, Events.
        View(ExpoTencentTRTCView.self) {
            // Defines a setter for the `url` prop.
            Prop("url") { (view: ExpoTencentTRTCView, url: URL) in
                if view.webView.url != url {
                    view.webView.load(URLRequest(url: url))
                }
            }
            
            Events("onLoad")
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
