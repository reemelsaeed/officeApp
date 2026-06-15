import 'package:flutter/material.dart';
import 'package:office_application/core/models/models.dart';
import 'package:office_application/core/services/mqtt_service.dart';
import 'package:office_application/features/rooms/presentation/screens/device_detailes_screen.dart';
import 'package:office_application/features/rooms/presentation/widgets/deviceCard_widget.dart';

class SceneDetailesScreen extends StatefulWidget {
  const SceneDetailesScreen({super.key, required this.scene});
  final SceneModel scene;

  @override
  State<SceneDetailesScreen> createState() => _SceneDetailesScreenState();
}

class _SceneDetailesScreenState extends State<SceneDetailesScreen> {
  List<DeviceModel> devices = [];

  Map<int, bool> _deviceStates = {};

  @override
  @override
  void initState() {
    super.initState();
    devices = widget.scene.devices;

    for (final device in devices) {
      final cached = MqttServices().getCachedValue(
        'office/room/${widget.scene.roomId}/devices/${device.type.name}/state',
      );
      if (cached != null) {
        _deviceStates[device.id] = cached == 'ON';
      }

      MqttServices().subscribe(
        'office/room/${widget.scene.roomId}/devices/${device.type.name}/state',
        (payload) {
          if (mounted) {
            setState(() {
              _deviceStates[device.id] = payload == 'ON';
            });
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.scene.name),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Devices'),
            SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: .75,
                ),
                itemCount: devices.length,
                itemBuilder: (context, index) {
                  return DeviceCard(
                    device: devices[index],
                    isOn:
                        _deviceStates[devices[index].id] ?? devices[index].isOn,
                    onToggle: (bool value) {
                      setState(() {
                        _deviceStates[devices[index].id] = value;

                        MqttServices().publish(
                          'office/room/${widget.scene.roomId}/devices/${devices[index].type.toString().split('.').last}/command',
                          value ? 'ON' : 'OFF',
                        );
                      });
                    },
                    navigate: () async {
                      devices[index].isOn =
                          _deviceStates[devices[index].id] ?? false;
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              DeviceDetailesScreen(device: devices[index]),
                        ),
                      );
                      if (result != null && mounted) {
                        setState(() {
                          _deviceStates[devices[index].id] = result;
                        });
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
