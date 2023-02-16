import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_ios_pip_method_channel.dart';

abstract class FlutterIosPipPlatform extends PlatformInterface {
  /// Constructs a FlutterIosPipPlatform.
  FlutterIosPipPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterIosPipPlatform _instance = MethodChannelFlutterIosPip();

  /// The default instance of [FlutterIosPipPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterIosPip].
  static FlutterIosPipPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterIosPipPlatform] when
  /// they register themselves.
  static set instance(FlutterIosPipPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool?> isPictureInPictureSupported() {
    throw UnimplementedError('isPictureInPictureSupported() has not been implemented.');
  }

  Future<bool?> isPictureInPictureActive() {
    throw UnimplementedError('isPictureInPictureActive() has not been implemented.');
  }

  Future<void> initPictureInPicture() {
    throw UnimplementedError('initPictureInPicture() has not been implemented.');
  }

  Future<void> startPictureInPicture() {
    throw UnimplementedError('startPictureInPicture() has not been implemented.');
  }

  Future<void> stopPictureInPicture() {
    throw UnimplementedError('stopPictureInPicture() has not been implemented.');
  }
}
