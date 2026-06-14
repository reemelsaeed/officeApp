import 'package:flutter/material.dart';
import 'package:office_application/core/services/mqtt_service.dart';
import 'package:office_application/features/rooms/data/models/room_model.dart';
import 'package:office_application/features/rooms/presentation/screens/roomDetailes_screen.dart';

class RoomSummaryWidget extends StatefulWidget {
  RoomSummaryWidget({super.key, required this.roomModel});
  final RoomModel roomModel;
  @override
  State<RoomSummaryWidget> createState() => _RoomSummaryWidgetState();
}

class _RoomSummaryWidgetState extends State<RoomSummaryWidget> {
  double temp = 0;
  @override
  void initState() {
    MqttServices().subscribe(
      'office/room/${widget.roomModel.id}/sensors/temperature',
      (payload) {
        if (mounted) {
          setState(() {
            temp = double.parse(payload);
          });
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RoomdetailesScreen(roomModel: widget.roomModel),
        ),
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color.fromARGB(255, 219, 218, 218),
            width: 0.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  widget.roomModel.name,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                Spacer(),
                ////////////////////////will be from Esp//////////////////////////
                // Container(
                //   padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                //   decoration: BoxDecoration(
                //     color: widget.roomModel.status == room_state.Occupied
                //         ? Color(0xffFEF3C7)
                //         : Color(0xffD1FAE5),
                //     borderRadius: BorderRadius.circular(100),
                //   ),
                //   child: Text(
                //     widget.roomModel.status!.name ?? '',
                //     style: TextStyle(
                //       fontSize: 11,
                //       fontWeight: FontWeight.w500,
                //       color: widget.roomModel.status == room_state.Occupied
                //           ? Color(0xff92400E)
                //           : Color(0xff065F46),
                //     ),
                //   ),
                // ),
                ////////////////////////////////////////////////////////////////////
              ],
            ),
            SizedBox(height: 10),
            ////////////////////////////will be from ESP///////////////////////////////////
            Row(
              children: [
                Icon(Icons.thermostat, size: 14, color: Color(0xff1877F2)),
                SizedBox(width: 4),
                Text(
                  temp.toString(),
                  style: TextStyle(fontSize: 13, color: Color(0xff1877F2)),
                ),
              ],
            ),
            //////////////////////////////////////////////////////////////
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:office_application/features/rooms/data/models/room_model.dart';
// import 'package:office_application/features/rooms/presentation/screens/roomDetailes_screen.dart';

// class RoomSummaryWidget extends StatelessWidget {
//   const RoomSummaryWidget({super.key, required this.roomModel});
//   final RoomModel roomModel;

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () => Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => RoomdetailesScreen(roomModel: roomModel),
//         ),
//       ),
//       child: Container(
//         margin: EdgeInsets.only(bottom: 12),
//         padding: EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Color(0xffF2F2F2),
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Text(roomModel.name),
//                 Spacer(),
//                 ////////////////////////will be from Esp//////////////////////////
//                 Text(roomModel.status.name),
//                 ////////////////////////////////////////////////////////////////////
//               ],
//             ),
//             SizedBox(height: 10),
//             ////////////////////////////will be from ESP///////////////////////////////////
//             Text(roomModel.temperature.toString()),
//             //////////////////////////////////////////////////////////////
//           ],
//         ),
//       ),
//     );
//   }
// }
