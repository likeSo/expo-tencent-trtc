import { registerWebModule, NativeModule } from 'expo';
import { ExpoTencentTRTCModuleEvents, TRTCRole, TRTCAudioQuality, TRTCAppScene, TRTCLogLevel, TRTCReverbType, TRTCVoiceChangerType, SwitchRoomParams } from './ExpoTencentTRTC.types';
import TRTC, { UserRole, Scene, LOG_LEVEL, EnterRoomConfig } from 'trtc-sdk-v5'

class ExpoTencentTRTCModule extends NativeModule<ExpoTencentTRTCModuleEvents> {
  private trtcCloud?: TRTC
  /**
     * 初始化TRTC Cloud实例。初始化后才可以调用后续方法。
     */
  initTRTCCloud(): void {
    this.trtcCloud = TRTC.create()
  }
  /**
   * 进入房间。
   * @param sdkAppId 腾讯TRTC App ID。
   * @param userId 你的用户体系的用户ID。
   * @param roomId 房间ID。
   * @param strRoomId 字符串类型的房间ID，两个ID互斥，传一个就好。
   * @param userSig 鉴权票据，可以前端计算，也可以后端下发。本框架提供前端计算接口。
   * @param role 进入房间角色
   */
  enterRoom(config: EnterRoomConfig): void {
    if (this.trtcCloud) {
      this.trtcCloud.enterRoom(config)
    }
  }
  /**
   * 切换用户角色，主播或者观众。
   * @param role 新角色。
   * @param privateMapKey 用于权限控制的权限票据，当您希望某个房间只能让特定的 userId 进入或者上行视频时，需要使用 privateMapKey 进行权限保护。
   */
  switchRole(role: TRTCRole, privateMapKey: string | undefined): void {
    if (this.trtcCloud) {
      const roleEnum: UserRole = role === TRTCRole.anchor ? UserRole.ANCHOR : UserRole.AUDIENCE
      this.trtcCloud.switchRole(roleEnum, {privateMapKey})
    }
  }

  /**
   * 打开本地麦克风采集。腾讯官方文档推荐先开启摄像头和麦克风，再进入房间，因为需要给主播一个测试麦克风和调整美颜的时间。
   * @param audioQuality 音频采集模式。
   */
  startLocalAudio(audioQuality: TRTCAudioQuality): void {
    if (this.trtcCloud) {
      this.trtcCloud.startLocalAudio({})
    }
  }

  /**
   * 设置通话外放音量大小。该方法不影响远端音频流的采集，远端用户的音量依然可以获取到，只是本地声音不播放了。
   * @param volume 音量大小。
   */
  setAudioPlaybackVolume(volume: number): void {
    if (this.trtcCloud) {
      this.trtcCloud
    }
  }

  /**
   * 退出房间。
   */
  exitRoom(): void {
    if (this.trtcCloud) {
      this.trtcCloud.exitRoom()
    }
  }

  /**
   * 切换房间。该接口适用于在线教育场景中，监课老师在多个房间中进行快速切换的场景。在该场景下使用 switchRoom 可以获得比 exitRoom+enterRoom 更好的流畅性和更少的代码量。
   * @param options 切换房间参数。
   */
  switchRoom(options: SwitchRoomParams): void {
    if (this.trtcCloud) {
      // this.trtcCloud.
    }
  }

  /**
   * 闭麦或取消闭麦。
   * @param mute 静音或解除静音。
   */
  muteLocalAudio(mute: boolean): void {
    if (this.trtcCloud) {
      if (mute) {
        this.trtcCloud.stopLocalAudio()
      } else {
        this.trtcCloud.startLocalAudio()
      }
    }
  }
  /**
   * 对指定某个用户静音。当您静音某用户的远端音频时，SDK 会停止播放指定用户的声音，同时也会停止拉取该用户的音频数据。
   * @param userId 对方用户ID。
   * @param mute 静音与否。
   */
  muteRemoteAudio(userId: string, mute: boolean): void {
    if (this.trtcCloud) {
      this.trtcCloud.muteRemoteAudio(userId, mute)
    }
  }

  /**
   * 当您静音所有用户的远端音频时，SDK 会停止播放所有来自远端的音频流，同时也会停止拉取所有用户的音频数据。
   * @param mute 静音与否。
   */
  muteAllRemoteAudio(mute: boolean): void {
    if (this.trtcCloud) {
      this.trtcCloud.muteRemoteAudio("*", mute)
    }
  }

  /**
   * 设置某个指定用户的声音播放音量。注意，是指定某个用户在本机上的播放音量，而不是是对方用户禁言。
   * @param userId 指定用户ID。
   * @param volume 指定音量。
   */
  setRemoteAudioVolume(userId: string, volume: number): void {
    if (this.trtcCloud) {
      this.trtcCloud.setRemoteAudioVolume(userId, volume)
    }
  }
  /**
   * 禁用或开启控制台日志打印。
   */
  setConsoleLogEnabled(enabled: boolean): void {
    if (this.trtcCloud) {
      this.trtcCloud
    }
  }

  /**
   * 控制台打印日志级别。
   * @param level 日志级别。
   */
  setConsoleLogLevel(level: number): void {
    if (this.trtcCloud) {
      TRTC.setLogLevel(level)
    }
  }

  /**
   * 设置人声的混响效果。
   * @param reverbType 混响类型
   */
  setVoiceReverbType(reverbType: TRTCReverbType): void {
  // TODO: 暂不支持
  }

  /**
   * 设置变声特效。
   * @param changeType 变声类型
   */
  setVoiceChangerType(changeType: TRTCVoiceChangerType): void {
    // TODO: 暂不支持
  }
}

export default registerWebModule(ExpoTencentTRTCModule, 'ExpoTencentTRTCModule');
