import 'dart:async';

import 'package:unleash/src/proxy/proxy_context.dart';
import 'package:unleash/src/proxy/unleash_proxy.dart';
import 'package:unleash/src/proxy/unleash_proxy_settings.dart';

Future<void> main() async {
  UnleashProxy? unleashProxy;
  onUpdate() {
    print('refreshed feature toggles');
    print(unleashProxy?.isEnabled('awesome_feature'));
  }

  unleashProxy = await UnleashProxy.init(
    UnleashProxySettings(
      proxyUrl: 'https://domain/proxy',
      clientKey: 'client_key',
      pollingInterval: const Duration(seconds: 5),
    ),
    ProxyContext(
      appName: 'app_name',
      environment: 'development',
      properties: {
        'devicePlatform': 'ios',
      },
    ),
    onUpdate: onUpdate,
  );

  // wait some time so that toggles can be polled a few times
  // and dispose unleash at the end of it
  Timer(
    const Duration(seconds: 30),
    unleashProxy.dispose,
  );
}
