import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/ciudadano_realiza_ruta_model.dart';

class CiudadanoRealizaRutaService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final String table = 'ciudadano_realiza_ruta';

  Future<List<CiudadanoRealizaRuta>> getAll() async {
    final data = await _supabase.from(table).select();
    return (data as List)
        .map((e) => CiudadanoRealizaRuta.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> insert(CiudadanoRealizaRuta entry) async {
    await _supabase.from(table).insert(entry.toMap());
  }

  Future<void> delete(int idUsuario, int idRuta) async {
    await _supabase.from(table).delete().match({
      'id_usuario': idUsuario,
      'id_ruta': idRuta,
    });
  }

  Future<void> update(CiudadanoRealizaRuta entry) async {
    await _supabase.from(table).update(entry.toMap()).match({
      'id_usuario': entry.idUsuario,
      'id_ruta': entry.idRuta,
    });
  }
}
