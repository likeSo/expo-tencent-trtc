//
//  ExpoTencentTRTCModule.types.swift
//  ExpoTencentTRTC
//
//  Created by Aron on 2025/11/5.
//

import ExpoModulesCore

/// 房间内用户角色类型
enum TRTCRole: Int, Enumerable {
    /// 主播，有发言权和一定的房间内权限
    case anchor = 20
    /// 观众。没有发言权
    case audience
}

/// App类型，视频聊天，或者语音直播
enum AppScene: Int, Enumerable {
    case videoCall = 0
    case live
    case audioCall
    case voiceChatRoom
}

/// TRTC音频流采集模式。
enum AudioQuality: Int, Enumerable {
    case speech = 1
    case `default`
    case music
}

/// 进入房间所需的各种参数
struct EnterRoomParams: Record {
    @Field
    var sdkAppId: UInt32 = 0
    @Field
    var userId: String = ""
    @Field
    var roomId: UInt32?
    @Field
    var strRoomId: String?
    @Field
    var userSig: String = ""
    @Field
    var role: TRTCRole = .audience
    @Field
    var scene: AppScene = .voiceChatRoom
}

/// 切换到其他房间所需参数
struct SwitchRoomParams: Record {
    @Field
    var roomId: UInt32?
    @Field
    var strRoomId: String?
    @Field
    var userSig: String?
    @Field
    var privateMapKey: String?
}

/// 实时音频评估
struct AudioVolumeEvaluationOptions: Record {
    @Field
    var enable: Bool = true
    @Field
    var interval: UInt = 1
    @Field
    var enableVadDetection: Bool = false
    @Field
    var enablePitchCalculation: Bool = false
    @Field
    var enableSpectrumCalculation: Bool = false
}


/// 人声混响特效
enum ReverbType: Int, Enumerable {
    case noEffect = 0
    case ktv
    case smallRoom
    case hall
    case low
    case high
    case metal
    case magnetic
    case ethereal
    case recordingStudio
    case melodious
    case recordingStudio2
}

/// TRTCVoiceChangerType 枚举用于表示不同的声音变换类型。
enum VoiceChangerType: Int, Enumerable {
    case noEffect = 0
    case badKid = 1
    case loli = 2
    case uncle = 3
    case metal = 4
    case cold = 5
    case foreignAccent = 6
    case trappedBeast = 7
    case chubby = 8
    case strongElectricity = 9
    case heavyMachine = 10
    case ethereal = 11
    case pigKing = 12
    case hulk = 13
}


enum VideoStreamType: Int, Enumerable {
    case big = 0
    case small
    case sub
}
