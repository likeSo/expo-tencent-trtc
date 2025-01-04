import type { StyleProp, ViewStyle } from 'react-native';

export type OnLoadEventPayload = {
  url: string;
};

export type ExpoTencentTRTCModuleEvents = {
  onChange: (params: ChangeEventPayload) => void;
};

export type ChangeEventPayload = {
  value: string;
};

export type ExpoTencentTRTCViewProps = {
  url: string;
  onLoad: (event: { nativeEvent: OnLoadEventPayload }) => void;
  style?: StyleProp<ViewStyle>;
};

/**
 * TRTC房间场景
 */
export enum TRTCAppScene {
  /**
   * 视频通话
   */
  videoCall = 0,
  /**
   * 直播
   */
  live,
  /**
   * 语音通话
   */
  audioCall,
  /**
   * 语音厅
   */
  voiceChatRoom,
}

/**
 * TRTC进入房间角色
 */
export enum TRTCRole {
  /**
   * 房间主播。可以上麦讲话。
   */
  anchor = 20,
  /**
   * 房间观众。只能听主播讲话。
   */
  audience = 21
}

/**
 * TRTC音频流采集模式。
 */
export enum TRTCAudioQuality {
  /**
   * 讲话模式。该模式下的 SDK 音频模块会专注于提炼语音信号，尽最大限度的过滤周围的环境噪音，同时该模式下的音频数据也会获得较好的差质量网络的抵抗能力，因此该模式特别适合于“视频通话”和“在线会议”等侧重于语音沟通的场景。
   */
  speech = 1,
  /**
   * 默认模式。该模式下的 SDK 会启用智能识别算法来识别当前环境，并针对性地选择理想的处理模式。不过再好的识别算法也总是有不准确的时候，如果您非常清楚自己的产品定位，更推荐您在专注语音通信的 SPEECH 和专注音乐音质的 MUSIC 之间二选一。
   */
  default = 2,
  /**
   * 音乐模式。该模式下的 SDK 会采用很高的音频处理带宽以及立体式模式，在最大限度地提升采集质量的同时也会将音频的 DSP 处理模块调节到最弱的级别，从而最大限度地保证音质。因此该模式适合“音乐直播”场景，尤其适合主播采用专业的声卡进行音乐直播的场景。
   */
  music = 3
}

/**
 * TRTC音频路由。手机一般有两个声源，底部的扬声器和顶部的听筒。
 */
export enum TRTCAudioRoute {
  /**
   * 默认的路由设备。
   */
  unknown = -1,
  /**
   * 使用扬声器播放（即“免提”），扬声器位于手机底部，声音偏大，适合外放音乐。
   */
  speakphone = 0,
  /**
   * 使用听筒播放，听筒位于手机顶部，声音偏小，适合需要保护隐私的通话场景。
   */
  earpiece,
  /**
   * 使用有线耳机播放。
   */
  headset,
  /**
   * 使用蓝牙耳机播放。
   */
  bluetoothHeadset,
  /**
   * 使用 USB 声卡播放。
   */
  soundCard
}


/**
 * TRTC用户音量感知模型。
 */
export interface TRTCUserVolumeInfo {
  /**
   * 说话者的 userId, 如果 userId 为空则代表是当前用户自己。
   */
  userId: string | null,
  /**
   * 说话者的音量大小, 取值范围[0 - 100]。
   */
  volume: number;
  /**
   * 是否检测到人声，0：非人声 1：人声。
   */
  vad: number | null;
  /**
   * 本地用户的人声频率（单位：Hz），取值范围[0 - 4000]，对于远端用户，该值始终为0。
   */
  pitch: number | null;
  /**
   * 音频频谱数据是将音频数据在频率域中的分布，划分为 256 个频率段，使用 spectrumData 记录各个频率段的能量值，每个能量值的取值范围为 [-300, 0]，单位为 dBFS。
   * @note 本地频谱使用编码前的音频数据计算，会受到本地采集音量、BGM等影响；远端频谱使用接收到的音频数据计算，本地调整远端播放音量等操作不会对其产生影响。
   */
  spectrumData: number[] | null
}

/**
 * 网络质量枚举。
 * TRTC 会每隔两秒对当前的网络质量进行评估，评估结果为六个等级：Excellent 表示最好，Down 表示最差。
 */
export enum TRTCNetworkQuality {
  /**
   * 未定义。
   */
  unknown = 0,
  /**
   * 当前网络非常好。
   */
  excellent,
  /**
   * 当前网络比较好。
   */
  good,
  /**
   * 当前网络一般。
   */
  poor,
  /**
   * 当前网络较差。
   */
  bad,
  /**
   * 当前网络很差。
   */
  vBad,
  /**
   * 当前网络不满足 TRTC 的最低要求。
   */
  down
}

/**
 * 人声混响特效。
 */
export enum TRTCReverbType {
  /**
   * 关闭特效。
   */
  noEffect = 0,
  /**
   * KTV。
   */
  ktv,
  /**
   * 小房间。
   */
  smallRoom,
  /**
   * 大会堂。
   */
  hall,
  /**
   * 低沉
   */
  low,
  /**
   * 洪亮
   */
  high,
  /**
   * 金属声。
   */
  metal,
  /**
   * 磁性的。
   */
  magnetic,
  /**
   * 空灵的。
   */
  ethereal,
  /**
   * 录音棚。
   */
  recordingStudio,
  /**
   * 悠扬的。
   */
  melodious,
  /**
   * 录音棚2。
   */
  recordingStudio2
}

/**
 * TRTCVoiceChangerType 枚举用于表示不同的声音变换类型。
 */
export enum TRTCVoiceChangerType {
  /**
   * 关闭声音变换
   */
  noEffect = 0,

  /**
   * 熊孩子声音
   */
  badKid = 1,

  /**
   * 萝莉声音
   */
  loli = 2,

  /**
   * 大叔声音
   */
  uncle = 3,

  /**
   * 重金属声音
   */
  metal = 4,

  /**
   * 感冒声音
   */
  cold = 5,

  /**
   * 外语腔声音
   */
  foreignAccent = 6,

  /**
   * 困兽声音
   */
  trappedBeast = 7,

  /**
   * 肥宅声音
   */
  chubby = 8,

  /**
   * 强电流声音
   */
  strongElectricity = 9,

  /**
   * 重机械声音
   */
  heavyMachine = 10,

  /**
   * 空灵声音
   */
  ethereal = 11
}


/**
 * TRTCLogLevel 枚举用于定义日志的不同级别。
 * 不同的日志级别定义了不同的详实程度和日志数量，推荐一般情况下将日志等级设置为：logLevelInfo。
 */
export enum TRTCLogLevel {
  /**
   * 输出所有级别的 Log。
   */
  verbose = 0,

  /**
   * 输出 DEBUG，INFO，WARNING，ERROR 和 FATAL 级别的 Log。
   */
  debug = 1,

  /**
   * 输出 INFO，WARNING，ERROR 和 FATAL 级别的 Log。
   */
  info = 2,

  /**
   * 输出 WARNING，ERROR 和 FATAL 级别的 Log。
   */
  warn = 3,

  /**
   * 输出 ERROR 和 FATAL 级别的 Log。
   */
  error = 4,

  /**
   * 仅输出 FATAL 级别的 Log。
   */
  fatal = 5,

  /**
   * 不输出任何 SDK Log。
   */
  none = 6
}
