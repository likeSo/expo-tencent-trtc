import { useEvent } from 'expo';
import { ExpoTencentTRTC, ExpoTencentTRTCView, ExpoTencentTRTCViewRef } from 'expo-tencent-trtc';
import { useEffect, useRef } from 'react';
import { Button, SafeAreaView, ScrollView, Text, View } from 'react-native';

export default function App() {
  const eventPayload = useEvent(ExpoTencentTRTC, 'onTRTCEvent');
  const ref = useRef<ExpoTencentTRTCViewRef>(null);

  useEffect(() => {
    if (ref.current) {
      ref.current.startLocalPreview(true);
    }
  }, []);

  return (
    <SafeAreaView style={styles.container}>
      <ScrollView style={styles.container}>
        <Text style={styles.header}>Module API Example</Text>
        <Group name="Constants">
          <Text>{ExpoTencentTRTC.PI}</Text>
        </Group>
        <Group name="Functions">
          <Text>{ExpoTencentTRTC.hello()}</Text>
        </Group>
        <Group name="Async functions">
          <Button
            title="Set value"
            onPress={async () => {
              await ExpoTencentTRTC.setValueAsync('Hello from JS!');
            }}
          />
        </Group>
        <Group name="Events">
          <Text>{JSON.stringify(eventPayload)}</Text>
        </Group>
        <Group name="Views">
          <ExpoTencentTRTCView
            ref={ref}
            style={styles.view}
          />
        </Group>
      </ScrollView>
    </SafeAreaView>
  );
}

function Group(props: { name: string; children: React.ReactNode }) {
  return (
    <View style={styles.group}>
      <Text style={styles.groupHeader}>{props.name}</Text>
      {props.children}
    </View>
  );
}

const styles = {
  header: {
    fontSize: 30,
    margin: 20,
  },
  groupHeader: {
    fontSize: 20,
    marginBottom: 20,
  },
  group: {
    margin: 20,
    backgroundColor: '#fff',
    borderRadius: 10,
    padding: 20,
  },
  container: {
    flex: 1,
    backgroundColor: '#eee',
  },
  view: {
    flex: 1,
    height: 200,
  },
};
