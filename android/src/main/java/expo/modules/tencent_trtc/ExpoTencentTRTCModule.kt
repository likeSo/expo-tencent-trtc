package expo.modules.tencent_trtc

import android.os.Bundle
import androidx.core.os.bundleOf
import com.tencent.liteav.audio.TXAudioEffectManager
import com.tencent.trtc.TRTCCloud
import com.tencent.trtc.TRTCCloudDef
import com.tencent.trtc.TRTCCloudListener
import expo.modules.kotlin.exception.CodedException
import expo.modules.kotlin.modules.Module
import expo.modules.kotlin.modules.ModuleDefinition
import java.net.URL
import java.util.ArrayList

val notInitializedException =
    CodedException("ERR_NOT_INITIALIZED", "请先调用initTRTCCloud()方法初始化。", null)

class ExpoTencentTRTCModule : Module() {
    var trtcCloud: TRTCCloud? = null

    override fun definition() = ModuleDefinition {
        Name("ExpoTencentTRTC")

        Events("onTRTCEvent")

        OnDestroy {
            TRTCCloud.destroySharedInstance()
        }

        Function("initTRTCCloud") {
            trtcCloud = TRTCCloud.sharedInstance(appContext.reactContext)
            trtcCloud?.addListener(object : TRTCCloudListener() {
                override fun onError(errCode: Int, errMsg: String?, extraInfo: Bundle?) {
                    sendEvent(
                        "onTRTCEvent",
                        bundleOf(
                            "name" to "onError",
                            "code" to errCode,
                            "message" to errMsg,
                            "extraInfo" to extraInfo
                        )
                    )
                }

                override fun onEnterRoom(result: Long) {
                    sendEvent("onTRTCEvent", bundleOf("name" to "onEnterRoom", "result" to result))
                }

                override fun onExitRoom(reason: Int) {
                    sendEvent("onTRTCEvent", bundleOf("name" to "onExitRoom", "reason" to reason))
                }

                override fun onUserVoiceVolume(
                    userVolumes: ArrayList<TRTCCloudDef.TRTCVolumeInfo>?,
                    totalVolume: Int
                ) {
                    val userVolumesData = userVolumes?.map {
                        return@map bundleOf(
                            "pitch" to it.pitch,
                            "spectrumData" to it.spectrumData,
                            "userId" to it.userId,
                            "vad" to it.vad,
                            "volume" to it.volume
                        )
                    }
                    sendEvent(
                        "onTRTCEvent",
                        bundleOf(
                            "name" to "onUserVoiceVolume",
                            "userVolumes" to userVolumesData,
                            "totalVolume" to totalVolume
                        )
                    )
                }

                override fun onNetworkQuality(
                    localQuality: TRTCCloudDef.TRTCQuality?,
                    remoteQuality: ArrayList<TRTCCloudDef.TRTCQuality>?
                ) {
                    val localQualityBundle: Bundle? =
                        if (localQuality != null) bundleOf(
                            "userId" to localQuality.userId,
                            "quality" to localQuality.quality
                        ) else null;
                    val remoteQualityBundle: List<Bundle>? =
                        remoteQuality?.map {
                            bundleOf(
                                "userId" to it.userId,
                                "quality" to it.quality
                            )
                        };
                    sendEvent(
                        "onTRTCEvent",
                        bundleOf(
                            "name" to "onNetworkQuality",
                            "localQuality" to bundleOf(
                                "userId" to localQuality?.userId,
                                "localQuality" to localQualityBundle,
                                "remoteQuality" to remoteQualityBundle
                            )
                        )
                    )
                }
            })
        }

        AsyncFunction("enterRoom") { options: EnterRoomParams ->
            if (trtcCloud == null) {
                throw notInitializedException
            }
            val enterRoomParams = TRTCCloudDef.TRTCParams()
            enterRoomParams.sdkAppId = options.sdkAppId
            enterRoomParams.userId = options.userId
            enterRoomParams.roomId = options.roomId ?: 0
            enterRoomParams.strRoomId = options.strRoomId ?: ""
            enterRoomParams.role = options.role.value
            trtcCloud?.enterRoom(enterRoomParams, options.scene.value)
        }

        AsyncFunction("switchRole") { role: Int, privateMapKey: String? ->
            if (trtcCloud == null) {
                throw notInitializedException
            }
            if (privateMapKey != null) {
                trtcCloud?.switchRole(role, privateMapKey)
            } else {
                trtcCloud?.switchRole(role)
            }
        }

        AsyncFunction("startLocalAudio") { audioQuality: Int ->
            if (trtcCloud == null) {
                throw notInitializedException
            }
            trtcCloud?.startLocalAudio(audioQuality)
        }

        AsyncFunction("setAudioPlaybackVolume") { volume: Int ->
            if (trtcCloud == null) {
                throw notInitializedException
            }
            trtcCloud?.audioPlayoutVolume = volume
        }

        AsyncFunction("exitRoom") {
            if (trtcCloud == null) {
                throw notInitializedException
            } else {
                trtcCloud?.exitRoom();
            }
        }

        AsyncFunction("muteLocalAudio") { mute: Boolean ->
            if (trtcCloud == null) {
                throw notInitializedException
            }

            trtcCloud?.muteLocalAudio(mute)
        }

        AsyncFunction("switchRoom") { options: SwitchRoomParams ->
            if (trtcCloud == null) {
                throw notInitializedException
            }
            val config = TRTCCloudDef.TRTCSwitchRoomConfig()
            config.roomId = options.roomId ?: 0
            config.strRoomId = options.strRoomId ?: ""
            config.privateMapKey = options.privateMapKey
            config.userSig = options.userSig
            trtcCloud?.switchRoom(config)
        }

        AsyncFunction("muteRemoteAudio") { userId: String, mute: Boolean ->
            if (trtcCloud == null) {
                throw notInitializedException
            }
            trtcCloud?.muteRemoteAudio(userId, mute)
        }

        AsyncFunction("muteAllRemoteAudio") { mute: Boolean ->
            if (trtcCloud == null) {
                throw notInitializedException
            }
            trtcCloud?.muteAllRemoteAudio(mute)
        }

        AsyncFunction("setRemoteAudioVolume") { userId: String, volumn: Int ->
            if (trtcCloud == null) {
                throw notInitializedException
            }
            trtcCloud?.setRemoteAudioVolume(userId, volumn)
        }

        AsyncFunction("enableAudioVolumeEvaluation") { options: AudioVolumeEvaluationOptions ->
            if (trtcCloud == null) {
                throw notInitializedException
            }
            val params = TRTCCloudDef.TRTCAudioVolumeEvaluateParams()
            params.interval = options.interval
            params.enableVadDetection = options.enableVadDetection
            params.enablePitchCalculation = options.enablePitchCalculation
            params.enableSpectrumCalculation = options.enableSpectrumCalculation
            trtcCloud?.enableAudioVolumeEvaluation(options.enable, params)

        }

        AsyncFunction("setConsoleLogEnabled") { enable: Boolean ->
            if (trtcCloud == null) {
                throw notInitializedException
            }

            TRTCCloud.setConsoleEnabled(enable)
        }

        AsyncFunction("setConsoleLogLevel") { level: Int ->
            if (trtcCloud == null) {
                throw notInitializedException
            }

            TRTCCloud.setLogLevel(level)
        }

        AsyncFunction("setVoiceReverbType") { reverbType: Int ->
            if (trtcCloud == null) {
                throw notInitializedException
            }
            val allValues = TXAudioEffectManager.TXVoiceReverbType.entries.toTypedArray();
            val enumValue = allValues.find { it.nativeValue == reverbType }
            if (enumValue != null) {
                trtcCloud?.audioEffectManager?.setVoiceReverbType(enumValue)
            }
        }

        AsyncFunction("setVoiceChangerType") { changeType: Int ->
            if (trtcCloud == null) {
                throw notInitializedException
            }
            val allValues = TXAudioEffectManager.TXVoiceChangerType.entries.toTypedArray();
            val enumValue = allValues.find { it.nativeValue == changeType }
            if (enumValue != null) {
                trtcCloud?.audioEffectManager?.setVoiceChangerType(enumValue)
            }
        }

        AsyncFunction("switchCamera") { useFrontCamera: Boolean ->
            if (trtcCloud == null) {
                throw notInitializedException
            }
            val deviceManager = trtcCloud?.deviceManager
            deviceManager?.switchCamera(useFrontCamera)
        }


        View(ExpoTencentTRTCView::class) {

            AsyncFunction("startLocalPreview") { view: ExpoTencentTRTCView, useFrontCamera: Boolean ->
                trtcCloud?.startLocalPreview(useFrontCamera, view.contentView)
            }

            AsyncFunction("stopLocalPreview") { view: ExpoTencentTRTCView ->
                trtcCloud?.stopLocalPreview()
            }

            AsyncFunction("startRemoteView") { view: ExpoTencentTRTCView,
                                               userId: String,
                                               streamType: VideoStreamType ->
                trtcCloud?.startRemoteView(
                    userId,
                    streamType.value,
                    view.contentView
                )
            }

            AsyncFunction("stopRemoteView") { view: ExpoTencentTRTCView,
                                              userId: String,
                                              streamType: VideoStreamType ->
                trtcCloud?.stopRemoteView(
                    userId,
                    streamType.value
                )
            }

            AsyncFunction("updateRemoteView") { view: ExpoTencentTRTCView,
                                                userId: String,
                                                streamType: VideoStreamType ->
                trtcCloud?.updateRemoteView(
                    userId,
                    streamType.value,
                    view.contentView
                )
            }

        }
    }
}
