import 'package:flutter/material.dart';
import 'package:office_application/core/models/models.dart';
import 'package:office_application/core/services/mqtt_service.dart';
import 'package:office_application/features/Energy/presentation/widgets/widget_models.dart';
import 'package:office_application/features/Energy/presentation/widgets/roomPower_widget.dart';
import 'package:office_application/features/Energy/services/energy_services.dart';
import 'package:office_application/features/rooms/data/models/room_model.dart';
import 'package:office_application/features/rooms/services/room_services.dart';

class EnergyScreen extends StatefulWidget {
  const EnergyScreen({super.key});

  @override
  State<EnergyScreen> createState() => _EnergyScreenState();
}

class _EnergyScreenState extends State<EnergyScreen> {
  double allPower = 0;
  double curr_power = 0;
  double today_kwh = 0;
  Map<int, double> room_power = {};
  Map<int, DateTime> lastReadingTime = {};
  List<RoomModel> rooms = [];
  DateTime? lastTime;
  ///////////////////////////////////////////////////
  ///GET ROOMS
  void _loadRooms() async {
    final data = await RoomServices().getAllrooms();
    if (!mounted) return;
    setState(() {
      rooms = data.map((map) => RoomModel.fromMap(map)).toList();
    });

    for (final room in rooms) {
      MqttServices().subscribe('office/room/${room.id}/power', (payload) {
        if (mounted) {
          final newPower = double.parse(payload);
          final now = DateTime.now();

          // double hoursDiff = 0;
          // if (lastReadingTime.containsKey(room.id)) {
          //   hoursDiff =
          //       now.difference(lastReadingTime[room.id]!).inMilliseconds /
          //       3600000;
          // }
          ///basedon allpower
          double hoursDiff = 0;
          if (lastTime != null) {
            hoursDiff = now.difference(lastTime!).inMilliseconds / 3600000;
          }
          final kwhIncrement = newPower * hoursDiff;
          lastReadingTime[room.id] = now;
          setState(() {
            room.powerKwh = newPower;
            curr_power = rooms
                .map((r) => r.powerKwh ?? 0)
                .reduce((a, b) => a + b);
            today_kwh += kwhIncrement;
          });

          EnergyServices().saveReading(
            EnergyReading(
              roomId: room.id,
              roomName: room.name,
              power: newPower,
              kwh: kwhIncrement,
            ),
          );
        }
      });
    }
  }

  ///////////////////////////////////////////
  //subscribe in power of all office
  void subscribeAllpower() async {
    await MqttServices().subscribe('office/home/power', (payload) {
      if (!mounted) return;
      setState(() {
        allPower = double.parse(payload);
      });
    });
  }

  ////////////////////////////////////////////////////////////////////////////
  void _loadTodayKwh() async {
    final total = await EnergyServices().getTodayTotal();
    if (!mounted) return;
    setState(() => today_kwh = total);
  }

  /////////////////////////////////////////////////////////////////////
  @override
  void initState() {
    //currPowerSubscribe();
    _loadRooms();
    subscribeAllpower();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Energy Usage'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: WidgetModels(
                      label: 'Live power',
                      // value: '${curr_power.toStringAsFixed(2)}  KWH',
                      value: '${allPower.toStringAsFixed(2)}  KWH',
                      //or will be Allpower
                      ////////////////////////////////////////////////////////
                    ),
                  ),
                  // SizedBox(width: 10),
                  // Expanded(
                  //   child: WidgetModels(
                  //     label: "Today's Usage",
                  //     value: '${today_kwh.toStringAsFixed(2)}  KWH',
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: rooms.length,
                itemBuilder: (context, index) => RoompowerWidget(
                  energy: EnergyReading(
                    roomId: rooms[index].id,
                    roomName: rooms[index].name,
                    power: rooms[index].powerKwh ?? 0,
                    kwh: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
