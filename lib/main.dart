import 'package:flutter/material.dart';
import 'package:office_application/core/services/mqtt_service.dart';
import 'package:office_application/features/Energy/presentation/screens/energy_screen.dart';
import 'package:office_application/features/dashboard/presentation/screens/home_screen.dart';
import 'package:office_application/features/rooms/presentation/screens/rooms_screen.dart';
import 'package:office_application/features/scenes/presentation/screens/senes_screen.dart';
import 'package:office_application/features/schedules/schedule_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://qwooepccesesqfqtjzib.supabase.co',
    anonKey: 'sb_publishable_ZAIc76Ga8utlobNjsjLqoQ_NYwUJuvB',
  );
  await MqttServices().connect();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MainShell(), debugShowCheckedModeBanner: false);
  }
}

/////////////////////////////////////////////////////////////////
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    HomeScreen(),
    RoomsScreen(),
    EnergyScreen(),
    SenesScreen(),
    ScheduleScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          selectedItemColor: const Color(0xFF1877F2),
          unselectedItemColor: const Color(0xFF607D8B),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_outlined),
              activeIcon: Icon(Icons.grid_view),
              label: 'Rooms',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bolt),
              activeIcon: Icon(Icons.bolt),
              label: 'Energy',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.layers),
              activeIcon: Icon(Icons.layers),
              label: 'Scenes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.schedule),
              activeIcon: Icon(Icons.schedule),
              label: 'Schedual',
            ),
          ],
        ),
      ),
    );
  }
}
