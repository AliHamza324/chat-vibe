//
//  Generated file. Do not edit.
//

// clang-format off

#import "GeneratedPluginRegistrant.h"

#if __has_include(<audio_session/AudioSessionPlugin.h>)
#import <audio_session/AudioSessionPlugin.h>
#else
@import audio_session;
#endif

#if __has_include(<audio_waveforms/AudioWaveformsPlugin.h>)
#import <audio_waveforms/AudioWaveformsPlugin.h>
#else
@import audio_waveforms;
#endif

#if __has_include(<audioplayers_darwin/AudioplayersDarwinPlugin.h>)
#import <audioplayers_darwin/AudioplayersDarwinPlugin.h>
#else
@import audioplayers_darwin;
#endif

#if __has_include(<cloud_firestore/FLTFirebaseFirestorePlugin.h>)
#import <cloud_firestore/FLTFirebaseFirestorePlugin.h>
#else
@import cloud_firestore;
#endif

#if __has_include(<connectivity_plus/ConnectivityPlusPlugin.h>)
#import <connectivity_plus/ConnectivityPlusPlugin.h>
#else
@import connectivity_plus;
#endif

#if __has_include(<device_info_plus/FPPDeviceInfoPlusPlugin.h>)
#import <device_info_plus/FPPDeviceInfoPlusPlugin.h>
#else
@import device_info_plus;
#endif

#if __has_include(<file_picker/FilePickerPlugin.h>)
#import <file_picker/FilePickerPlugin.h>
#else
@import file_picker;
#endif

#if __has_include(<firebase_auth/FLTFirebaseAuthPlugin.h>)
#import <firebase_auth/FLTFirebaseAuthPlugin.h>
#else
@import firebase_auth;
#endif

#if __has_include(<firebase_core/FLTFirebaseCorePlugin.h>)
#import <firebase_core/FLTFirebaseCorePlugin.h>
#else
@import firebase_core;
#endif

#if __has_include(<flutter_callkit_incoming/FlutterCallkitIncomingPlugin.h>)
#import <flutter_callkit_incoming/FlutterCallkitIncomingPlugin.h>
#else
@import flutter_callkit_incoming;
#endif

#if __has_include(<flutter_image_compress_common/ImageCompressPlugin.h>)
#import <flutter_image_compress_common/ImageCompressPlugin.h>
#else
@import flutter_image_compress_common;
#endif

#if __has_include(<flutter_local_notifications/FlutterLocalNotificationsPlugin.h>)
#import <flutter_local_notifications/FlutterLocalNotificationsPlugin.h>
#else
@import flutter_local_notifications;
#endif

#if __has_include(<flutter_logs/FlutterLogsPlugin.h>)
#import <flutter_logs/FlutterLogsPlugin.h>
#else
@import flutter_logs;
#endif

#if __has_include(<flutter_ringtone_player/FlutterRingtonePlayerPlugin.h>)
#import <flutter_ringtone_player/FlutterRingtonePlayerPlugin.h>
#else
@import flutter_ringtone_player;
#endif

#if __has_include(<flutter_sound/FlutterSound.h>)
#import <flutter_sound/FlutterSound.h>
#else
@import flutter_sound;
#endif

#if __has_include(<flutter_volume_controller/FlutterVolumeControllerPlugin.h>)
#import <flutter_volume_controller/FlutterVolumeControllerPlugin.h>
#else
@import flutter_volume_controller;
#endif

#if __has_include(<image_picker_ios/FLTImagePickerPlugin.h>)
#import <image_picker_ios/FLTImagePickerPlugin.h>
#else
@import image_picker_ios;
#endif

#if __has_include(<just_audio/JustAudioPlugin.h>)
#import <just_audio/JustAudioPlugin.h>
#else
@import just_audio;
#endif

#if __has_include(<native_device_orientation/NativeDeviceOrientationPlugin.h>)
#import <native_device_orientation/NativeDeviceOrientationPlugin.h>
#else
@import native_device_orientation;
#endif

#if __has_include(<package_info_plus/FPPPackageInfoPlusPlugin.h>)
#import <package_info_plus/FPPPackageInfoPlusPlugin.h>
#else
@import package_info_plus;
#endif

#if __has_include(<path_provider_foundation/PathProviderPlugin.h>)
#import <path_provider_foundation/PathProviderPlugin.h>
#else
@import path_provider_foundation;
#endif

#if __has_include(<permission_handler_apple/PermissionHandlerPlugin.h>)
#import <permission_handler_apple/PermissionHandlerPlugin.h>
#else
@import permission_handler_apple;
#endif

#if __has_include(<shared_preferences_foundation/SharedPreferencesPlugin.h>)
#import <shared_preferences_foundation/SharedPreferencesPlugin.h>
#else
@import shared_preferences_foundation;
#endif

#if __has_include(<sqflite_darwin/SqflitePlugin.h>)
#import <sqflite_darwin/SqflitePlugin.h>
#else
@import sqflite_darwin;
#endif

#if __has_include(<vibration/VibrationPlugin.h>)
#import <vibration/VibrationPlugin.h>
#else
@import vibration;
#endif

#if __has_include(<wakelock_plus/WakelockPlusPlugin.h>)
#import <wakelock_plus/WakelockPlusPlugin.h>
#else
@import wakelock_plus;
#endif

