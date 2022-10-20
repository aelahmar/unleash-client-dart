class ProxyContext {
  ProxyContext({
    this.appName,
    this.environment,
    this.userId,
    this.remoteAddress,
    this.sessionId,
    this.properties,
  });

  final String? appName;
  final String? environment;
  final String? userId;
  final String? remoteAddress;
  final String? sessionId;
  final Map<String, String>? properties;

  ProxyContext copyWith({
    String? appName,
    String? environment,
    String? userId,
    String? remoteAddress,
    String? sessionId,
    Map<String, String>? properties,
  }) {
    return ProxyContext(
      appName: appName ?? this.appName,
      environment: environment ?? this.environment,
      userId: userId ?? this.userId,
      remoteAddress: remoteAddress ?? this.remoteAddress,
      sessionId: sessionId ?? this.sessionId,
      properties: properties ?? this.properties,
    );
  }

  Map<String, String> getQueryParameters() {
    Map<String, String> queryParameters = {};

    if (appName != null) {
      queryParameters['appName'] = appName!;
    }

    if (environment != null) {
      queryParameters['env'] = environment!;
    }

    if (userId != null) {
      queryParameters['userId'] = userId!;
    }

    if (remoteAddress != null) {
      queryParameters['remoteAddress'] = remoteAddress!;
    }

    if (sessionId != null) {
      queryParameters['sessionId'] = sessionId!;
    }

    properties?.forEach((key, value) {
      queryParameters[key] = value;
    });

    return queryParameters;
  }
}
