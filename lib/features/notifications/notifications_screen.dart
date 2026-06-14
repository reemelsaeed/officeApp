import 'package:flutter/material.dart';
import 'package:office_application/core/services/mqtt_service.dart';
import 'package:office_application/features/notifications/models/alert_model.dart';
import 'package:office_application/features/notifications/services/alert_services.dart';
import 'package:office_application/features/notifications/widgets/alert_widget.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<AlertModel> alerts = [];
  @override
  void initState() {
    loadAlerts();
    super.initState();
  }

  ///////
  void loadAlerts() async {
    final data = await AlertServices().getAllalerts();
    if (!mounted) return;
    setState(() {
      alerts = data
          .map((map) => AlertModel.fromMap(map))
          .toList()
          .reversed
          .toList();
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
      appBar: AppBar(title: Text('Alerts'), backgroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: alerts.length,
                itemBuilder: (context, index) {
                  return AlertWidget(alert: alerts[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
