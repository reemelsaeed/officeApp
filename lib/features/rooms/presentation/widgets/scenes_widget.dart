import 'package:flutter/material.dart';
import 'package:office_application/core/models/models.dart';

class ScenesWidget extends StatelessWidget {
  const ScenesWidget({
    super.key,
    required this.sceneModel,
    required this.onPlay,
  });
  final SceneModel sceneModel;
  final VoidCallback onPlay;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,

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
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xff4F8EF7).withOpacity(.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.play_lesson, color: Color(0xff4F8EF7)),
            ),
            const SizedBox(height: 8),
            Text(sceneModel.name),
            const Spacer(),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: onPlay,
                icon: const Icon(Icons.play_arrow),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
