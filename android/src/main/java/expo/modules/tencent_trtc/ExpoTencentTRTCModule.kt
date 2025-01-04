package expo.modules.tencent_trtc

import android.os.Bundle
import androidx.core.os.bundleOf
import com.tencent.liteav.audio.TXAudioEffectManager
import com.tencent.trtc.TRTCCloud
import com.tencent.trtc.TRTCCloudDef
import com.tencent.trtc.TRTCCloudListener
import expo.modules.kotlin.modules.Module
import expo.modules.kotlin.modules.ModuleDefinition
import java.net.URL
import java.util.ArrayList

class ExpoTencentTRTCModule : Module() {
    var trtcCloud: TRTCCloud? = null

    // Each module class must implement the definition function. The definition consists of components
    // that describes the module's functionality and behavior.
    // See https://docs.expo.dev/modules/module-api for more details about available components.
    override fun definition() = ModuleDefinition {
        // Sets the name of the module that JavaScript code will use to refer to the module. Takes a string as an argument.
        // Can be inferred from module's class name, but it's recommended to set it explicitly for clarity.
        // The module will be accessible from `requireNativeModule('ExpoTencentTRTC')` in JavaScript.
        Name("ExpoTencentTRTC")

        // Sets constant properties on the module. Can take a dictionary or a closure that returns a dictionary.
        Constants()

        // Defines event names that the module can send to JavaScript.
        Events("onTRTCEvent")

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

        Function("enterRoom") { sdkAppId: Int, userId: String, roomId: Int?, strRoomId: String?, userSig: String, role: Int, scene: Int ->
            if (trtcCloud == null) {
                return@Function
            }
            val enterRoomParams = TRTCCloudDef.TRTCParams()
            enterRoomParams.sdkAppId = sdkAppId
            enterRoomParams.userId = userId
            enterRoomParams.roomId = roomId ?: 0
            enterRoomParams.strRoomId = strRoomId ?: ""
            enterRoomParams.role = role
            trtcCloud?.enterRoom(enterRoomParams, scene)
        }

        Function("switchRole") { role: Int, privateMapKey: String? ->
            if (trtcCloud == null) {
                return@Function
            }
            if (privateMapKey != null) {
                trtcCloud?.switchRole(role, privateMapKey)
            } else {
                trtcCloud?.switchRole(role)
            }
        }

        Function("startLocalAudio") { audioQuality: Int ->
            if (trtcCloud == null) {
                return@Function
            }
            trtcCloud?.startLocalAudio(audioQuality)
        }

        Function("setAudioPlaybackVolume") { volume: Int ->
            if (trtcCloud == null) {
                return@Function
            }
            trtcCloud?.audioPlayoutVolume = volume
        }

        Function("exitRoom") {
            if (trtcCloud == null) {
                return@Function null
            } else {
                trtcCloud?.exitRoom();
            }
        }

        Function("muteLocalAudio") { mute: Boolean ->
            if (trtcCloud == null) {
                return@Function
            }

            trtcCloud?.muteLocalAudio(mute)
        }

        Function("switchRoom") { roomId: Int?, strRoomId: String?, userSig: String?, privateMapKey: String? ->
            if (trtcCloud == null) {
                return@Function
            }
            val config = TRTCCloudDef.TRTCSwitchRoomConfig()
            config.roomId = roomId ?: 0
            config.strRoomId = strRoomId ?: ""
            config.privateMapKey = privateMapKey
            config.userSig = userSig
            trtcCloud?.switchRoom(config)
        }

        Function("muteRemoteAudio") { userId: String, mute: Boolean ->
            if (trtcCloud == null) {
                return@Function
            }
            trtcCloud?.muteRemoteAudio(userId, mute)
        }

        Function("muteAllRemoteAudio") { mute: Boolean ->
            if (trtcCloud == null) {
                return@Function
            }
            trtcCloud?.muteAllRemoteAudio(mute)
        }

        Function("setRemoteAudioVolume") { userId: String, volumn: Int ->
            if (trtcCloud == null) {
                return@Function
            }
            trtcCloud?.setRemoteAudioVolume(userId, volumn)
        }

        Function("enableAudioVolumeEvaluation") { enable: Boolean, interval: Int, enableVadDetection: Boolean, enablePitchCalculation: Boolean, enableSpectrumCalculation: Boolean ->
            if (trtcCloud == null) {
                return@Function
            }
            val params = TRTCCloudDef.TRTCAudioVolumeEvaluateParams()
            params.interval = interval
            params.enableVadDetection = enableVadDetection
            params.enablePitchCalculation = enablePitchCalculation
            params.enableSpectrumCalculation = enableSpectrumCalculation
            trtcCloud?.enableAudioVolumeEvaluation(enable, params)

        }

        Function("setConsoleLogEnabled") { enable: Boolean ->
            if (trtcCloud == null) {
                return@Function
            }

            TRTCCloud.setConsoleEnabled(enable)
        }

        Function("setConsoleLogLevel") { level: Int ->
            if (trtcCloud == null) {
                return@Function
            }

            TRTCCloud.setLogLevel(level)
        }

        Function("setVoiceReverbType") { reverbType: Int ->
            if (trtcCloud == null) {
                return@Function
            }
            val allValues = TXAudioEffectManager.TXVoiceReverbType.entries.toTypedArray();
            val enumValue = allValues.find { it.nativeValue == reverbType }
            if (enumValue != null) {
                trtcCloud?.audioEffectManager?.setVoiceReverbType(enumValue)
            }
        }

        Function("setVoiceChangerType") { changeType: Int ->
            if (trtcCloud == null) {
                return@Function
            }
            val allValues = TXAudioEffectManager.TXVoiceChangerType.entries.toTypedArray();
            val enumValue = allValues.find { it.nativeValue == changeType }
            if (enumValue != null) {
                trtcCloud?.audioEffectManager?.setVoiceChangerType(enumValue)
            }
        }


        // Enables the module to be used as a native view. Definition components that are accepted as part of
        // the view definition: Prop, Events.
        View(ExpoTencentTRTCView::class) {
            // Defines a setter for the `url` prop.
            Prop("url") { view: ExpoTencentTRTCView, url: URL ->
                view.webView.loadUrl(url.toString())
            }
            // Defines an event that the view can send to JavaScript.
            Events("onLoad")
        }
    }
}
