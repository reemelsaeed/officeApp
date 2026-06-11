import 'package:flutter/material.dart';
import 'package:office_application/core/models/models.dart';
import 'package:office_application/features/scenes/presentation/screens/scene_detailes_screen.dart';

class SceneCardWidget extends StatelessWidget {
  const SceneCardWidget({super.key, required this.scene, required this.onPlay});
  final SceneModel scene;
  final VoidCallback onPlay;

  IconData get _sceneIcon {
    final name = scene.name.toLowerCase();
    if (name.contains('meeting')) return Icons.groups_outlined;
    if (name.contains('presentation')) return Icons.present_to_all_outlined;
    if (name.contains('off')) return Icons.power_settings_new;
    if (name.contains('sleep')) return Icons.bedtime_outlined;
    return Icons.tune_outlined;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SceneDetailesScreen(scene: scene),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color.fromARGB(255, 223, 223, 223),
            width: 0.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF1877F2).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(_sceneIcon, size: 20, color: const Color(0xFF1877F2)),
            ),
            const SizedBox(height: 12),
            // اسم السين
            Text(
              scene.name,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),

            Text(
              '${scene.devices.length} devices',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            ),
            const Spacer(),
            Row(
              children: [
                Text(
                  scene.roomName,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: onPlay,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Color(0xFF1877F2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.play_arrow,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
