class Lugar {
  final int id;
  final String tipo;
  final String nombre;
  final int idRuta;
  final double latitud;
  final double longitud;

  Lugar({
    required this.id,
    required this.tipo,
    required this.nombre,
    required this.idRuta,
    required this.latitud,
    required this.longitud,
  });

  // Método para crear un lugar desde un mapa
  factory Lugar.fromMap(Map<String, dynamic> map) {
    return Lugar(
      id: map['id'] as int,
      tipo: map['tipo'] as String,
      nombre: map['nombre'] as String,
      idRuta: map['id_ruta'] as int,
      latitud: (map['latitud'] as num).toDouble(),
      longitud: (map['longitud'] as num).toDouble(),
    );
  }

  // Método para convertir el usuario a un mapa
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tipo': tipo,
      'nombre': nombre,
      'id_ruta': idRuta,
      'latitud': latitud,
      'longitud': longitud,
    };
  }

  // Método para crear una copia del usuario con algunos campos modificados
  Lugar copyWith({
    int? id,
    String? tipo,
    String? nombre,
    int? idRuta,
    double? latitud,
    double? longitud,
  }) {
    return Lugar(
      id: id ?? this.id,
      tipo: tipo ?? this.tipo,
      nombre: nombre ?? this.nombre,
      idRuta: idRuta ?? this.idRuta,
      latitud: latitud ?? this.latitud,
      longitud: longitud ?? this.longitud,
    );
  }
}
