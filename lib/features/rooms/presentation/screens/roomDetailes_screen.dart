import 'package:flutter/material.dart';
import 'package:office_application/core/models/models.dart';
import 'package:office_application/core/services/mqtt_service.dart';
import 'package:office_application/features/rooms/data/models/room_model.dart';
import 'package:office_application/features/rooms/presentation/widgets/deviceCard_widget.dart';
import 'package:office_application/features/rooms/presentation/widgets/header_widget.dart';
import 'package:office_application/features/rooms/presentation/widgets/scenes_widget.dart';
import 'package:office_application/features/rooms/services/room_services.dart';

class RoomdetailesScreen extends StatefulWidget {
  RoomdetailesScreen({super.key, required this.roomModel});
  final RoomModel roomModel;

  @override
  State<RoomdetailesScreen> createState() => _RoomdetailesScreenState();
}

class _RoomdetailesScreenState extends State<RoomdetailesScreen> {
  List<bool> devicesState = [];
  Map<SensorType, String> _sensorValues = {};
  Map<int, bool> _deviceStates = {};
  List<DeviceModel> _devices = [];
  List<SceneModel> _scenes = [];
  Set<int> _activeScenes = {};

  @override
  void initState() {
    super.initState();
    subscripeForDevices();
    _loadDevices();
    _loadscenes();
    // subscribe for sensors//
    for (final sensor in widget.roomModel.sensors ?? []) {
      MqttServices().subscribe(
        'office/room/${widget.roomModel.id}/sensors/${sensor.type.toString().split('.').last}',
        (payload) {
          if (mounted) {
            setState(() {
              _sensorValues[sensor.type] = payload;
            });
          }
        },
      );
      final cached = MqttServices().getCachedValue(
        'office/room/${widget.roomModel.id}/sensors/${sensor.type.toString().split('.').last}',
      );
      if (cached != null) {
        _sensorValues[sensor.type] = cached;
      }
    }
    //////////////////////////////////////////////////////////
    // subscribe for devices//
  }

  void subscripeForDevices() async {
    for (final device in _devices) {
      MqttServices().subscribe(
        'office/room/${widget.roomModel.id}/devices/${device.type.toString().split('.').last}/state',
        (payload) {
          if (mounted) {
            setState(() {
              _deviceStates[device.id] = payload == 'ON';
            });
          }
        },
      );
      final cached = MqttServices().getCachedValue(
        'office/room/${widget.roomModel.id}/devices/${device.type.toString().split('.').last}/state',
      );
      if (cached != null) {
        _deviceStates[device.id] = cached == 'ON';
      }
    }
  }

  void _loadDevices() async {
    final data = await RoomServices().getDevices(widget.roomModel.id);
    if (!mounted) return;
    setState(() {
      _devices = data.map((map) => DeviceModel.fromMap(map)).toList();
    });
    for (final device in _devices) {
      MqttServices().subscribe(
        'office/room/${widget.roomModel.id}/devices/${device.type.name}/state',
        (payload) {
          if (mounted) {
            setState(() {
              _deviceStates[device.id] = payload == 'ON';
            });
          }
        },
      );
      final cached = MqttServices().getCachedValue(
        'office/room/${widget.roomModel.id}/devices/${device.type.name}/state',
      );
      if (cached != null && mounted) {
        setState(() {
          _deviceStates[device.id] = cached == 'ON';
        });
      }
    }
  }

  ///////////////////////////////////
  void _loadscenes() async {
    final data = await RoomServices().getScenes(widget.roomModel.id);
    if (!mounted) return;
    setState(() {
      _scenes = data.map((map) => SceneModel.fromMap(map)).toList();
    });
  }

  ///////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Text(
              widget.roomModel.name,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Spacer(),
            // Container(
            //   padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            //   decoration: BoxDecoration(
            //     color: widget.roomModel.status == room_state.Occupied
            //         ? Color(0xffFEF3C7)
            //         : Color(0xffD1FAE5),
            //     borderRadius: BorderRadius.circular(100),
            //   ),
            //   child: Text(
            //     widget.roomModel.status.name,
            //     style: TextStyle(
            //       fontSize: 11,
            //       fontWeight: FontWeight.w500,
            //       color: widget.roomModel.status == room_state.Occupied
            //           ? Color(0xff92400E)
            //           : Color(0xff065F46),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              if (_scenes.isNotEmpty) ...[
                Text(
                  'Quick Scenes',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _scenes.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: ScenesWidget(
                          sceneModel: _scenes[index],

                          onPlay: () {
                            final isActive = _activeScenes.contains(index);
                            setState(() {
                              if (isActive) {
                                _activeScenes.remove(index);
                              } else {
                                _activeScenes.add(index);
                              }
                            });
                            MqttServices().publish(
                              'office/room/${widget.roomModel.id}/scenes/${_scenes[index].name}/command',
                              isActive ? 'OFF' : 'ON',
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 16),
              ],

              if (_devices.isNotEmpty) ...[
                Text(
                  'Devices',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1,
                  ),
                  itemCount: _devices.length,
                  itemBuilder: (context, index) {
                    return DeviceCard(
                      device: _devices[index],
                      isOn: _deviceStates[_devices[index].id] ?? false,
                      onToggle: (bool value) {
                        setState(() {
                          _deviceStates[_devices[index].id] = value;
                          MqttServices().publish(
                            'office/room/${widget.roomModel.id}/devices/${_devices[index].type.name}/command',
                            value ? 'ON' : 'OFF',
                          );
                        });
                      },
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
