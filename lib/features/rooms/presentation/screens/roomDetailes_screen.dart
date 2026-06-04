import 'package:flutter/material.dart';
import 'package:office_application/features/rooms/data/models/room_model.dart';
import 'package:office_application/features/rooms/presentation/widgets/deviceCard_widget.dart';
import 'package:office_application/features/rooms/presentation/widgets/header_widget.dart';

class RoomdetailesScreen extends StatelessWidget {
  const RoomdetailesScreen({super.key, required this.roomModel});
  final RoomModel roomModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Text(roomModel.name),
            Spacer(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: roomModel.status == room_state.Occupied
                    ? Color(0xffFEF3C7)
                    : Color(0xffD1FAE5),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                roomModel.status.name,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: roomModel.status == room_state.Occupied
                      ? Color(0xff92400E)
                      : Color(0xff065F46),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            HeaderWidget(roomModel: roomModel),
            SizedBox(height: 16),

            Row(children: [Text('Devices'), Spacer(), Text('See all')]),
            SizedBox(height: 16),

            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1,
                ),
                itemCount: roomModel.devices?.length ?? 0,
                itemBuilder: (context, index) => DeviceCard(
                  device: roomModel.devices![index],
                  onToggle: (bool value) {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
