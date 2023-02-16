import 'flutter_ios_pip_platform_interface.dart';

class FlutterIosPip {
  Future<bool?> isPictureInPictureSupported() {
    return FlutterIosPipPlatform.instance.isPictureInPictureSupported();
  }

  Future<bool?> isPictureInPictureActive() {
    return FlutterIosPipPlatform.instance.isPictureInPictureActive();
  }

  Future<void> initPictureInPicture() {
    return FlutterIosPipPlatform.instance.initPictureInPicture();
  }

  Future<void> startPictureInPicture() {
    return FlutterIosPipPlatform.instance.startPictureInPicture();
  }

  Future<void> stopPictureInPicture() {
    return FlutterIosPipPlatform.instance.stopPictureInPicture();
  }
}
