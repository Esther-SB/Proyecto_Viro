import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/empleado.dart';

class EmpleadoService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final String table = 'empleado';

  Future<List<Empleado>> getEmpleados() async {
    final data = await _supabase.from(table).select();
    return (data as List)
        .map((e) => Empleado.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> insertEmpleado(Empleado empleado) async {
    await _supabase.from(table).insert(empleado.toMap());
  }

  Future<void> deleteEmpleado(int idUsuario) async {
    await _supabase.from(table).delete().eq('id_usuario', idUsuario);
  }
}
