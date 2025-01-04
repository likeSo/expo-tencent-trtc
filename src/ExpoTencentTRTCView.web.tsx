import * as React from 'react';

import { ExpoTencentTRTCViewProps } from './ExpoTencentTRTC.types';

export default function ExpoTencentTRTCView(props: ExpoTencentTRTCViewProps) {
  return (
    <div>
      <iframe
        style={{ flex: 1 }}
        src={props.url}
        onLoad={() => props.onLoad({ nativeEvent: { url: props.url } })}
      />
    </div>
  );
}
