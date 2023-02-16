import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ios_pip/flutter_ios_pip_method_channel.dart';

void main() {
  MethodChannelFlutterIosPip platform = MethodChannelFlutterIosPip();
  const MethodChannel channel = MethodChannel('flutter_ios_pip');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('isPictureInPictureSupported', () async {
    expect(await platform.isPictureInPictureSupported(), true);
  });
}
