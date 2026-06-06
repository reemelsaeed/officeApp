import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttServices {
  static final MqttServices _instance = MqttServices._internal();
  factory MqttServices() => _instance;
  MqttServices._internal();

  late MqttServerClient _client;
  final Map<String, Function(String)> _listeners = {};

  Future<void> connect() async {
    _client = MqttServerClient(
      'broker.hivemq.com',
      'flutter_test_${DateTime.now().millisecondsSinceEpoch}',
    );
    _client.port = 1883;
    _client.keepAlivePeriod = 30;
    _client.logging(on: true);

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
      print('Message received on topic: $topic');
      final payload = MqttPublishPayload.bytesToStringAsString(
        (message.payload as MqttPublishMessage).payload.message,
      );
      if (_listeners.containsKey(topic)) {
        _listeners[topic]!(payload);
      }
    });
  }

  // void subscribe(String topic, Function(String) onMessage) {
  //   _listeners[topic] = onMessage;
  //   _client.subscribe(topic, MqttQos.atLeastOnce);
  // }

  Future<void> subscribe(String topic, Function(String) onMessage) async {
    _listeners[topic] = onMessage;

    if (_client.connectionStatus?.state != MqttConnectionState.connected) {
      await connect();
    }

    _client.subscribe(topic, MqttQos.atLeastOnce);
  }

  void publish(String topic, String message) async {
    if (_client.connectionStatus?.state != MqttConnectionState.connected) {
      await connect();
    }
    final builder = MqttClientPayloadBuilder();

    builder.addString(message);
    _client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
  }
}
