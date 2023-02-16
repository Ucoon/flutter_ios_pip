import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_ios_pip/flutter_ios_pip.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isPictureInPictureSupported = false;
  bool _isPictureInPictureActive = false;
  final _flutterIosPipPlugin = FlutterIosPip();

  @override
  void initState() {
    super.initState();
    isPictureInPictureSupported();
  }

  Future<void> isPictureInPictureSupported() async {
    bool isPictureInPictureSupported;
    try {
      isPictureInPictureSupported =
          await _flutterIosPipPlugin.isPictureInPictureSupported() ?? false;
    } on PlatformException {
      isPictureInPictureSupported = false;
    }
    if (!mounted) return;

    setState(() {
      _isPictureInPictureSupported = isPictureInPictureSupported;
    });
  }

  Future<void> isPictureInPictureActive() async {
    bool isPictureInPictureActive;
    try {
      isPictureInPictureActive =
          await _flutterIosPipPlugin.isPictureInPictureActive() ?? false;
    } on PlatformException {
      isPictureInPictureActive = false;
    }
    if (!mounted) return;

    setState(() {
      _isPictureInPictureActive = isPictureInPictureActive;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                  'isPictureInPictureSupported: $_isPictureInPictureSupported\n'),
              TextButton(
                child: const Text('初始化画中画'),
                onPressed: () {
                  _flutterIosPipPlugin.initPictureInPicture();
                },
              ),
              TextButton(
                child: const Text('开启画中画'),
                onPressed: () {
                  _flutterIosPipPlugin.startPictureInPicture();
                },
              ),
              TextButton(
                child: const Text('关闭画中画'),
                onPressed: () {
                  _flutterIosPipPlugin.stopPictureInPicture();
                },
              ),
              TextButton(
                child: Text('画中画状态：$_isPictureInPictureActive'),
                onPressed: () {
                  isPictureInPictureActive();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
