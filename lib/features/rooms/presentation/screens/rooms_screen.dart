import 'package:flutter/material.dart';
import 'package:office_application/core/dummy_data/dummyData.dart';
import 'package:office_application/features/dashboard/presentation/widgets/room_summary_widget.dart';
import 'package:office_application/features/rooms/data/models/room_model.dart';
import 'package:office_application/features/rooms/services/room_services.dart';

class RoomsScreen extends StatefulWidget {
  const RoomsScreen({super.key});

  @override
  State<RoomsScreen> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> {
  List<RoomModel> rooms = [];

  void _loadrooms() async {
    final data = await RoomServices().getAllrooms();
    setState(() {
      rooms = data.map((map) {
        final dummyRoom = allRooms.firstWhere(
          (r) => r.id == map['id'],
          orElse: () => RoomModel(
            id: map['id'],
            name: map['name'],
            status: room_state.available,
          ),
        );
        return RoomModel(
          id: map['id'],
          name: map['name'],
          status: room_state.available,
          sensors: dummyRoom.sensors,
        );
      }).toList();
    });
  }

  @override
  void initState() {
    _loadrooms();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('Rooms'), backgroundColor: Colors.white),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: rooms.length,
                itemBuilder: (context, index) =>
                    RoomSummaryWidget(roomModel: rooms[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
