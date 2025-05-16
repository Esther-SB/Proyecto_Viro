import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart'; // Ajusta la ruta según tu estructura

class UsuarioService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<Usuario>> getUsuarios() async {
    final response = await _client.from('usuario').select();
    return (response as List)
        .map((e) => Usuario.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  Future<Usuario?> getUsuarioPorId(int id) async {
    final response =
        await _client.from('usuario').select().eq('id', id).maybeSingle();

    if (response == null) return null;
    return Usuario.fromMap(response);
  }

  Future<Usuario?> getUsuarioPorAuthId(String authId) async {
    final response =
        await _client.from('usuario').select().eq('auth_id', authId).maybeSingle();

    if (response == null) return null;
    return Usuario.fromMap(response);
  }

  Future<void> crearUsuario(Usuario usuario) async {
    final userData = <String, dynamic>{
      'nombre': usuario.nombre,
      'apellidos': usuario.apellidos,
      'nombre_usuario': usuario.nombreUsuario,
      'telefono': usuario.telefono,
      'correo': usuario.correo,
      'dni': usuario.dni,
    };
    
    if (usuario.authId != null) {
      userData['auth_id'] = usuario.authId!;
    }
    
    await _client.from('usuario').insert(userData);
  }

  Future<void> actualizarUsuario(Usuario usuario) async {
    final userData = <String, dynamic>{
      'nombre': usuario.nombre,
      'apellidos': usuario.apellidos,
      'nombre_usuario': usuario.nombreUsuario,
      'telefono': usuario.telefono,
      'correo': usuario.correo,
      'dni': usuario.dni,
    };
    
    if (usuario.authId != null) {
      userData['auth_id'] = usuario.authId.toString();
    }
    
    await _client.from('usuario').update(userData).eq('id', usuario.id);
  }

  Future<void> actualizarAuthId(String id, String authId) async {
    await _client.from('usuario').update({'auth_id': authId}).eq('id', id);
  }

  Future<void> eliminarUsuario(int id) async {
    await _client.from('usuario').delete().eq('id', id);
  }
}
