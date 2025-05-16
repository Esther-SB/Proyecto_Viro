// Modelo de usuario
class Usuario {
  final int id;
  final String nombre;
  final String apellidos;
  final String nombreUsuario;
  final String contrasena;
  final String telefono;
  final String correo;
  final String dni;
  final String? authId;

  Usuario({
    required this.id,
    required this.nombre,
    required this.apellidos,
    required this.nombreUsuario,
    required this.contrasena,
    required this.telefono,
    required this.correo,
    required this.dni,
    this.authId,
  });

  // Método para crear un usuario desde un mapa
  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'] is int ? map['id'] : int.tryParse(map['id'].toString()) ?? 0,
      nombre: map['nombre'] ?? '',
      apellidos: map['apellidos'] ?? '',
      nombreUsuario: map['nombre_usuario'] ?? '',
      contrasena: map['contrasena'] ?? '',
      telefono: map['telefono'] ?? '',
      correo: map['correo'] ?? '',
      dni: map['dni'] ?? '',
      authId: map['auth_id']?.toString(),
    );
  }

  // Método para convertir el usuario a un mapa
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'id': id,
      'nombre': nombre,
      'apellidos': apellidos,
      'nombre_usuario': nombreUsuario,
      'telefono': telefono,
      'correo': correo,
      'dni': dni,
    };
    
    if (authId != null) {
      map['auth_id'] = authId.toString();
    }
    
    return map;
  }

  // Método para crear una copia del usuario con algunos campos modificados
  Usuario copyWith({
    int? id,
    String? nombre,
    String? apellidos,
    String? nombreUsuario,
    String? contrasena,
    String? telefono,
    String? correo,
    String? dni,
    String? authId,
  }) {
    return Usuario(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      apellidos: apellidos ?? this.apellidos,
      nombreUsuario: nombreUsuario ?? this.nombreUsuario,
      contrasena: contrasena ?? this.contrasena,
      telefono: telefono ?? this.telefono,
      correo: correo ?? this.correo,
      dni: dni ?? this.dni,
      authId: authId ?? this.authId,
    );
  }
}
