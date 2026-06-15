import 'package:flutter/material.dart';
import 'package:office_application/core/models/models.dart';
import 'package:office_application/features/rooms/presentation/screens/device_detailes_screen.dart';

class DeviceCard extends StatelessWidget {
  final DeviceModel device;
  bool isOn;
  final ValueChanged<bool> onToggle;

  DeviceCard({
    super.key,
    required this.device,
    required this.onToggle,
    required this.isOn,
  });

  @override
  Widget build(BuildContext context) {
    IconData _getIcon(DeviceType type) {
      switch (type) {
        case DeviceType.light:
          return Icons.lightbulb_outline;
        case DeviceType.ac:
          return Icons.ac_unit;
        case DeviceType.curtains:
          return Icons.blinds_outlined;
        case DeviceType.projector:
          return Icons.videocam_outlined;
        case DeviceType.socket:
          return Icons.power_outlined;
      }
    }

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DeviceDetailesScreen(device: device),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xff4F8EF7).withOpacity(.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getIcon(device.type),
                color: const Color(0xff4FC3F7),
                size: 22,
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: Text(device.name)),
                Spacer(),
                Switch(
                  value: isOn,
                  onChanged: onToggle,
                  activeColor: Colors.white,
                  activeTrackColor: const Color(0xff1877F2),
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: const Color(0xffE0E0E0),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
