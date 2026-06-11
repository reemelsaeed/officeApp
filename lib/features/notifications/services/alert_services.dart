import 'package:office_application/features/notifications/models/alert_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AlertServices {
  final supabase = Supabase.instance.client;

  Future<void> addAlerts(AlertModel alert) async {
    return await supabase.from('alerts').insert(alert.toMap());
  }

  ////////////////////////////////////
  Future<List<Map<String, dynamic>>> getAllalerts() async {
    return await supabase.from('alerts').select().limit(100);
  }
}
