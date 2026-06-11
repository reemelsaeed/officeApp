import 'package:supabase_flutter/supabase_flutter.dart';

class ScenesServices {
  final supabase = Supabase.instance.client;

  //function to get all rooms
  Future<List<Map<String, dynamic>>> getAllscenes() async {
    final data = await supabase
        .from('scenes')
        .select('*, rooms(name), scene_devices(*, devices(*))');
    return data;
  }

  Future<List<Map<String, dynamic>>> getsceneDevices(int roomId) async {
    return await supabase.from('devices').select().eq('room_id', roomId);
  }
}
