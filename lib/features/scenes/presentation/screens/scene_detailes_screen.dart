import 'package:flutter/material.dart';
import 'package:office_application/core/models/models.dart';
import 'package:office_application/core/services/mqtt_service.dart';
import 'package:office_application/features/rooms/presentation/widgets/deviceCard_widget.dart';
import 'package:office_application/features/scenes/services/scenes_services.dart';

class SceneDetailesScreen extends StatefulWidget {
  const SceneDetailesScreen({super.key, required this.scene});
  final SceneModel scene;

  @override
  State<SceneDetailesScreen> createState() => _SceneDetailesScreenState();
}

class _SceneDetailesScreenState extends State<SceneDetailesScreen> {
  List<DeviceModel> devices = [];

  Map<DeviceType, bool> _deviceStates = {};

  @override
  void initState() {
    //_loadDevices();
    super.initState();
    devices = widget.scene.devices;
  }

  void _loadDevices() async {
    final data = await ScenesServices().getsceneDevices(widget.scene.roomId);
    setState(() {
      devices = data.map((map) => DeviceModel.fromMap(map)).toList();
    });
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
                        _deviceStates[devices[index].type] ??
                        devices[index].isOn,
                    onToggle: (bool value) {
                      setState(() {
                        _deviceStates[devices[index].type] = value;
                        MqttServices().publish(
                          'office/room/${widget.scene.roomId}/devices/${devices[index].type.toString().split('.').last}/command',
                          value ? 'ON' : 'OFF',
                        );
                      });
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
