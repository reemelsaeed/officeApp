import 'package:flutter/material.dart';
import 'package:office_application/core/models/models.dart';
import 'package:office_application/features/rooms/data/models/room_model.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key, required this.roomModel});
  final RoomModel roomModel;

  @override
  Widget build(BuildContext context) {
    final temp = roomModel.sensors?.firstWhere(
      (s) => s.type == SensorType.temperature,
      orElse: () => SensorModel(
        id: '',
        name: '',
        type: SensorType.temperature,
        value: 0,
        unit: '°C',
      ),
    );
    final co2 = roomModel.sensors?.firstWhere(
      (s) => s.type == SensorType.co2,
      orElse: () => SensorModel(
        id: '',
        name: '',
        type: SensorType.co2,
        value: 0,
        unit: 'ppm',
      ),
    );
    final occupancy = roomModel.sensors?.firstWhere(
      (s) => s.type == SensorType.occupancy,
      orElse: () => SensorModel(
        id: '',
        name: '',
        type: SensorType.occupancy,
        value: 0,
        unit: '',
      ),
    );
    final door = roomModel.sensors?.firstWhere(
      (s) => s.type == SensorType.door,
      orElse: () => SensorModel(
        id: '',
        name: '',
        type: SensorType.door,
        value: 0,
        unit: '',
      ),
    );
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            ///// TEMP /////
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.thermostat, size: 14, color: Colors.grey),
                        SizedBox(width: 4),
                        Text(
                          'TEMP',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text('${temp?.value}${temp?.unit}'),
                  ],
                ),
              ),
            ),

            VerticalDivider(
              width: 1,
              thickness: 0.5,
              color: Colors.grey.shade200,
            ),

            ///// PEOPLE /////
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 14,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'PEOPLE',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text('${occupancy?.value.toInt()}'),
                  ],
                ),
              ),
            ),

            VerticalDivider(
              width: 1,
              thickness: 0.5,
              color: Colors.grey.shade200,
            ),
            ///// CO2 /////
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.air, size: 14, color: Colors.grey),
                        SizedBox(width: 4),
                        Text(
                          'CO2',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text('${co2?.value.toStringAsFixed(0)}'),
                  ],
                ),
              ),
            ),

            VerticalDivider(
              width: 1,
              thickness: 0.5,
              color: Colors.grey.shade200,
            ),

            ///// DOOR /////
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.door_front_door_outlined,
                          size: 14,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'DOOR',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(door?.value == 1 ? 'Locked' : 'Open'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
