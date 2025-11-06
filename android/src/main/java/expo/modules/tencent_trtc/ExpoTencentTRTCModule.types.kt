package expo.modules.tencent_trtc

import expo.modules.kotlin.records.Field
import expo.modules.kotlin.records.Record
import expo.modules.kotlin.types.Enumerable

/// 房间内用户角色类型
enum class TRTCRole(val value: Int): Enumerable {
    anchor(20),
    audience(21)
}

/// App类型，视频聊天，或者语音直播
enum class AppScene(val value: Int): Enumerable {
    videoCall(0),
    live(1),
    audioCall(2),
    voiceChatRoom(3)
}

/// TRTC音频流采集模式。
enum class AudioQuality(val value: Int): Enumerable {
    speech(1),
    default(2),
    music(3)
}

/// 进入房间所需的各种参数
class EnterRoomParams: Record {
    @Field
    var sdkAppId: Int = 0
    @Field
    var userId: String = ""
    @Field
    var roomId: Int? = null
    @Field
    var strRoomId: String? = null
    @Field
    var userSig: String = ""
    @Field
    var role: TRTCRole = TRTCRole.audience
    @Field
    var scene: AppScene = AppScene.voiceChatRoom
}


/// 切换到其他房间所需参数
class SwitchRoomParams: Record {
    @Field
    var roomId: Int? = null
    @Field
    var strRoomId: String? = null
    @Field
    var userSig: String? = null
    @Field
    var privateMapKey: String? = null
}


/// 实时音频评估
class AudioVolumeEvaluationOptions: Record {
    @Field
    var enable: Boolean = true
    @Field
    var interval: Int = 1
    @Field
    var enableVadDetection: Boolean = false
    @Field
    var enablePitchCalculation: Boolean = false
    @Field
    var enableSpectrumCalculation: Boolean = false
}

/// 人声混响特效
enum class ReverbType(val value: Int) : Enumerable {
    noEffect(0),
    ktv(1),
    smallRoom(2),
    hall(3),
    low(4),
    high(5),
    metal(6),
    magnetic(7),
    ethereal(8),
    recordingStudio(9),
    melodious(10),
    recordingStudio2(11);
}

/// 声音变换类型
enum class VoiceChangerType(val value: Int) : Enumerable {
    noEffect(0),
    badKid(1),
    loli(2),
    uncle(3),
    metal(4),
    cold(5),
    foreignAccent(6),
    trappedBeast(7),
    chubby(8),
    strongElectricity(9),
    heavyMachine(10),
    ethereal(11),
    pigKing(12),
    hulk(13);
}

enum class VideoStreamType(val value: Int): Enumerable {
    big(0),
    small(1),
    sub(2)
}