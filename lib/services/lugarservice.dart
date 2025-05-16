import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/lugar_model.dart';

class LugarService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final String table = 'lugar';

  Future<List<Lugar>> getLugares() async {
    final data = await _supabase.from(table).select();
    return (data as List)
        .map((e) => Lugar.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> insertLugar(Lugar lugar) async {
    await _supabase.from(table).insert(lugar.toMap());
  }

  Future<void> updateLugar(Lugar lugar) async {
    await _supabase.from(table).update(lugar.toMap()).eq('id', lugar.id);
  }

  Future<void> deleteLugar(int id) async {
    await _supabase.from(table).delete().eq('id', id);
  }
}
