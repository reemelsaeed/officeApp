import 'package:flutter/material.dart';
import 'package:office_application/core/models/models.dart';
import 'package:office_application/features/rooms/data/models/room_model.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({
    super.key,
    required this.roomModel,
    required this.sensorValues,
  });
  final RoomModel roomModel;
  final Map<SensorType, String> sensorValues;

  @override
  Widget build(BuildContext context) {
    final sensors = roomModel.sensors ?? [];
    IconData _getIcon(SensorType type) {
      switch (type) {
        case SensorType.temperature:
          return Icons.thermostat;
        case SensorType.co2:
          return Icons.air;
        case SensorType.occupancy:
          return Icons.people_outline;
        case SensorType.door:
          return Icons.door_front_door_outlined;
        case SensorType.gas:
          return Icons.local_fire_department_outlined;
        case SensorType.smoke:
          return Icons.smoking_rooms_outlined;
        case SensorType.waterLeak:
          return Icons.water_drop_outlined;
        case SensorType.humidity:
          return Icons.water_outlined;
        default:
          return Icons.sensors;
      }
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.5,
      ),
      itemCount: sensors.length,
      itemBuilder: (context, index) {
        final sensor = sensors[index];
        return Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(_getIcon(sensor.type), size: 16, color: Colors.grey),
              SizedBox(height: 8),
              Text(
                sensor.name,
                style: TextStyle(fontSize: 11, color: Colors.grey),
              ),
              SizedBox(height: 4),
              Text(
                sensor.type == SensorType.door
                    ? (sensorValues[sensor.type] == '1' ? 'Locked' : 'Open')
                    : '${sensorValues[sensor.type] ?? '--'}${sensor.unit}',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        );
      },
    );
  }
}
