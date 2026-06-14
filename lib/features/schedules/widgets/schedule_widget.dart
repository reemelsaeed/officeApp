import 'package:flutter/material.dart';
import 'package:office_application/core/models/models.dart';

class ScheduleWidget extends StatelessWidget {
  const ScheduleWidget({
    super.key,
    required this.scheduleModel,
    required this.onToggle,
    required this.isOn,
    required this.deletSchedule,
    required this.editSchedule,
  });
  final ScheduleModel scheduleModel;
  final ValueChanged<bool> onToggle;
  final bool isOn;
  final VoidCallback deletSchedule;
  final VoidCallback editSchedule;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xff4F8EF7).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.devices_other_rounded,
                  color: const Color(0xff4F8EF7),
                  size: 20,
                ),
              ),
              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      scheduleModel.deviceName,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color.fromARGB(255, 46, 46, 46),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 12,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${scheduleModel.time}  • ${scheduleModel.state} •  ${scheduleModel.repeatRule}',
                          style: TextStyle(
                            fontSize: 12,
                            color: const Color.fromARGB(255, 139, 138, 138),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Switch(
                value: isOn,
                onChanged: onToggle,
                activeColor: Colors.white,
                activeTrackColor: const Color(0xff4F8EF7),
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: Colors.grey.shade200,
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Text(scheduleModel.roomName),
              Spacer(),
              IconButton(
                onPressed: deletSchedule,
                icon: Icon(Icons.delete, color: Colors.red, size: 20),
              ),
              //SizedBox(width: 2),
              IconButton(
                onPressed: editSchedule,
                icon: Icon(Icons.edit_outlined, color: Colors.grey, size: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
