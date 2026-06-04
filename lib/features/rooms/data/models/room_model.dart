import 'package:office_application/core/models/models.dart';

class RoomModel {
  int id;
  String name;
  double temperature;
  room_state status;
  int? peopleCount;
  double? co2;
  doorState? doorStatus;
  List<DeviceModel>? devices;
  List<SensorModel>? sensors;
  RoomModel({
    required this.id,
    required this.name,
    required this.temperature,
    required this.status,
    this.co2 = 400,
    this.doorStatus = doorState.Looked,
    this.peopleCount = 0,
    this.devices,
    this.sensors,
  });
}

enum room_state { Occupied, available }

enum doorState { Looked, Open }
