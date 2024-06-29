import 'package:dart_pusher_channels/dart_pusher_channels.dart';

class PusherClientService {
  static PusherClientService? _instance;

  static PusherClientService get instance => _instance ??= PusherClientService._();

  PusherClientService._();

  late final PusherChannelsOptions _options;

  PusherChannelsOptions get options => _options;

  Future<void> init() async {
    PusherChannelsPackageLogger.enableLogs();

    _options = PusherChannelsOptions.fromHost(
      scheme: "ws", // should be -> ws
      host: '192.168.100.3',
      port: 6001,
      key: "D4C11397CF5822DDA8516843BFE7AE0944E36A01",
    );
  }

  Future<PusherChannelsClient> subscriptionCreator() async {
    final pusherChannelClient = PusherChannelsClient.websocket(
      options: options,
      connectionErrorHandler: (f, s, t) {},
    );

    return pusherChannelClient;
  }
}
