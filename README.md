## 关于项目
本项目是腾讯TRTC服务的RN版本。纯用爱发电，并没有实现所有腾讯TRTC的功能，目前基本可以使用本框架完成语音厅服务。本框架不包含语音厅UI部分，UI需要自己实现。

## 安装
`npx expo install expo-tencent-trtc`

## 配置

### 权限配置
RTC服务需要一堆权限，比如麦克风和相机权限，安装的权限部分本插件已经自动帮你配置好了，iOS的权限部分，需要你自己在`app.json`中配置。
安卓所需权限参考（已配置）：https://cloud.tencent.com/document/product/647/32175
iOS所需权限参考：https://cloud.tencent.com/document/product/647/32173

### 混淆规则
在安卓上需要添加TRTC所需的混淆规则，以免打包时出现错误。
利用`expo-build-properties`来添加TRTC所需的额外混淆规则。具体参见[`extraProguardRules`](https://docs.expo.dev/versions/latest/sdk/build-properties/)和[TRTC所需的混淆规则](https://cloud.tencent.com/document/product/647/32175)

## 使用

```ts
import { ExpoTencentTRTC } from 'expo-tencent-trtc'

/// 初始化TRTC Cloud实例。初始化后才可以调用后续方法。推荐在用户接受隐私协议后调用。
ExpoTencentTRTC.initTRTCCloud()
```

## API
```ts
  /**
   * 初始化TRTC Cloud实例。初始化后才可以调用后续方法。
   */
  initTRTCCloud(): void;
  /**
   * 进入房间。
   * @param sdkAppId 腾讯TRTC App ID。
   * @param userId 你的用户体系的用户ID。
   * @param roomId 房间ID。
   * @param strRoomId 字符串类型的房间ID，两个ID互斥，传一个就好。
   * @param userSig 鉴权票据，可以前端计算，也可以后端下发。本框架提供前端计算接口。
   * @param role 进入房间角色。
   * @param scene 使用场景，语音厅或者视频通话，详见枚举值。
   */
  enterRoom(sdkAppId: number, userId: string, roomId: number | undefined, strRoomId: string | undefined, userSig: string, role: TRTCRole, scene: TRTCAppScene):void;
  /**
   * 切换用户角色，主播或者观众。
   * @param role 新角色。
   * @param privateMapKey 用于权限控制的权限票据，当您希望某个房间只能让特定的 userId 进入或者上行视频时，需要使用 privateMapKey 进行权限保护。
   */
  switchRole(role: TRTCRole, privateMapKey: string | undefined): void;

  /**
   * 打开本地麦克风采集。腾讯官方文档推荐先开启摄像头和麦克风，再进入房间，因为需要给主播一个测试麦克风和调整美颜的时间。
   * @param audioQuality 音频采集模式。
   */
  startLocalAudio(audioQuality: TRTCAudioQuality): void;

  /**
   * 设置通话外放音量大小。该方法不影响远端音频流的采集，远端用户的音量依然可以获取到，只是本地声音不播放了。
   * @param volume 音量大小。
   */
  setAudioPlaybackVolume(volume: number): void;

  /**
   * 退出房间。
   */
  exitRoom(): void;

  /**
   * 切换房间。该接口适用于在线教育场景中，监课老师在多个房间中进行快速切换的场景。在该场景下使用 switchRoom 可以获得比 exitRoom+enterRoom 更好的流畅性和更少的代码量。
   * @param roomId 房间ID。
   * @param strRoomId 字符串类型的房间ID
   * @param userSig 用户签名。非必填，如果不传，则新房间会继续沿用旧房间的签名，此时需要保证旧房间签名没有过期。
   * @param privateMapKey 用于控制权限的权限票据。仅建议高安全级别的用户使用。
   */
  switchRoom(roomId: number | null, strRoomId: string | null, userSig: string | null, privateMapKey: string | null): void

  /**
   * 闭麦或取消闭麦。
   * @param mute 静音或解除静音。
   */
  muteLocalAudio(mute: boolean): void;
  /**
   * 对指定某个用户静音。当您静音某用户的远端音频时，SDK 会停止播放指定用户的声音，同时也会停止拉取该用户的音频数据。
   * @param userId 对方用户ID。
   * @param mute 静音与否。
   */
  muteRemoteAudio(userId: string, mute: boolean): void;

  /**
   * 当您静音所有用户的远端音频时，SDK 会停止播放所有来自远端的音频流，同时也会停止拉取所有用户的音频数据。
   * @param mute 静音与否。
   */
  muteAllRemoteAudio(mute: boolean): void;

  /**
   * 设置某个指定用户的声音播放音量。注意，是指定某个用户在本机上的播放音量，而不是是对方用户禁言。
   * @param userId 指定用户ID。
   * @param volume 指定音量。
   */
  setRemoteAudioVolume(userId: string, volume: number): void;
  /**
   * 禁用或开启控制台日志打印。
   */
  setConsoleLogEnabled(enabled: boolean): void;

  /**
   * 控制台打印日志级别。
   * @param level 日志级别。
   */
  setConsoleLogLevel(level: any): void;

  /**
   * 设置人声的混响效果。
   * @param reverbType 混响类型
   */
  setVoiceReverbType(reverbType: TRTCReverbType): void;

  /**
   * 设置变声特效。
   * @param changeType 变声类型
   */
  setVoiceChangerType(changeType: TRTCVoiceChangerType): void
```
如果有其他需求，也可以给我提issue


## 联系我
QQ群：682911244

## Roadmap
- [ ] 渲染视频内容
