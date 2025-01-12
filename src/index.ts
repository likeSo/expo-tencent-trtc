// Reexport the native module. On web, it will be resolved to ExpoTencentTRTCModule.web.ts
// and on native platforms to ExpoTencentTRTCModule.ts
export { default as ExpoTencentTRTC } from './ExpoTencentTRTCModule';
export { default as ExpoTencentTRTCView } from './ExpoTencentTRTCView';
export * from  './ExpoTencentTRTC.types';

export * from './libs'