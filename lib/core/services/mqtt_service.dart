import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttServices {
  final Map<String, String> _cachedValues = {};

  static final MqttServices _instance = MqttServices._internal();
  factory MqttServices() => _instance;
  MqttServices._internal();

  late MqttServerClient _client;
  final Map<String, List<Function(String)>> _listeners = {};
  //final Map<String, Function(String)> _listeners = {};

  Future<void> connect() async {
    _client = MqttServerClient(
      '6ad8aa6b59804afcb63fc52f7a7e8962.s1.eu.hivemq.cloud',
      'flutter_${DateTime.now().millisecondsSinceEpoch}',
    );
    _client.port = 8883;
    _client.keepAlivePeriod = 60;
    _client.logging(on: true);
    _client.autoReconnect = true;
    _client.secure = true;

    final connMessage = MqttConnectMessage()
        .authenticateAs('reemelsaeed', 'r_M45678')
        .withClientIdentifier(
          'flutter_${DateTime.now().millisecondsSinceEpoch}',
        )
        .startClean();
    _client.connectionMessage = connMessage;

    try {
      await _client.connect();
      print('Broker connected!');
    } catch (e) {
      print('connection fail $e');
      _client.disconnect();
      return;
    }

    _client.updates!.listen((messages) {
      final message = messages.first;
      final topic = message.topic;
      print('Message received: $topic');
      final payload = MqttPublishPayload.bytesToStringAsString(
        (message.payload as MqttPublishMessage).payload.message,
      );
      // print(' Payload: $payload');
      _cachedValues[topic] = payload;

      if (_listeners.containsKey(topic)) {
        for (final listener in _listeners[topic]!) {
          listener(payload);
        }
      }
    });

    await Future.delayed(Duration(milliseconds: 500));
    _clearPowerRetained();
  }

  void _clearPowerRetained() {
    for (int i = 1; i <= 10; i++) {
      final builder = MqttClientPayloadBuilder();
      builder.addString('');
      _client.publishMessage(
        'office/room/$i/power',
        MqttQos.atLeastOnce,
        builder.payload!,
        retain: true,
      );
    }
    final builder = MqttClientPayloadBuilder();
    builder.addString('');
    _client.publishMessage(
      'office/home/power',
      MqttQos.atLeastOnce,
      builder.payload!,
    );
  }

  Future<void> subscribe(String topic, Function(String) onMessage) async {
    _listeners[topic] ??= [];
    _listeners[topic]!.add(onMessage);

    await _ensureConnected();
    _client.subscribe(topic, MqttQos.atLeastOnce);
  }

  Future<void> _ensureConnected() async {
    if (_client.connectionStatus?.state != MqttConnectionState.connected) {
      await connect();
    }
  }

  void publish(String topic, String message) async {
    if (_client.connectionStatus?.state != MqttConnectionState.connected) {
      await connect();
    }
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    _client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
  }
  //////////////////////for saving values from broker/////////////////////////////////

  String? getCachedValue(String topic) => _cachedValues[topic];

  /////////////////////////////////////////////////////////////////////////////
  ///
  Future<void> subscribeLive(String topic, Function(String) onMessage) async {
    _listeners[topic] ??= [];
    if (!_listeners[topic]!.contains(onMessage)) {
      _listeners[topic]!.add(onMessage);
    }
    await _ensureConnected();
    _client.subscribe(topic, MqttQos.atLeastOnce);
  }
}
