class Ruta {
  final int idRuta;
  final int km;
  final int puntosRuta;

  Ruta({
    required this.idRuta,
    required this.km,
    required this.puntosRuta,
  });

  // Método para crear una ruta desde un mapa
  factory Ruta.fromMap(Map<String, dynamic> map) {
    return Ruta(
      idRuta: map['id_ruta'] is int
          ? map['id_ruta']
          : int.tryParse(map['id_ruta'].toString()) ?? 0,
      km: map['km'] is int
          ? map['km']
          : int.tryParse(map['km'].toString()) ?? 0,
      puntosRuta: map['puntos_ruta'] is int
          ? map['puntos_ruta']
          : int.tryParse(map['puntos_ruta'].toString()) ?? 0,
    );
  }

  // Método para convertir el usuario a un mapa
  Map<String, dynamic> toMap() {
    return {
      'id_ruta': idRuta,
      'km': km,
      'puntos_ruta': puntosRuta,
    };
  }

  // Método para crear una copia del usuario con algunos campos modificados
  Ruta copyWith({
    int? idRuta,
    int? km,
    int? puntosRuta,
  }) {
    return Ruta(
      idRuta: idRuta ?? this.idRuta,
      km: km ?? this.km,
      puntosRuta: puntosRuta ?? this.puntosRuta,
    );
  }
}
