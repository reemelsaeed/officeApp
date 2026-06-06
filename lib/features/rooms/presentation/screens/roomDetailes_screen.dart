import 'package:flutter/material.dart';
import 'package:office_application/core/models/models.dart';
import 'package:office_application/core/services/mqtt_service.dart';
import 'package:office_application/features/rooms/data/models/room_model.dart';
import 'package:office_application/features/rooms/presentation/widgets/deviceCard_widget.dart';
import 'package:office_application/features/rooms/presentation/widgets/header_widget.dart';

class RoomdetailesScreen extends StatefulWidget {
  RoomdetailesScreen({super.key, required this.roomModel});
  final RoomModel roomModel;

  @override
  State<RoomdetailesScreen> createState() => _RoomdetailesScreenState();
}

class _RoomdetailesScreenState extends State<RoomdetailesScreen> {
  List<bool> devicesState = [];

  Map<SensorType, String> _sensorValues = {};

  Map<DeviceType, bool> _deviceStates = {};

  @override
  void initState() {
    super.initState();
    //devicesState = widget.roomModel.devices?.map((d) => d.isOn).toList() ?? [];
    // subscribe for sensors//
    for (final sensor in widget.roomModel.sensors ?? []) {
      MqttServices().subscribe(
        'office/room/${widget.roomModel.id}/sensors/${sensor.type.toString().split('.').last}',
        (payload) {
          if (mounted) {
            setState(() {
              _sensorValues[sensor.type] = payload;
            });
          }
        },
      );
    }
    //////////////////////////////////////////////////////////
    // subscribe for devices//
    for (final device in widget.roomModel.devices ?? []) {
      MqttServices().subscribe(
        'office/room/${widget.roomModel.id}/devices/${device.type.toString().split('.').last}/state',
        (payload) {
          if (mounted) {
            setState(() {
              _deviceStates[device.type] = payload == 'ON';
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
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Text(
              widget.roomModel.name,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Spacer(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: widget.roomModel.status == room_state.Occupied
                    ? Color(0xffFEF3C7)
                    : Color(0xffD1FAE5),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                widget.roomModel.status.name,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: widget.roomModel.status == room_state.Occupied
                      ? Color(0xff92400E)
                      : Color(0xff065F46),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sensors',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 12),
            HeaderWidget(
              roomModel: widget.roomModel,
              sensorValues: _sensorValues,
            ),
            SizedBox(height: 16),
            Text(
              'Devices',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1,
                ),
                itemCount: widget.roomModel.devices?.length ?? 0,
                itemBuilder: (context, index) {
                  return DeviceCard(
                    device: widget.roomModel.devices![index],
                    isOn:
                        _deviceStates[widget.roomModel.devices![index].type] ??
                        widget.roomModel.devices![index].isOn,
                    onToggle: (bool value) {
                      setState(() {
                        _deviceStates[widget.roomModel.devices![index].type] =
                            value;
                        MqttServices().publish(
                          'office/room/${widget.roomModel.id}/devices/${widget.roomModel.devices![index].type.toString().split('.').last}/command',
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
