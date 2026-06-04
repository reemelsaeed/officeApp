import 'package:flutter/material.dart';
import 'package:office_application/core/dummy_data/dummyData.dart';
import 'package:office_application/features/dashboard/presentation/widgets/room_summary_widget.dart';

class RoomsScreen extends StatelessWidget {
  const RoomsScreen({super.key});

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
                itemCount: allRooms.length,
                itemBuilder: (context, index) =>
                    RoomSummaryWidget(roomModel: allRooms[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
