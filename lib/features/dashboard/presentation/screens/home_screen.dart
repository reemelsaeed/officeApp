import 'package:flutter/material.dart';
import 'package:office_application/core/models/models.dart';
import 'package:office_application/core/services/mqtt_service.dart';
import 'package:office_application/features/Energy/presentation/widgets/widget_models.dart';
import 'package:office_application/features/Energy/services/energy_services.dart';
import 'package:office_application/features/authentications/presentation/screens/user_profile_screen.dart';
import 'package:office_application/features/dashboard/presentation/widgets/powerUsage_widget.dart';
import 'package:office_application/features/dashboard/presentation/widgets/room_summary_widget.dart';
import 'package:office_application/features/notifications/models/alert_model.dart';
import 'package:office_application/features/notifications/notifications_screen.dart';
import 'package:office_application/features/notifications/services/alert_services.dart';
import 'package:office_application/features/notifications/widgets/alert_widget.dart';
import 'package:office_application/features/rooms/data/models/room_model.dart';
import 'package:office_application/features/rooms/presentation/screens/rooms_screen.dart';
import 'package:office_application/features/rooms/services/room_services.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double power = 0;
  List<RoomModel> rooms = [];

  @override
  void initState() {
    loadAlerts();
    loadrooms();
    super.initState();
    MqttServices().subscribe('office/home/power', (payload) {
      if (mounted) {
        setState(() {
          power = double.parse(payload);
        });
      }
    });
    /////////////////////////////////////////////////////////////////
  }

  void loadrooms() async {
    final data = await RoomServices().getAllrooms();
    rooms = data.map((r) => RoomModel.fromMap(r)).take(5).toList();
    for (final room in rooms) {
      MqttServices().subscribe('office/room/${room.id}/power', (payload) {
        if (mounted) {
          setState(() {
            room.powerKwh = double.parse(payload);
            power = rooms.map((r) => r.powerKwh ?? 0).reduce((a, b) => a + b);
            EnergyServices().saveReading(
              EnergyReading(
                roomId: room.id,
                roomName: room.name,
                power: double.parse(payload),
                kwh: 0,
              ),
            );
          });
        }
      });
    }
  }

  List<AlertModel> alerts = [];
  ///////
  void loadAlerts() async {
    final data = await AlertServices().getAllalerts();
    if (!mounted) return;
    setState(() {
      alerts = data.map((map) => AlertModel.fromMap(map)).take(3).toList();
    });
    MqttServices().subscribe('office/alerts', (payload) async {
      final newAlert = AlertModel(
        alertContent: payload,
        createdAt: DateTime.now().toString(),
      );
      await AlertServices().addAlerts(newAlert);
      if (!mounted) return;
      setState(() {
        alerts.add(newAlert);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Welcome User',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF111827),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UserProfileScreen()),
            ),
            child: Container(
              margin: EdgeInsets.only(right: 8),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.person, size: 20, color: Color(0xFF1877F2)),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NotificationsScreen()),
            ),
            child: Container(
              margin: EdgeInsets.only(right: 16),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.notifications,
                size: 20,
                color: Color.fromARGB(255, 234, 180, 1),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //power usage//
              WidgetModels(
                label: 'Live power',
                ///////////////from ESP//////////////////////
                value: '${power.toStringAsFixed(2)}  KWH',
                ////////////////////////////////////////////////////////
              ),

              SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    'Recent Alerts',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotificationsScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'see all',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.lightBlue,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: alerts.length,
                itemBuilder: (context, index) =>
                    AlertWidget(alert: alerts[index]),
              ),
              SizedBox(height: 16),
              ///////////Rooms/////////
              Row(
                children: [
                  Text(
                    'Rooms',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RoomsScreen()),
                      );
                    },
                    child: Text(
                      'see all',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.lightBlue,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: rooms.length,
                itemBuilder: (context, index) =>
                    RoomSummaryWidget(roomModel: rooms[index]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
