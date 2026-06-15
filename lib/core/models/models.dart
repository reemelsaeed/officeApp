enum DeviceType { light, ac, curtain, projector, socket }

enum AcMode { cool, heat, fan, auto }

enum AcFanSpeed { low, medium, high, auto }

class DeviceModel {
  int id;
  int roomId;
  String name;
  DeviceType type;
  bool isOn;
  double? temperature;
  String? curtainStatus;
  double brightness;
  AcMode acMode;
  AcFanSpeed acFanSpeed;

  DeviceModel({
    required this.id,
    required this.roomId,
    required this.name,
    required this.type,
    required this.isOn,
    this.temperature,
    this.curtainStatus,
    this.brightness = 0,
    this.acFanSpeed = AcFanSpeed.auto,
    this.acMode = AcMode.auto,
  });

  factory DeviceModel.fromMap(Map<String, dynamic> map) {
    return DeviceModel(
      id: map['id'],
      roomId: map['room_id'],
      name: map['name'],
      type: DeviceType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => DeviceType.socket,
      ),
      isOn: map['is_on'] ?? false,
      brightness: (map['brightness'] ?? 0).toDouble(),
      temperature: map['temperature'] != null
          ? (map['temperature'] as num).toDouble()
          : null,
      curtainStatus: map['curtain_status'],
      acMode: AcMode.values.firstWhere(
        (e) => e.name == (map['ac_mode'] ?? 'auto'),
        orElse: () => AcMode.auto,
      ),
      acFanSpeed: AcFanSpeed.values.firstWhere(
        (e) => e.name == (map['ac_fan_speed'] ?? 'auto'),
        orElse: () => AcFanSpeed.auto,
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
  gateway,
  router,
  networkSwitch,
  Usb,
  Switch,
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
  String roomName;

  ScheduleModel({
    required this.id,
    required this.time,
    required this.repeatRule,
    required this.deviceId,
    required this.state,
    required this.isActive,
    required this.deviceName,
    required this.roomId,
    required this.roomName,
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
      roomName: map['rooms']?['name'] ?? '',
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
