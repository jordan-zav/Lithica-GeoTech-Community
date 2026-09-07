import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../lib/src/application/geotech_controller.dart';

void main() {
  final binding = TestWidgetsFlutterBinding.ensureInitialized();
  tearDown(() => binding.platformDispatcher.clearLocaleTestValue());
  test('first launch detects device language and persists it', () async {
    SharedPreferences.setMockInitialValues({});
    binding.platformDispatcher.localeTestValue = const Locale('es', 'PE');
    final controller = GeotechController();
    await controller.loadPreferences();
    expect(controller.languageCode, 'es');
    binding.platformDispatcher.localeTestValue = const Locale('ja');
    final restored = GeotechController();
    await restored.loadPreferences();
    expect(restored.languageCode, 'es');
  });
  test('unsupported locale falls back to English', () async {
    SharedPreferences.setMockInitialValues({});
    binding.platformDispatcher.localeTestValue = const Locale('ja');
    final controller = GeotechController();
    await controller.loadPreferences();
    expect(controller.languageCode, 'en');
  });
}