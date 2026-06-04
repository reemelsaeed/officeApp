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
}
///////////////////////////////////////////////////////////////////////////////////////////
                            ///senseors//   
enum SensorType { temperature, humidity, co2, occupancy, gas, smoke, waterLeak, door, motion, noise, energy }

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