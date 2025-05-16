// Modelo de actividad
class Actividad {
  final int id;
  final String tipo;
  final String descripcion;
  final int puntosotorgados;
  final int idCiudadano;

  Actividad({
    required this.id,
    required this.tipo,
    required this.descripcion,
    required this.puntosotorgados,
    required this.idCiudadano,
  });

  // Método para crear una actividad desde un mapa
  factory Actividad.fromMap(Map<String, dynamic> map) {
    return Actividad(
      id: map['id'] is int
          ? map['id']
          : int.tryParse(map['id'].toString()) ?? 0,
      tipo: map['tipo'] ?? '',
      descripcion: map['descripcion'] ?? '',
      puntosotorgados: map['puntosotorgados'] is int
          ? map['puntosotorgados']
          : int.tryParse(map['puntosotorgados'].toString()) ?? 0,
      idCiudadano: map['id_ciudadano'] is int
          ? map['id_ciudadano']
          : int.tryParse(map['id_ciudadano'].toString()) ?? 0,
    );
  }

  // Método para convertir la actividad a un mapa
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tipo': tipo,
      'descripcion': descripcion,
      'puntosotorgados': puntosotorgados,
      'id_ciudadano': idCiudadano,
    };
  }

  // Método para crear una copia de la actividad con algunos campos modificados
  Actividad copyWith({
    int? id,
    String? tipo,
    String? descripcion,
    int? puntosotorgados,
    int? idCiudadano,
  }) {
    return Actividad(
      id: id ?? this.id,
      tipo:tipo ?? this.tipo,
      descripcion: descripcion ?? this.descripcion,
      puntosotorgados: puntosotorgados ?? this.puntosotorgados,
      idCiudadano: idCiudadano ?? this.idCiudadano,
    );
  }
}
