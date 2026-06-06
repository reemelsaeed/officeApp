import 'package:office_application/core/models/models.dart';
import 'package:office_application/features/rooms/data/models/room_model.dart';

///////rooms//////
List<RoomModel> allRooms = [
  RoomModel(
    id: 1,
    name: 'Meeting Room 1',
    temperature: 22,
    status: room_state.available,
    sensors: [
      SensorModel(
        id: 's1',
        name: 'Temperature',
        type: SensorType.temperature,
        value: 23,
        unit: '°C',
      ),
      SensorModel(
        id: 's2',
        name: 'CO2',
        type: SensorType.co2,
        value: 520,
        unit: 'ppm',
      ),
      SensorModel(
        id: 's3',
        name: 'Occupancy',
        type: SensorType.occupancy,
        value: 8,
        unit: '',
      ),
      SensorModel(
        id: 's4',
        name: 'Door',
        type: SensorType.door,
        value: 1,
        unit: '',
      ),
    ],
    devices: [
      DeviceModel(id: 1, name: 'AC', type: DeviceType.ac, isOn: true),
      DeviceModel(
        id: 1,
        name: 'curtains',
        type: DeviceType.curtains,
        isOn: true,
      ),
      DeviceModel(id: 1, name: 'Light', type: DeviceType.light, isOn: true),
      DeviceModel(
        id: 1,
        name: 'projector',
        type: DeviceType.projector,
        isOn: true,
      ),
    ],
  ),
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////
  RoomModel(
    id: 2,
    name: 'Meeting Room 2',
    temperature: 23,
    status: room_state.Occupied,
    sensors: [
      SensorModel(
        id: 's1',
        name: 'Temperature',
        type: SensorType.temperature,
        value: 23,
        unit: '°C',
      ),
      SensorModel(
        id: 's2',
        name: 'CO2',
        type: SensorType.co2,
        value: 520,
        unit: 'ppm',
      ),
      SensorModel(
        id: 's3',
        name: 'Occupancy',
        type: SensorType.occupancy,
        value: 8,
        unit: '',
      ),
      SensorModel(
        id: 's4',
        name: 'Door',
        type: SensorType.door,
        value: 1,
        unit: '',
      ),
    ],
  ),
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////
  RoomModel(
    id: 3,
    name: 'Kitchen',
    temperature: 23,
    status: room_state.Occupied,
    sensors: [
      SensorModel(
        id: 's1',
        name: 'Gas',
        type: SensorType.gas,
        value: 0,
        unit: 'ppm',
      ),
      SensorModel(
        id: 's2',
        name: 'Smoke',
        type: SensorType.smoke,
        value: 0,
        unit: 'ppm',
      ),
      SensorModel(
        id: 's3',
        name: 'Water Leak',
        type: SensorType.waterLeak,
        value: 0,
        unit: '',
      ),
      SensorModel(
        id: 's4',
        name: 'Temperature',
        type: SensorType.temperature,
        value: 25,
        unit: '°C',
      ),
      SensorModel(
        id: 's5',
        name: 'Humidity',
        type: SensorType.humidity,
        value: 60,
        unit: '%',
      ),
    ],
  ),
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////
  RoomModel(
    id: 4,
    name: 'Office 1',
    temperature: 20,
    status: room_state.available,
    devices: [
      DeviceModel(id: 1, name: 'AC', type: DeviceType.ac, isOn: true),
      DeviceModel(
        id: 1,
        name: 'curtains',
        type: DeviceType.curtains,
        isOn: true,
      ),
      DeviceModel(id: 1, name: 'Light', type: DeviceType.light, isOn: true),
      DeviceModel(
        id: 1,
        name: 'projector',
        type: DeviceType.projector,
        isOn: true,
      ),
    ],
  ),
];
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
List<DeviceModel> allDevices = [
  DeviceModel(id: 1, name: 'AC', type: DeviceType.ac, isOn: true),
  DeviceModel(id: 1, name: 'curtains', type: DeviceType.curtains, isOn: true),
  DeviceModel(id: 1, name: 'Light', type: DeviceType.light, isOn: true),
  DeviceModel(id: 1, name: 'projector', type: DeviceType.projector, isOn: true),
  DeviceModel(id: 1, name: 'socket', type: DeviceType.socket, isOn: true),
];
