import 'package:supabase_flutter/supabase_flutter.dart';

class RoomServices {
  final supabase = Supabase.instance.client;

  //function to get all rooms
  Future<List<Map<String, dynamic>>> getAllrooms() async {
    return await supabase.from('rooms').select();
  }

  //function to get room devices
  Future<List<Map<String, dynamic>>> getDevices(int roomId) async {
    return await supabase.from('devices').select().eq('room_id', roomId);
  }

  ///////function to get room scenes
  Future<List<Map<String, dynamic>>> getScenes(int roomId) async {
    return await supabase.from('scenes').select().eq('room_id', roomId);
  }
}
