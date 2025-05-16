class Negocio {
  final int idNegocio;
  final String descuentos;
  final String ubicacion;
  final int beca;
  final int ventas;
  final int idAdministrador;

  Negocio({
    required this.idNegocio,
    required this.descuentos,
    required this.ubicacion,
    required this.beca,
    required this.ventas,
    required this.idAdministrador,
  });

  // Método para crear un negocio desde un mapa
  factory Negocio.fromMap(Map<String, dynamic> map) {
    return Negocio(
      idNegocio: map['id_negocio'] is int
          ? map['id_negocio']
          : int.tryParse(map['id_negocio'].toString()) ?? 0,
      descuentos: map['descuentos'] ?? '',
      ubicacion: map['ubicacion'] ?? '',
      beca: map['beca'] is int
          ? map['beca']
          : int.tryParse(map['beca'].toString()) ?? 0,
      ventas: map['ventas'] is int
          ? map['ventas']
          : int.tryParse(map['ventas'].toString()) ?? 0,
      idAdministrador: map['id_administrador'] is int
          ? map['id_administrador']
          : int.tryParse(map['id_administrador'].toString()) ?? 0,
    );
  }

  // Método para convertir el negocio a un mapa
  Map<String, dynamic> toMap() {
    return {
      'id_negocio': idNegocio,
      'descuentos': descuentos,
      'ubicacion': ubicacion,
      'beca': beca,
      'ventas': ventas,
      'id_administrador': idAdministrador,
    };
  }

  // Método para crear una copia del negocio con algunos campos modificados
  Negocio copyWith({
    int? idNegocio,
    String? descuentos,
    String? ubicacion,
    int? beca,
    int? ventas,
    int? idAdministrador,
  }) {
    return Negocio(
      idNegocio: idNegocio ?? this.idNegocio,
      descuentos: descuentos ?? this.descuentos,
      ubicacion: ubicacion ?? this.ubicacion,
      beca: beca ?? this.beca,
      ventas: ventas ?? this.ventas,
      idAdministrador: idAdministrador ?? this.idAdministrador,
    );
  }
}
