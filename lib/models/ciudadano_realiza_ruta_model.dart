class CiudadanoRealizaRuta {
  final int idUsuario;
  final int idRuta;


  CiudadanoRealizaRuta({
    required this.idUsuario,
    required this.idRuta,
  });

  // Método para crear un usuario desde un mapa (útil para Firebase)
  factory CiudadanoRealizaRuta.fromMap(Map<String, dynamic> map) {
    return CiudadanoRealizaRuta(
      idUsuario: map['id_usuario'] is int
          ? map['id_usuario']
          : int.tryParse(map['id_usuario'].toString()) ?? 0,
      idRuta: map['id_ruta'] is int
          ? map['id_ruta']
          : int.tryParse(map['id_ruta'].toString()) ?? 0,
    );
  }

  // Método para convertir el usuario a un mapa
  Map<String, dynamic> toMap() {
    return {
      'id_usuario': idUsuario,
      'id_ruta': idRuta,
    };
  }

  // Método para crear una copia del usuario con algunos campos modificados
  CiudadanoRealizaRuta copyWith({
    int? idUsuario,
    int? idRuta,
  }) {
    return CiudadanoRealizaRuta(
      idUsuario: idUsuario ?? this.idUsuario,
      idRuta: idRuta ?? this.idRuta,
    );
  }
}
