// import 'package:flutter_test/flutter_test.dart';
// import 'package:flutter_media_store/flutter_media_store.dart';
// import 'package:flutter_media_store/flutter_media_store_platform_interface.dart';
// import 'package:flutter_media_store/flutter_media_store_method_channel.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';
//
// class MockFlutterMediaStorePlatform
//     with MockPlatformInterfaceMixin
//     implements FlutterMediaStorePlatform {
//
//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }
//
// void main() {
//   final FlutterMediaStorePlatform initialPlatform = FlutterMediaStorePlatform.instance;
//
//   test('$MethodChannelFlutterMediaStore is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelFlutterMediaStore>());
//   });
//
//   test('getPlatformVersion', () async {
//     FlutterMediaStore flutterMediaStorePlugin = FlutterMediaStore();
//     MockFlutterMediaStorePlatform fakePlatform = MockFlutterMediaStorePlatform();
//     FlutterMediaStorePlatform.instance = fakePlatform;
//
//     expect(await flutterMediaStorePlugin.getPlatformVersion(), '42');
//   });
// }
