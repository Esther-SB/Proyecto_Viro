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

  Future<List<Lugar>> getLugaresPorRuta(int idRuta) async {
    final data = await _supabase
        .from(table)
        .select()
        .eq('id_ruta', idRuta);
    return (data as List)
        .map((e) => Lugar.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> insertLugar(Lugar lugar) async {
    await _supabase.from(table).insert(lugar.toMap());
  }

  Future<void> insertLugarAlemania() async {
    // Verificar si el lugar ya existe
    final lugares = await getLugares();
    final lugarExistente = lugares.any((l) => 
      l.nombre == 'Calle Alemania 10' && 
      l.latitud == 39.4675 && 
      l.longitud == -0.3764
    );

    if (!lugarExistente) {
      final lugar = Lugar(
        id: 0,
        tipo: 'tienda',
        nombre: 'Calle Alemania 10',
        idRuta: 1,
        latitud: 39.4675,
        longitud: -0.3764,
      );
      await insertLugar(lugar);
    }
  }

  Future<void> updateLugar(Lugar lugar) async {
    await _supabase.from(table).update(lugar.toMap()).eq('id', lugar.id);
  }

  Future<void> deleteLugar(int id) async {
    await _supabase.from(table).delete().eq('id', id);
  }
} 