import 'package:flutter/material.dart';
import 'package:office_application/features/notifications/models/alert_model.dart';
import 'package:intl/intl.dart';

class AlertWidget extends StatelessWidget {
  const AlertWidget({super.key, required this.alert});
  final AlertModel alert;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(alert.alertContent),
          SizedBox(height: 12),
          Text(
            DateFormat(
              'hh:mm a, dd MMM',
              //'dd MMM, hh:mm a',
            ).format(DateTime.parse(alert.createdAt)),
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
