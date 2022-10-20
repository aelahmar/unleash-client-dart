class UnleashProxySettings {
  const UnleashProxySettings({
    required this.proxyUrl,
    required this.clientKey,
    this.pollingInterval = const Duration(seconds: 15),
  });

  final String proxyUrl;
  final String clientKey;
  final Duration? pollingInterval;
}
