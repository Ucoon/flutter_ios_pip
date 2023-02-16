import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ios_pip/flutter_ios_pip.dart';
import 'package:flutter_ios_pip/flutter_ios_pip_platform_interface.dart';
import 'package:flutter_ios_pip/flutter_ios_pip_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterIosPipPlatform
    with MockPlatformInterfaceMixin
    implements FlutterIosPipPlatform {
  @override
  Future<bool?> isPictureInPictureSupported() => Future.value(true);

  @override
  Future<void> initPictureInPicture() async {}

  @override
  Future<bool?> isPictureInPictureActive() => Future.value(false);

  @override
  Future<void> startPictureInPicture() async {}

  @override
  Future<void> stopPictureInPicture() async {}
}

void main() {
  final FlutterIosPipPlatform initialPlatform = FlutterIosPipPlatform.instance;

  test('$MethodChannelFlutterIosPip is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterIosPip>());
  });

  test('getPlatformVersion', () async {
    FlutterIosPip flutterIosPipPlugin = FlutterIosPip();
    MockFlutterIosPipPlatform fakePlatform = MockFlutterIosPipPlatform();
    FlutterIosPipPlatform.instance = fakePlatform;

    expect(await flutterIosPipPlugin.isPictureInPictureSupported(), true);
  });
}
