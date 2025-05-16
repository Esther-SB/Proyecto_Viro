import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/ruta_model.dart';

class RutaService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final String table = 'ruta';

  Future<List<Ruta>> getRutas() async {
    final data = await _supabase.from(table).select();
    return (data as List)
        .map((e) => Ruta.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> insertRuta(Ruta ruta) async {
    await _supabase.from(table).insert(ruta.toMap());
  }

  Future<void> updateRuta(Ruta ruta) async {
    await _supabase.from(table).update(ruta.toMap()).eq('id_ruta', ruta.idRuta);
  }

  Future<void> deleteRuta(int idRuta) async {
    await _supabase.from(table).delete().eq('id_ruta', idRuta);
  }
}
