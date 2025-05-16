class Ciudadano {
  final int idUsuario;
  final int puntos;
  final String idMetro;
  final String idTren;
  final String idBus;

  Ciudadano({
    required this.idUsuario,
    required this.puntos,
    required this.idMetro,
    required this.idTren,
    required this.idBus,
  });

  // Método para crear un usuario desde un mapa (útil para Firebase)
  factory Ciudadano.fromMap(Map<String, dynamic> map) {
    return Ciudadano(
      idUsuario: map['id_usuario'] is int
          ? map['id_usuario']
          : int.tryParse(map['id_usuario'].toString()) ?? 0,
      puntos: map['puntos'] is int
          ? map['puntos']
          : int.tryParse(map['puntos'].toString()) ?? 0,
      idMetro: map['id_metro'] ?? '',
      idTren: map['id_tren'] ?? '',
      idBus: map['id_bus'] ?? '',
    );
  }

  // Método para convertir el usuario a un mapa
  Map<String, dynamic> toMap() {
    return {
      'id_usuario': idUsuario,
      'puntos': puntos,
      'id_metro': idMetro,
      'id_tren': idTren,
      'id_bus': idBus,
    };
  }

  // Método para crear una copia del usuario con algunos campos modificados
  Ciudadano copyWith({
    int? idUsuario,
    int? puntos,
    String? idMetro,
    String? idTren,
    String? idBus,
  }) {
    return Ciudadano(
      idUsuario: idUsuario ?? this.idUsuario,
      puntos: puntos ?? this.puntos,
      idMetro: idMetro ?? this.idMetro,
      idTren: idTren ?? this.idTren,
      idBus: idBus ?? this.idBus,
    );
  }
}
