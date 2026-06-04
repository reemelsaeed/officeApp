import 'package:flutter/material.dart';
import 'package:office_application/core/models/models.dart';

class DeviceCard extends StatelessWidget {
  final DeviceModel device;
  final ValueChanged<bool> onToggle;

  const DeviceCard({super.key, required this.device, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: icon + optional status/temp
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _DeviceIcon(type: device.type),
              _TopRightInfo(device: device),
            ],
          ),

          const Spacer(),

          // Bottom Row: name + toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                device.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Switch(
                value: device.isOn,
                onChanged: onToggle,
                activeColor: Colors.white,
                activeTrackColor: const Color(0xff1877F2),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DeviceIcon extends StatelessWidget {
  final DeviceType type;
  const _DeviceIcon({required this.type});

  IconData get icon => switch (type) {
    DeviceType.light => Icons.lightbulb_outline,
    DeviceType.ac => Icons.ac_unit,
    DeviceType.curtains => Icons.blinds_outlined,
    DeviceType.projector => Icons.video_camera_back_outlined,
    DeviceType.socket => Icons.power_outlined,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xffE8F0FE),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: const Color(0xff1877F2), size: 20),
    );
  }
}

class _TopRightInfo extends StatelessWidget {
  final DeviceModel device;
  const _TopRightInfo({required this.device});

  @override
  Widget build(BuildContext context) {
    if (device.temperature != null) {
      return Text(
        '${device.temperature!.toInt()}°',
        style: const TextStyle(fontSize: 18, color: Colors.grey),
      );
    }
    if (device.curtainStatus != null) {
      return Text(
        device.curtainStatus!,
        style: const TextStyle(fontSize: 13, color: Colors.grey),
      );
    }
    return const SizedBox.shrink();
  }
}
