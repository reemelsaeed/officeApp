import 'package:flutter/material.dart';
import 'package:office_application/core/dummy_data/dummyData.dart';
import 'package:office_application/features/dashboard/presentation/widgets/powerUsage_widget.dart';
import 'package:office_application/features/dashboard/presentation/widgets/room_summary_widget.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Welcome User'),
        actions: [
          IconButton(
            onPressed: () {
              //go to alert page//
            },
            icon: Icon(Icons.notifications),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            //power usage//
            PowerusageWidget(),
            SizedBox(height: 16),
            ///////////Rooms/////////
            Row(children: [Text('Rooms'), Spacer(), Text('see All')]),
            SizedBox(height: 12),
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
