// import 'package:firebase_remote_config/firebase_remote_config.dart';
//
// class RemoteConfigService {
//   RemoteConfigService({
//     FirebaseRemoteConfig? remoteConfig,
//   }) : _remoteConfig = remoteConfig ?? FirebaseRemoteConfig.instance;
//
//   final FirebaseRemoteConfig _remoteConfig;
//
//   static const String _zegoAppSignIn = 'zegoAppSignIn';
//   static const String _zegoAppId = 'zegoAppId';
//   static const String _zegoCallbackSecret = 'zegoCallbackSecret';
//   static const String _zegoServerSecret = 'zegoServerSecret';
//   static const String _getStreamAccessKey = 'getStreamAccessKey';
//   static const String _geminiModel = 'geminiModel';
//   static const String _geminiApiKey = 'geminiApiKey';
//
//   /// **Initialize and fetch remote config**
//   Future<void> setup({
//     RemoteConfigSettings? remoteConfigSettings,
//   }) async {
//     await _remoteConfig.setConfigSettings(
//       remoteConfigSettings ??
//           RemoteConfigSettings(
//             fetchTimeout: const Duration(minutes: 1),
//             minimumFetchInterval: const Duration(minutes: 1),
//           ),
//     );
//     await _remoteConfig.fetchAndActivate();
//   }
//
//   /// Fetch environment-specific values from Remote Config
//   String _getString(String key) {
//     return _remoteConfig.getString(key);
//   }
//
//   int _getInt(String key) {
//     return int.tryParse(_remoteConfig.getString(key)) ?? 0;
//   }
//
//   /// Mapped environment values
//   String get zegoAppSignIn => _getString(_zegoAppSignIn);
//   int get zegoAppId => _getInt(_zegoAppId);
//   String get zegoCallbackSecret => _getString(_zegoCallbackSecret);
//   String get zegoServerSecret => _getString(_zegoServerSecret);
//   String get getStreamAccessKey => _getString(_getStreamAccessKey);
//   String get geminiModel => _getString(_geminiModel);
//   String get geminiApiKey => _getString(_geminiApiKey);
// }
