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

### 核心方法

#### `initTRTCCloud(): Promise<void>`
初始化TRTC Cloud实例。初始化后才可以调用后续方法。

#### `enterRoom(params: EnterRoomParams): Promise<void>`
进入房间。

**EnterRoomParams 对象结构：**
- `sdkAppId`: 腾讯TRTC App ID
- `userId`: 你的用户体系的用户ID
- `roomId`: 房间ID（可选）
- `strRoomId`: 字符串类型的房间ID（可选，与roomId互斥）
- `userSig`: 鉴权票据，可以前端计算，也可以后端下发
- `role`: 进入房间角色（TRTCRole类型）
- `scene`: 使用场景，语音厅或者视频通话（TRTCAppScene类型）

#### `exitRoom(): Promise<void>`
退出房间。

#### `switchRoom(params: SwitchRoomParams): Promise<void>`
切换房间。适用于在线教育场景中，监课老师在多个房间中进行快速切换的场景。

**SwitchRoomParams 对象结构：**
- `roomId`: 房间ID（可选）
- `strRoomId`: 字符串类型的房间ID（可选）
- `userSig`: 用户签名（可选）
- `privateMapKey`: 用于控制权限的权限票据（可选）

### 角色与场景

#### `switchRole(role: TRTCRole, privateMapKey: string | undefined): Promise<void>`
切换用户角色，主播或者观众。

### 音频控制

#### `startLocalAudio(audioQuality: TRTCAudioQuality): Promise<void>`
打开本地麦克风采集。推荐先开启麦克风，再进入房间。

#### `muteLocalAudio(mute: boolean): Promise<void>`
闭麦或取消闭麦。

#### `muteRemoteAudio(userId: string, mute: boolean): Promise<void>`
对指定某个用户静音。

#### `muteAllRemoteAudio(mute: boolean): Promise<void>`
静音所有用户的远端音频。

#### `setAudioPlaybackVolume(volume: number): Promise<void>`
设置通话外放音量大小。

#### `setRemoteAudioVolume(userId: string, volume: number): Promise<void>`
设置某个指定用户的声音播放音量。

#### `enableAudioVolumeEvaluation(options: AudioVolumeEvaluationOptions): Promise<void>`
开启实时音量检测。

**AudioVolumeEvaluationOptions 对象结构：**
- `enable`: 是否启用音量评估
- `interval`: 音量提示的时间间隔（毫秒）
- `enableVadDetection`: 是否启用语音活动检测
- `enablePitchCalculation`: 是否启用音高计算
- `enableSpectrumCalculation`: 是否启用频谱计算

### 音效处理

#### `setVoiceReverbType(reverbType: TRTCReverbType): Promise<void>`
设置人声的混响效果。

#### `setVoiceChangerType(changeType: TRTCVoiceChangerType): Promise<void>`
设置变声特效。

### 摄像头控制

#### `switchCamera(useFrontCamera: boolean): Promise<void>`
切换前置/后置摄像头。

### 日志管理

#### `setConsoleLogEnabled(enabled: boolean): Promise<void>`
禁用或开启控制台日志打印。

#### `setConsoleLogLevel(level: any): void`
控制台打印日志级别。

### 枚举类型说明

#### TRTCAppScene
- `videoCall`: 视频通话场景
- `live`: 直播场景
- `audioCall`: 语音通话场景
- `voiceChatRoom`: 语音聊天室场景

#### TRTCRole
- `anchor`: 主播角色
- `audience`: 观众角色

#### TRTCAudioQuality
- `speech`: 语音模式，适合语音通话
- `default`: 默认模式
- `music`: 音乐模式，适合唱歌、游戏等场景

#### TRTCReverbType
- `noEffect`: 无混响
- `ktv`: KTV混响效果
- `smallRoom`: 小房间效果
- `hall`: 大厅混响效果
- 等多种混响效果选项

#### TRTCVoiceChangerType
- `noEffect`: 原声
- `badKid`: 熊孩子
- `loli`: 萝莉
- `uncle`: 大叔
- 等多种变声效果选项
如果有其他需求，也可以给我提issue


## 联系我
QQ群：682911244

## Roadmap
- [ ] 渲染视频内容
