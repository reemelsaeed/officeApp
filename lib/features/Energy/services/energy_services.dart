import 'package:office_application/core/models/models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EnergyServices {
  final supabase = Supabase.instance.client;

  Future<void> saveReading(EnergyReading reading) async {
    await supabase.from('energy_readings').insert(reading.toMap());
  }

  Future<double> getTodayTotal() async {
    final today = DateTime.now().toUtc();
    final startOfDay = DateTime.utc(today.year, today.month, today.day);

    final data = await supabase
        .from('energy_readings')
        .select('power')
        .gte('created_at', startOfDay.toIso8601String());

    if (data.isEmpty) return 0;

    return data
        .map((row) => (row['power'] as num).toDouble())
        .reduce((a, b) => a + b);
  }
}
