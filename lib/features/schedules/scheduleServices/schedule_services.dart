import 'package:office_application/core/models/models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ScheduleServices {
  final supabase = Supabase.instance.client;

  //////////////////////////get all schedules
  Future<List<Map<String, dynamic>>> getAllSchedules() async {
    return await supabase
        .from('Schedules')
        .select('*, rooms!Schedules_room_id_fkey(name)');
  }

  ////////////////////addSchedule///////////////////////////////////
  Future<void> addSchedule(ScheduleModel schedule) async {
    await supabase.from('Schedules').insert(schedule.toMap());
  }

  /////////////////////////////////////////////////////////
  //delete Schedule
  Future<void> deleteSchedule(int id) async {
    await supabase.from('Schedules').delete().eq('id', id);
  }

  ///////////////////////////////////////////////////
  Future<void> editSchedule(int id, ScheduleModel schedule) async {
    await supabase.from('Schedules').update(schedule.toMap()).eq('id', id);
  }

  ////////////////////////////////////////////
  Future<List<Map<String, dynamic>>> getAllDevices() async {
    return await supabase.from('devices').select();
  }

  Future<List<Map<String, dynamic>>> getAllrooms() async {
    return await supabase.from('rooms').select();
  }

  Future<List<Map<String, dynamic>>> getroomById(int id) async {
    return await supabase.from('rooms').select().eq('id', id);
  }

  Future<List<Map<String, dynamic>>> getDevicesByRoom(int roomId) async {
    return await supabase.from('devices').select().eq('room_id', roomId);
  }
}
