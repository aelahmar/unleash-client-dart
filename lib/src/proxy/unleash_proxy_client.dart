import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart';
import 'package:unleash/src/proxy/proxy_context.dart';
import 'package:unleash/src/proxy/unleash_proxy_settings.dart';
import 'package:unleash/src/toggles.dart';

/// Responsible for the communication with Unleash Proxy Server
class UnleashProxyClient {
  UnleashProxyClient({
    Client? client,
    required UnleashProxySettings settings,
    required ProxyContext context,
  })  : _client = client ?? Client(),
        _settings = settings,
        _context = context;

  final Client _client;
  final UnleashProxySettings _settings;
  final ProxyContext _context;

  /// Loads feature toggles from Unleash server
  Future<Toggles?> fetchToggles() async {
    try {
      final proxyUrl = Uri.parse(_settings.proxyUrl).replace(
        queryParameters: _context.getQueryParameters(),
      );

      final response = await _client.get(
        proxyUrl,
        headers: {
          'Authorization': _settings.clientKey,
        },
      );

      final stringResponse = utf8.decode(response.bodyBytes);

      return Toggles.fromJson(
        json.decode(stringResponse) as Map<String, dynamic>,
      );
    } catch (e, stackTrace) {
      log(
        'Could not load toggles from Unleash proxy.\n'
        'Please make sure your configuration is correct.',
        name: 'unleash',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  UnleashProxyClient updateProxyContext({
    required ProxyContext context,
  }) {
    return UnleashProxyClient(
      client: _client,
      settings: _settings,
      context: context,
    );
  }
}
