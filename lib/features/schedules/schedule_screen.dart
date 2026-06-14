import 'package:flutter/material.dart';
import 'package:office_application/core/models/models.dart';
import 'package:office_application/core/services/mqtt_service.dart';
import 'package:office_application/features/rooms/data/models/room_model.dart';
import 'package:office_application/features/schedules/scheduleServices/schedule_services.dart';
import 'package:office_application/features/schedules/widgets/schedule_widget.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  List<ScheduleModel> allSchedules = [];
  ScheduleModel? scheduleModel;
  Map<int, bool> _scheduleStates = {};

  @override
  void initState() {
    super.initState();
    loadSchedules();
  }

  Future<void> loadSchedules() async {
    final data = await ScheduleServices().getAllSchedules();
    setState(() {
      allSchedules = data.map((map) => ScheduleModel.fromMap(map)).toList();
      for (var s in allSchedules) {
        _scheduleStates[s.id] = s.isActive;
      }
    });
    _subscribeToSchedules();
  }

  void _subscribeToSchedules() {
    for (var schedule in allSchedules) {
      MqttServices().subscribe(
        'office/room/Schedules/${schedule.roomId}/device/${schedule.deviceId}/state',
        //office/room/Schedules/1/device/1/state
        (payload) {
          if (mounted) {
            setState(() {
              _scheduleStates[schedule.id] = payload.trim() == 'ON';
            });
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, title: Text('Schedules')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: allSchedules.isEmpty
            ? Center(child: Text('No Schedules yet!'))
            : ListView.builder(
                itemCount: allSchedules.length,
                itemBuilder: (context, index) => ScheduleWidget(
                  scheduleModel: allSchedules[index],
                  onToggle: (bool value) {
                    setState(() {
                      _scheduleStates[allSchedules[index].id] = value;
                      MqttServices().publish(
                        'office/room/${allSchedules[index].roomId}/device/${allSchedules[index].deviceId}/command',
                        value ? 'ON' : 'OFF',
                      );
                    });
                  },
                  isOn: _scheduleStates[allSchedules[index].id] ?? false,
                  deletSchedule: () async {
                    await ScheduleServices().deleteSchedule(
                      allSchedules[index].id,
                    );
                    loadSchedules();
                    setState(() {});
                  },

                  editSchedule: () async {
                    await showModalBottomSheet(
                      backgroundColor: Colors.white,
                      isScrollControlled: true,
                      context: context,
                      builder: (context) =>
                          AddScheduleSheet(editSchedule: allSchedules[index]),
                    );
                    loadSchedules();
                  },
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff1877F2),
        foregroundColor: Colors.white,
        onPressed: () async {
          await showModalBottomSheet(
            backgroundColor: Colors.white,

            isScrollControlled: true,
            context: context,
            builder: (context) => AddScheduleSheet(),
          );
          loadSchedules();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

// ─────────────────────────────────────────
class AddScheduleSheet extends StatefulWidget {
  AddScheduleSheet({super.key, this.editSchedule});
  ScheduleModel? editSchedule;
  @override
  State<AddScheduleSheet> createState() => _AddScheduleSheetState();
}

class _AddScheduleSheetState extends State<AddScheduleSheet> {
  RoomModel? selectedRoom;
  DeviceModel? selectedDevice;
  List<DeviceModel> filteredDevices = [];
  TimeOfDay? selectedTime;
  bool isOn = true;
  bool everyDay = false;
  List<String> allDays = ['Sat', 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri'];
  List<String> selectedDays = [];
  List<RoomModel> allRooms = [];
  List<DeviceModel> roomDevices = [];

  @override
  void initState() {
    super.initState();
    _loadRooms();
    if (widget.editSchedule != null) {
      final parts = widget.editSchedule!.time.split(':');
      selectedTime = TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      );
      everyDay = widget.editSchedule!.repeatRule == 'everyday';
      if (!everyDay) selectedDays = widget.editSchedule!.repeatRule.split(',');
    }
  }

  void _loadRooms() async {
    final data = await ScheduleServices().getAllrooms();
    setState(() {
      allRooms = data.map((map) => RoomModel.fromMap(map)).toList();
    });
  }

  void _loadDevices(int roomId) async {
    final data = await ScheduleServices().getDevicesByRoom(roomId);
    setState(() {
      roomDevices = data.map((map) => DeviceModel.fromMap(map)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // ① Room Dropdown
            Text('Room', style: TextStyle(fontWeight: FontWeight.w600)),
            SizedBox(height: 8),
            DropdownButtonFormField<RoomModel>(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
              hint: Text('Select room'),
              items: allRooms
                  .map(
                    (room) =>
                        DropdownMenuItem(value: room, child: Text(room.name)),
                  )
                  .toList(),
              onChanged: (room) {
                setState(() => selectedRoom = room);
                _loadDevices(room!.id);
              },
            ),
            SizedBox(height: 16),

            // ② Device Dropdown
            Text('Device', style: TextStyle(fontWeight: FontWeight.w600)),
            SizedBox(height: 8),
            DropdownButtonFormField<DeviceModel>(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
              hint: Text('Select device'),
              value: selectedDevice,
              items: roomDevices
                  .map(
                    (device) => DropdownMenuItem(
                      value: device,
                      child: Text(device.name),
                    ),
                  )
                  .toList(),
              onChanged: selectedRoom == null
                  ? null
                  : (value) {
                      setState(() => selectedDevice = value);
                    },
            ),
            SizedBox(height: 16),

            // ③ Time Picker
            Text('Time', style: TextStyle(fontWeight: FontWeight.w600)),
            SizedBox(height: 8),
            GestureDetector(
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (time != null) setState(() => selectedTime = time);
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.access_time, size: 18, color: Colors.grey),
                    SizedBox(width: 8),
                    Text(
                      selectedTime != null
                          ? selectedTime!.format(context)
                          : 'Select time',
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),

            // ④ Every Day Toggle
            Row(
              children: [
                Text(
                  'Every Day',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Spacer(),
                Switch(
                  value: everyDay,
                  onChanged: (value) => setState(() {
                    everyDay = value;
                    selectedDays = value ? List.from(allDays) : [];
                  }),
                  activeTrackColor: Color(0xff1877F2),
                  activeColor: Colors.white,
                ),
              ],
            ),

            if (!everyDay) ...[
              SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: allDays.map((day) {
                  final selected = selectedDays.contains(day);
                  return FilterChip(
                    label: Text(day),
                    selected: selected,
                    onSelected: (value) => setState(() {
                      value ? selectedDays.add(day) : selectedDays.remove(day);
                    }),
                    selectedColor: Color(0xff1877F2).withOpacity(0.15),
                    checkmarkColor: Color(0xff1877F2),
                  );
                }).toList(),
              ),
            ],

            SizedBox(height: 24),

            // ⑥ Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff1877F2),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  if (selectedRoom == null ||
                      selectedDevice == null ||
                      selectedTime == null)
                    return;
                  if (widget.editSchedule != null) {
                    ScheduleServices().editSchedule(
                      widget.editSchedule!.id,
                      ScheduleModel(
                        id: widget.editSchedule!.id,
                        time:
                            '${selectedTime!.hour}:${selectedTime!.minute.toString().padLeft(2, '0')}',
                        repeatRule: everyDay
                            ? 'everyday'
                            : selectedDays.join(','),
                        deviceId:
                            selectedDevice?.id ?? widget.editSchedule!.deviceId,
                        deviceName:
                            selectedDevice?.name ??
                            widget.editSchedule!.deviceName,
                        roomId: selectedRoom?.id ?? widget.editSchedule!.roomId,
                        roomName:
                            selectedRoom?.name ?? widget.editSchedule!.roomName,
                        state: isOn ? 'ON' : 'OFF',
                        isActive: true,
                      ),
                    );
                  } else {
                    ScheduleServices().addSchedule(
                      ScheduleModel(
                        id: 0,
                        time:
                            '${selectedTime!.hour}:${selectedTime!.minute.toString().padLeft(2, '0')}',
                        repeatRule: everyDay
                            ? 'everyday'
                            : selectedDays.join(','),
                        deviceId: selectedDevice!.id,
                        deviceName: selectedDevice!.name,
                        roomId: selectedRoom!.id,
                        state: isOn ? 'ON' : 'OFF',
                        isActive: true,
                        roomName: selectedRoom!.name,
                      ),
                    );
                  }

                  Navigator.pop(context);
                },
                child: Text('Save Schedule'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
