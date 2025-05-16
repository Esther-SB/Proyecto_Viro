import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/actividad_model.dart';

class ActividadService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final String table = 'actividad';

  Future<List<Actividad>> getActividades() async {
    final data = await _supabase.from(table).select();
    return (data as List)
        .map((e) => Actividad.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> insertActividad(Actividad actividad) async {
    await _supabase.from(table).insert(actividad.toMap());
  }

  Future<void> updateActividad(Actividad actividad) async {
    await _supabase
        .from(table)
        .update(actividad.toMap())
        .eq('id', actividad.id);
  }

  Future<void> deleteActividad(int id) async {
    await _supabase.from(table).delete().eq('id', id);
  }
}
