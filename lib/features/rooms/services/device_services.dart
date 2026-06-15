import 'package:supabase_flutter/supabase_flutter.dart';

class DeviceServices {
  final supabase = Supabase.instance.client;

  Future<void> updateDevice(int deviceId, Map<String, dynamic> changes) async {
    await supabase.from('devices').update(changes).eq('id', deviceId);
  }
}
