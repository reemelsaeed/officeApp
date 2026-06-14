import 'package:flutter/material.dart';
import 'package:office_application/core/models/models.dart';
import 'package:office_application/features/rooms/data/models/room_model.dart';
import 'package:office_application/features/rooms/presentation/widgets/header_widget.dart';

class EnteranceScreen extends StatefulWidget {
  const EnteranceScreen({super.key, required this.roomModel});
  final RoomModel roomModel;
  @override
  State<EnteranceScreen> createState() => _EnteranceScreenState();
}

class _EnteranceScreenState extends State<EnteranceScreen> {
  Map<SensorType, String> _sensorValues = {};
  List<DeviceModel> devices = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Enterance')),
      body: Column(
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
        ],
      ),
    );
  }
}
