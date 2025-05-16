import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/ciudadano_model.dart';

class CiudadanoService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final String table = 'ciudadanos';

  Future<List<Ciudadano>> getCiudadanos() async {
    final data = await _supabase.from(table).select();
    return (data as List)
        .map((e) => Ciudadano.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> insertCiudadano(Ciudadano ciudadano) async {
    await _supabase.from(table).insert(ciudadano.toMap());
  }

  Future<void> updateCiudadano(Ciudadano ciudadano) async {
    await _supabase
        .from(table)
        .update(ciudadano.toMap())
        .eq('id_usuario', ciudadano.idUsuario);
  }

  Future<void> deleteCiudadano(int idUsuario) async {
    await _supabase.from(table).delete().eq('id_usuario', idUsuario);
  }
}
