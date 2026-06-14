import 'package:office_application/core/models/models.dart';

class RoomModel {
  int id;
  String name;
  room_state? status;
  List<DeviceModel>? devices;
  List<SensorModel>? sensors;
  double? powerKwh;
  RoomModel({
    required this.id,
    required this.name,
    required this.status,
    this.devices,
    this.sensors,
    this.powerKwh,
  });

  factory RoomModel.fromMap(Map<String, dynamic> map) {
    return RoomModel(
      id: map['id'],
      name: map['name'],
      powerKwh: map['powerKwh'],
      status: room_state.available,
    );
  }
}

enum room_state { Occupied, available }

enum doorState { Looked, Open }
