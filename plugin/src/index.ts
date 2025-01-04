import { AndroidConfig, ConfigPlugin, withAndroidManifest, withEntitlementsPlist, withInfoPlist, withXcodeProject } from 'expo/config-plugins';

const withTRTCConfigPlugin: ConfigPlugin = config => {
  config = withAndroidManifest(config, conf => {
    const mainApplication = AndroidConfig.Manifest.getMainApplicationOrThrow(conf.modResults)
    // AndroidConfig.Manifest.addMetaDataItemToMainApplication
    return conf
  })
  return config;
};

export default withTRTCConfigPlugin;
