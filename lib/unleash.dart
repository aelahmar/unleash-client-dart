import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:unleash/features.dart';
import 'package:unleash/register.dart';
import 'package:unleash/unleash_settings.dart';

class Unleash {
  Unleash._internal();

  static final Unleash _instance = Unleash._internal();

  UnleashSettings settings;

  Features features;

  static Future<void> init(UnleashSettings settings) async {
    assert(settings != null);
    _instance.settings = settings;
    await _instance._register();
    _instance.features = await _instance._loadToggles();
    print(_instance.features);
  }

  Future<void> _register() async {
    final register = Register(
      appName: settings.appName,
      instanceId: settings.instanceId,
      interval: settings.metricsReportingInterval.inMilliseconds,
      sdkVersion: 'unleash-client-dart:0.0.1',
      started: DateTime.now().toIso8601String(),
    );

    // TODO: What to do with the response?
    final response = await http.post(
      '${settings.unleashApi.toString()}/client/register',
      headers: settings.toHeaders(),
      body: json.encode(register.toJson()),
    );
    print(response.body);
  }

  Future<Features> _loadToggles() async {
    final reponse = await http.get(
      '${settings.unleashApi.toString()}/client/features',
      headers: settings.toHeaders(),
    );
    final stringResponse = utf8.decode(reponse.bodyBytes);
    final features =
        Features.fromJson(json.decode(stringResponse) as Map<String, dynamic>);

    return features;
  }

  // ignore: unused_element
  Future<void> _reportMetrics() async {}

  static bool isEnabled(String feature, {bool defaultValue = false}) {
    return _instance._isEnabled(feature, defaultValue: defaultValue);
  }

  bool _isEnabled(String feature, {bool defaultValue = false}) {
    final f = features.features.firstWhere((toggle) => toggle.name == feature);
    if (f == null) {
      return defaultValue;
    }
    return f.enabled;
  }
}