#if __has_include(<zego_callkit/ZegoCallkitPlugin.h>)
#import <zego_callkit/ZegoCallkitPlugin.h>
#else
@import zego_callkit;
#endif

#if __has_include(<zego_express_engine/ZegoExpressEnginePlugin.h>)
#import <zego_express_engine/ZegoExpressEnginePlugin.h>
#else
@import zego_express_engine;
#endif

#if __has_include(<zego_uikit/ZegoUikitPlugin.h>)
#import <zego_uikit/ZegoUikitPlugin.h>
#else
@import zego_uikit;
#endif

#if __has_include(<zego_uikit_prebuilt_call/ZegoUIKitCallPlugin.h>)
#import <zego_uikit_prebuilt_call/ZegoUIKitCallPlugin.h>
#else
@import zego_uikit_prebuilt_call;
#endif

#if __has_include(<zego_uikit_signaling_plugin/ZegoUikitSignalingPlugin.h>)
#import <zego_uikit_signaling_plugin/ZegoUikitSignalingPlugin.h>
#else
@import zego_uikit_signaling_plugin;
#endif

#if __has_include(<zego_zim/ZegoZimPlugin.h>)
#import <zego_zim/ZegoZimPlugin.h>
#else
@import zego_zim;
#endif

#if __has_include(<zego_zpns/ZegoZpnsPlugin.h>)
#import <zego_zpns/ZegoZpnsPlugin.h>
#else
@import zego_zpns;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [AudioSessionPlugin registerWithRegistrar:[registry registrarForPlugin:@"AudioSessionPlugin"]];
  [AudioWaveformsPlugin registerWithRegistrar:[registry registrarForPlugin:@"AudioWaveformsPlugin"]];
  [AudioplayersDarwinPlugin registerWithRegistrar:[registry registrarForPlugin:@"AudioplayersDarwinPlugin"]];
  [FLTFirebaseFirestorePlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTFirebaseFirestorePlugin"]];
  [ConnectivityPlusPlugin registerWithRegistrar:[registry registrarForPlugin:@"ConnectivityPlusPlugin"]];
  [FPPDeviceInfoPlusPlugin registerWithRegistrar:[registry registrarForPlugin:@"FPPDeviceInfoPlusPlugin"]];
  [FilePickerPlugin registerWithRegistrar:[registry registrarForPlugin:@"FilePickerPlugin"]];
  [FLTFirebaseAuthPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTFirebaseAuthPlugin"]];
  [FLTFirebaseCorePlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTFirebaseCorePlugin"]];
  [FlutterCallkitIncomingPlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterCallkitIncomingPlugin"]];
  [ImageCompressPlugin registerWithRegistrar:[registry registrarForPlugin:@"ImageCompressPlugin"]];
  [FlutterLocalNotificationsPlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterLocalNotificationsPlugin"]];
  [FlutterLogsPlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterLogsPlugin"]];
  [FlutterRingtonePlayerPlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterRingtonePlayerPlugin"]];
  [FlutterSound registerWithRegistrar:[registry registrarForPlugin:@"FlutterSound"]];
  [FlutterVolumeControllerPlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterVolumeControllerPlugin"]];
  [FLTImagePickerPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTImagePickerPlugin"]];
  [JustAudioPlugin registerWithRegistrar:[registry registrarForPlugin:@"JustAudioPlugin"]];
  [NativeDeviceOrientationPlugin registerWithRegistrar:[registry registrarForPlugin:@"NativeDeviceOrientationPlugin"]];
  [FPPPackageInfoPlusPlugin registerWithRegistrar:[registry registrarForPlugin:@"FPPPackageInfoPlusPlugin"]];
  [PathProviderPlugin registerWithRegistrar:[registry registrarForPlugin:@"PathProviderPlugin"]];
  [PermissionHandlerPlugin registerWithRegistrar:[registry registrarForPlugin:@"PermissionHandlerPlugin"]];
  [SharedPreferencesPlugin registerWithRegistrar:[registry registrarForPlugin:@"SharedPreferencesPlugin"]];
  [SqflitePlugin registerWithRegistrar:[registry registrarForPlugin:@"SqflitePlugin"]];
  [VibrationPlugin registerWithRegistrar:[registry registrarForPlugin:@"VibrationPlugin"]];
  [WakelockPlusPlugin registerWithRegistrar:[registry registrarForPlugin:@"WakelockPlusPlugin"]];
  [ZegoCallkitPlugin registerWithRegistrar:[registry registrarForPlugin:@"ZegoCallkitPlugin"]];
  [ZegoExpressEnginePlugin registerWithRegistrar:[registry registrarForPlugin:@"ZegoExpressEnginePlugin"]];
  [ZegoUikitPlugin registerWithRegistrar:[registry registrarForPlugin:@"ZegoUikitPlugin"]];
  [ZegoUIKitCallPlugin registerWithRegistrar:[registry registrarForPlugin:@"ZegoUIKitCallPlugin"]];
  [ZegoUikitSignalingPlugin registerWithRegistrar:[registry registrarForPlugin:@"ZegoUikitSignalingPlugin"]];
  [ZegoZimPlugin registerWithRegistrar:[registry registrarForPlugin:@"ZegoZimPlugin"]];
  [ZegoZpnsPlugin registerWithRegistrar:[registry registrarForPlugin:@"ZegoZpnsPlugin"]];
}

@end
