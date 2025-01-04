import { requireNativeView } from 'expo';
import * as React from 'react';

import { ExpoTencentTRTCViewProps } from './ExpoTencentTRTC.types';

const NativeView: React.ComponentType<ExpoTencentTRTCViewProps> =
  requireNativeView('ExpoTencentTRTC');

export default function ExpoTencentTRTCView(props: ExpoTencentTRTCViewProps) {
  return <NativeView {...props} />;
}
