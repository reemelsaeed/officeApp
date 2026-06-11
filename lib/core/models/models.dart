enum DeviceType { light, ac, curtains, projector, socket }

class DeviceModel {
  int id;
  String name;
  DeviceType type;
  bool isOn;
  double? temperature;
  String? curtainStatus;

  DeviceModel({
    required this.id,
    required this.name,
    required this.type,
    required this.isOn,
    this.temperature,
    this.curtainStatus,
  });

  factory DeviceModel.fromMap(Map<String, dynamic> map) {
    return DeviceModel(
      id: map['id'],
      name: map['name'],
      isOn: false,
      type: DeviceType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => DeviceType.socket,
      ),
    );
  }
}

///////////////////////////////////////////////////////////////////////////////////////////
///senseors//
enum SensorType {
  temperature,
  humidity,
  co2,
  occupancy,
  gas,
  smoke,
  waterLeak,
  door,
  motion,
  noise,
  energy,
}

class SensorModel {
  String id;
  String name;
  SensorType type;
  double value;
  String unit;

  SensorModel({
    required this.id,
    required this.name,
    required this.type,
    required this.value,
    required this.unit,
  });
}

/////////////////////////////////////////////////////////////////////////////////////////////////////
//scene model
class SceneModel {
  int id;
  String name;
  int roomId;
  String roomName;
  List<DeviceModel> devices;

  SceneModel({
    required this.id,
    required this.name,
    required this.devices,
    required this.roomId,
    required this.roomName,
  });

  factory SceneModel.fromMap(Map<String, dynamic> map) {
    final sceneDevices = map['scene_devices'] as List? ?? [];
    return SceneModel(
      id: map['id'],
      name: map['name'],
      roomId: map['room_id'],
      roomName: map['rooms']?['name'] ?? '',
      devices: sceneDevices
          .map(
            (sd) => DeviceModel.fromMap(sd['devices'] as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////
//schedule model
class ScheduleModel {
  int id;
  String time;
  String repeatRule;
  int deviceId;
  String state;
  bool isActive;
  String deviceName;
  int roomId;

  ScheduleModel({
    required this.id,
    required this.time,
    required this.repeatRule,
    required this.deviceId,
    required this.state,
    required this.isActive,
    required this.deviceName,
    required this.roomId,
  });
  factory ScheduleModel.fromMap(Map<String, dynamic> map) {
    return ScheduleModel(
      id: map['id'],
      time: map['time'],
      repeatRule: map['days'],
      deviceId: map['device_id'],
      state: map['state'],
      isActive: map['is_active'],
      deviceName: map['device_name'] ?? '',
      roomId: map['room_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'time': time,
      'days': repeatRule,
      'device_id': deviceId,
      'state': state,
      'is_active': isActive,
      'device_name': deviceName,
      'room_id': roomId,
    };
  }
}

///////////////////////////////////////////////////////////////////////
class EnergyReading {
  int roomId;
  String roomName;
  double power;
  double kwh;

  EnergyReading({
    required this.roomId,
    required this.roomName,
    required this.power,
    required this.kwh,
  });

  factory EnergyReading.fromMap(Map<String, dynamic> map) {
    return EnergyReading(
      roomId: map['room_id'],
      roomName: map['room_name'],
      power: map['power'],
      kwh: map['kwh'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'room_id': roomId,
      'room_name': roomName,
      'power': power,
      'kwh': kwh,
    };
  }
}

///////////////////////////////////////////////////////////////////////////////
///userModel
class UserModel {
  String id;
  String name;
  userRole role;

  UserModel({required this.id, required this.name, required this.role});

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      role: userRole.values.firstWhere(
        (e) => e.name == map['role'],
        orElse: () => userRole.Employee,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'role': role.name};
  }
}

enum userRole { Admin, Manager, DepartmentHead, Employee, Maintenance, Guest }
