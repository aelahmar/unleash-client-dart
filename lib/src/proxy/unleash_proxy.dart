import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:unleash/src/proxy/proxy_context.dart';
import 'package:unleash/src/proxy/unleash_proxy_client.dart';
import 'package:unleash/src/proxy/unleash_proxy_settings.dart';
import 'package:unleash/src/toggle_backup/_web_toggle_backup.dart';
import 'package:unleash/src/toggle_backup/toggle_backup.dart';
import 'package:unleash/src/toggles.dart';

typedef UpdateCallback = void Function();

class UnleashProxy {
  UnleashProxy._internal(
    this.settings,
    this._onUpdate,
    this._unleashClient,
    ToggleBackup? toggleBackup,
  ) : _backupRepository = toggleBackup ?? NoOpToggleBackup();

  final UnleashProxyClient _unleashClient;
  final UnleashProxySettings settings;
  final UpdateCallback? _onUpdate;
  final ToggleBackup _backupRepository;

  /// Collection of all available toggles
  Toggles? _toggles;

  /// This timer is responsible for starting a new request
  /// every time the given [UnleashProxySettings.pollingInterval] expired.
  Timer? _togglePollingTimer;

  /// Unleash Context
  /// https://docs.getunleash.io/user_guide/unleash_context
  ProxyContext? context;

  /// Initializes an [Unleash] instance and
  /// starts to load the toggles from proxy.
  /// [settings] are used to specify the proxy and various other settings.
  /// A [client] can be used for example to further configure http headers
  /// according to your needs.
  static Future<UnleashProxy> init(
    UnleashProxySettings settings,
    ProxyContext context, {
    UnleashProxyClient? client,
    UpdateCallback? onUpdate,
    ToggleBackup? toggleBackup,
  }) async {
    final unleash = UnleashProxy._internal(
      settings,
      onUpdate,
      client ??
          UnleashProxyClient(
            context: context,
            settings: settings,
            client: http.Client(),
          ),
      toggleBackup,
    );

    await unleash._loadToggles();
    unleash._setTogglePollingTimer();
    return unleash;
  }

  /// Updating [ProxyContext] data.
  /// This will trigger a new request to the proxy server
  Future<void> updateContext(ProxyContext context) async {
    this.context = context;
    await _loadToggles();
  }

  bool isEnabled(
    String toggleName, {
    bool defaultValue = false,
  }) {
    final defaultToggle = Toggle(
      name: toggleName,
      enabled: defaultValue,
    );

    final toggle = _toggles?.toggles?.firstWhere(
      (toggle) => toggle.name == toggleName,
      orElse: () => defaultToggle,
    );

    final isEnabled = toggle?.enabled ?? defaultValue;

    return isEnabled;
  }

  /// Cancels all periodic actions of this Unleash instance
  void dispose() {
    _togglePollingTimer?.cancel();
  }

  Future<void> _loadToggles() async {
    final toggles = await _unleashClient.fetchToggles();

    if (toggles != null) {
      await _backupRepository.saveToggles(toggles);
      _onUpdate?.call();
      _toggles = toggles;
    } else {
      _toggles = await _backupRepository.loadToggles();
    }
  }

  void _setTogglePollingTimer() {
    final pollingInterval = settings.pollingInterval;
    // disable polling if no pollingInterval is given
    if (pollingInterval == null) {
      return;
    }

    _togglePollingTimer = Timer.periodic(pollingInterval, (timer) {
      _loadToggles();
    });
  }
}
