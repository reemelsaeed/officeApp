import 'package:office_application/core/models/models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EnergyServices {
  final supabase = Supabase.instance.client;

  Future<void> saveReading(EnergyReading reading) async {
    await supabase.from('energy_readings').insert(reading.toMap());
  }

  /////////////////////////////////////////////////////////////////////////////
  Future<double> getTodayTotal() async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);

    final response = await supabase
        .from('energy_readings')
        .select('kwh')
        .gte('created_at', startOfDay.toIso8601String());

    double total = 0;
    for (var row in response) {
      total += (row['kwh'] as num).toDouble();
    }
    return total;
  }

  /////////////////////////////////////////////////////////////////////////////////////////////
}
