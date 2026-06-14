import 'package:office_application/core/models/models.dart';
import 'package:office_application/features/rooms/data/models/room_model.dart';

///////rooms//////
List<RoomModel> allRooms = [
  RoomModel(
    id: 5,
    name: 'Head Office 1',
    //temperature: 22,
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
  ),
  //////////////////////////////////////////////////////////////////////////////////
  RoomModel(
    id: 9,
    name: '',
    //temperature: 22,
    status: room_state.available,
    sensors: [
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
  ////////////////////////////////////////////////////////////////////////////////
  RoomModel(
    id: 10,
    name: 'Server',
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
        id: 's1',
        name: 'Smoke',
        type: SensorType.smoke,
        value: 0,
        unit: 'ppm',
      ),
      SensorModel(
        id: 's2',
        name: 'Power Usage',
        type: SensorType.energy,
        value: 0,
        unit: 'KWH',
      ),
      SensorModel(
        id: 's1',
        name: 'Gateway',
        type: SensorType.gateway,
        value: 1, //1 online , 0 offline
        unit: '',
      ),
      SensorModel(
        id: 's1',
        name: 'Router',
        type: SensorType.router,
        value: 1, //1 online , 0 offline
        unit: '',
      ),
      SensorModel(
        id: 's1',
        name: 'Switch',
        type: SensorType.Switch,
        value: 1, //1 online , 0 offline
        unit: '',
      ),
    ],
  ),
  ///////////////////////////////////////
  RoomModel(
    id: 6,
    name: 'Head office 2',
    //temperature: 22,
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
  ///////////////////////////////////////////////////////////////////////////////////
  RoomModel(
    id: 7,
    name: 'Head Office 3',
    //temperature: 22,
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
  ),

  ///
  RoomModel(
    id: 1,
    name: 'Meeting Room 1',
    //temperature: 22,
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
  ),
  ///////////////////////////////////////////////////////////////////////////////////////
  RoomModel(
    id: 8,
    name: 'Head Office 4',
    //temperature: 22,
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
  ),

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////
  RoomModel(
    id: 2,
    name: 'Meeting Room 2',
    //temperature: 23,
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
    //temperature: 23,
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
    //temperature: 20,
    status: room_state.available,
  ),
];
