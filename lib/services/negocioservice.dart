import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/negocio_model.dart'; // Ajusta la ruta según tu estructura

class NegocioService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final String table = 'negocio';

  Future<List<Negocio>> getNegocios() async {
    final data = await _supabase.from(table).select();

    return (data as List)
        .map((e) => Negocio.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> addNegocio(Negocio negocio) async {
    await _supabase.from(table).insert(negocio.toMap());
  }

  Future<void> updateNegocio(Negocio negocio) async {
    await _supabase
        .from(table)
        .update(negocio.toMap())
        .eq('id_negocio', negocio.idNegocio);
  }

  Future<void> deleteNegocio(int idNegocio) async {
    await _supabase.from(table).delete().eq('id_negocio', idNegocio);
  }
}
