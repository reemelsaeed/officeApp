import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:office_application/core/models/models.dart';
import 'package:office_application/core/services/mqtt_service.dart';
import 'package:office_application/features/rooms/services/device_services.dart';

class DeviceDetailesScreen extends StatefulWidget {
  const DeviceDetailesScreen({super.key, required this.device});
  final DeviceModel device;

  @override
  State<DeviceDetailesScreen> createState() => _DeviceDetailesScreenState();
}

class _DeviceDetailesScreenState extends State<DeviceDetailesScreen> {
  DeviceModel get device => widget.device;

  void _updateField(String key, dynamic value) {
    DeviceServices().updateDevice(device.id, {key: value});

    MqttServices().publish(
      'office/room/${device.roomId}/devices/${device.type.name}/command',
      jsonEncode({key: value}),
    );
  }

  @override
  void initState() {
    super.initState();
    MqttServices().subscribe(
      'office/room/${device.roomId}/devices/${device.type.name}/state',
      (payload) {
        if (mounted) {
          setState(() {
            device.isOn = payload == 'ON';
          });
        }
      },
    );
    // final cached = MqttServices().getCachedValue(
    //   'office/room/${device.roomId}/devices/${device.type.name}/state',
    // );
    // if (cached != null) {
    //   device.isOn = cached == 'ON';
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(device.name, style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            if (device.type == DeviceType.light) _lightControls(),
            if (device.type == DeviceType.ac) _acControls(),
            if (device.type == DeviceType.curtains) _curtainControls(),
          ],
        ),
      ),
    );
  }
  ///////////////////////////////////////////////////////////////////

  IconData _iconForType(DeviceType type) {
    switch (type) {
      case DeviceType.light:
        return Icons.lightbulb_outline;
      case DeviceType.ac:
        return Icons.ac_unit;
      case DeviceType.curtains:
        return Icons.curtains_closed_outlined;
      case DeviceType.projector:
        return Icons.videocam_outlined;
      case DeviceType.socket:
        return Icons.power_outlined;
    }
  }

  /////////////////////////////////////////////////////////////
  Widget _lightControls() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.brightness_6_outlined,
                size: 18,
                color: Color(0xFF9CA3AF),
              ),
              SizedBox(width: 8),
              Text('Brightness', style: TextStyle(fontWeight: FontWeight.w600)),
              Spacer(),
              Text(
                '${device.brightness.toInt()}%',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1877F2),
                ),
              ),
            ],
          ),
          Slider(
            value: device.brightness,
            min: 0,
            max: 100,
            divisions: 100,
            activeColor: Color(0xFF1877F2),
            onChanged: device.isOn
                ? (value) => setState(() => device.brightness = value)
                : null,
            onChangeEnd: device.isOn
                ? (value) => _updateField('brightness', value)
                : null,
          ),
        ],
      ),
    );
  }

  /////////////////////////////////////////////////////////////
  Widget _acControls() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.thermostat_outlined,
                size: 18,
                color: Color(0xFF9CA3AF),
              ),
              SizedBox(width: 8),
              Text(
                'Temperature',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Spacer(),
              Text(
                '${(device.temperature ?? 24).toStringAsFixed(0)}°C',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1877F2),
                ),
              ),
            ],
          ),
          Slider(
            value: device.temperature ?? 24,
            min: 16,
            max: 30,
            divisions: 14,
            activeColor: Color(0xFF1877F2),
            onChanged: device.isOn
                ? (value) => setState(() => device.temperature = value)
                : null,
            onChangeEnd: device.isOn
                ? (value) => _updateField('temperature', value)
                : null,
          ),

          const SizedBox(height: 12),
          Divider(color: Color(0xFFE5E7EB)),
          const SizedBox(height: 12),

          Text('Mode', style: TextStyle(fontWeight: FontWeight.w600)),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: AcMode.values.map((mode) {
              final selected = device.acMode == mode;
              return ChoiceChip(
                label: Text(mode.name),
                selected: selected,
                selectedColor: Color(0xFF1877F2),
                labelStyle: TextStyle(
                  color: selected ? Colors.white : Color(0xFF374151),
                  fontWeight: FontWeight.w500,
                ),
                backgroundColor: Color(0xFFF3F4F6),
                onSelected: device.isOn
                    ? (_) {
                        setState(() => device.acMode = mode);
                        _updateField('ac_mode', mode.name);
                      }
                    : null,
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          Text('Fan Speed', style: TextStyle(fontWeight: FontWeight.w600)),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: AcFanSpeed.values.map((speed) {
              final selected = device.acFanSpeed == speed;
              return ChoiceChip(
                label: Text(speed.name),
                selected: selected,
                selectedColor: Color(0xFF1877F2),
                labelStyle: TextStyle(
                  color: selected ? Colors.white : Color(0xFF374151),
                  fontWeight: FontWeight.w500,
                ),
                backgroundColor: Color(0xFFF3F4F6),
                onSelected: device.isOn
                    ? (_) {
                        setState(() => device.acFanSpeed = speed);
                        _updateField('ac_fan_speed', speed.name);
                      }
                    : null,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  /////////////////////////////////////////////////////////////
  Widget _curtainControls() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.curtains_closed_outlined,
                size: 18,
                color: Color(0xFF9CA3AF),
              ),
              SizedBox(width: 8),
              Text('Position', style: TextStyle(fontWeight: FontWeight.w600)),
              Spacer(),
              Text(
                device.curtainStatus ?? 'Closed',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1877F2),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: Icon(Icons.arrow_upward, size: 18),
                  label: Text('Open'),
                  onPressed: () {
                    setState(() => device.curtainStatus = 'Open');
                    _updateField('curtain_status', 'Open');
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  icon: Icon(Icons.pause, size: 18),
                  label: Text('Stop'),
                  onPressed: () {
                    setState(() => device.curtainStatus = 'Stopped');
                    _updateField('curtain_status', 'Stopped');
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  icon: Icon(Icons.arrow_downward, size: 18),
                  label: Text('Close'),
                  onPressed: () {
                    setState(() => device.curtainStatus = 'Closed');
                    _updateField('curtain_status', 'Closed');
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
