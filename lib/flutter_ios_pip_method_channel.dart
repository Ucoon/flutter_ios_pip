import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_ios_pip_platform_interface.dart';

/// An implementation of [FlutterIosPipPlatform] that uses method channels.
class MethodChannelFlutterIosPip extends FlutterIosPipPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_ios_pip');

  @override
  Future<bool?> isPictureInPictureSupported() async {
    final isPictureInPictureSupported = await methodChannel.invokeMethod<bool>('isPictureInPictureSupported');
    return isPictureInPictureSupported;
  }

  @override
  Future<bool?> isPictureInPictureActive() async {
    final isPictureInPictureActive = await methodChannel.invokeMethod<bool>('isPictureInPictureActive');
    return isPictureInPictureActive;
  }

  @override
  Future<void> initPictureInPicture() async {
    return methodChannel.invokeMethod<void>('initPictureInPicture');
  }

  @override
  Future<void> startPictureInPicture() async {
    return methodChannel.invokeMethod<void>('startPictureInPicture');
  }

  @override
  Future<void> stopPictureInPicture() async {
    return methodChannel.invokeMethod<void>('stopPictureInPicture');
  }
}
