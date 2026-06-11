import 'package:flutter/material.dart';

class PowerusageWidget extends StatelessWidget {
  const PowerusageWidget({super.key, required this.power});

  final double power;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: Color(0xff1877F2),
      ),
      child: Row(
        children: [
          Icon(Icons.bolt, color: Color.fromARGB(255, 234, 180, 1), size: 20),
          SizedBox(width: 8),
          Text(
            'Power Usage',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          Spacer(),
          ///////////////////// will be a number from ESP32///////////////////////////////
          Text(
            '${power.toString()} KW',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          /////////////////////////////////////////////////////////////////////////////////
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';

// class PowerusageWidget extends StatelessWidget {
//   const PowerusageWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(100),
//         color: Color(0xff1877F2),
//       ),
//       child: Row(
//         children: [
//           Icon(Icons.power),
//           SizedBox(width: 4),
//           Text('Power Usage'),
//           Spacer(),
//           ///////////////////// will be a number from ESP32///////////////////////////////
//           Text('14.5 KW'),
//           /////////////////////////////////////////////////////////////////////////////////
//         ],
//       ),
//     );
//   }
// }
