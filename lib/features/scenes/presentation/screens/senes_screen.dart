import 'package:flutter/material.dart';
import 'package:office_application/core/models/models.dart';
import 'package:office_application/core/services/mqtt_service.dart';
import 'package:office_application/features/scenes/presentation/widgets/scene_card_widget.dart';
import 'package:office_application/features/scenes/services/scenes_services.dart';

class SenesScreen extends StatefulWidget {
  const SenesScreen({super.key});
  @override
  State<SenesScreen> createState() => _SenesScreenState();
}

class _SenesScreenState extends State<SenesScreen> {
  List<SceneModel> _scenes = [];
  Set<int> _pendingScenes = {};
  @override
  void initState() {
    _loadScenes();
    super.initState();
  }

  void _loadScenes() async {
    final data = await ScenesServices().getAllscenes();
    setState(() {
      _scenes = data.map((map) => SceneModel.fromMap(map)).toList();
    });
  }

  Set<int> _activeScenes = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, title: Text('Scenes')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  childAspectRatio: .75,
                  mainAxisSpacing: 16,
                ),
                itemCount: _scenes.length,
                itemBuilder: (context, index) {
                  return SceneCardWidget(
                    scene: _scenes[index],
                    isActive: _activeScenes.contains(index),
                    isPending: _pendingScenes.contains(index),
                    onPlay: () {
                      final isActive = _activeScenes.contains(index);
                      setState(() {
                        _pendingScenes.add(index);
                      });
                      for (final device in _scenes[index].devices) {
                        MqttServices().publish(
                          'office/room/${_scenes[index].roomId}/devices/${device.type.name}/command',
                          isActive ? 'OFF' : 'ON',
                        );
                      }

                      Future.delayed(Duration(seconds: 3), () {
                        if (mounted) {
                          setState(() {
                            _pendingScenes.remove(index);
                            if (isActive) {
                              _activeScenes.remove(index);
                            } else {
                              _activeScenes.add(index);
                            }
                          });
                        }
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
