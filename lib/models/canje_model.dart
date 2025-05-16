class Canje {
  final int id;
  final DateTime fecha;
  final DateTime hora;
  final double descuentosaplicado;
  final int puntosgastados;
  final int idUsuario;
  final int idNegocio;
  final int idProducto;


  Canje({
    required this.id,
    required this.fecha,
    required this.hora,
    required this.descuentosaplicado,
    required this.puntosgastados,
    required this.idUsuario,
    required this.idNegocio,
    required this.idProducto,

  });

  // Método para crear un canje desde un mapa
  factory Canje.fromMap(Map<String, dynamic> map) {
    return Canje(
      id: map['id'] is int ? map['id'] : int.tryParse(map['id'].toString()) ?? 0,
      fecha: DateTime.parse(map['fecha']),
      hora: DateTime.parse(map['hora']),
      descuentosaplicado: map['descuentosaplicado'] is double ? map['descuentosaplicado'] : double.tryParse(map['descuentosaplicado'].toString()) ?? 0.0,
      puntosgastados: map['puntosgastados'] is int ? map['puntosgastados'] : int.tryParse(map['puntosgastados'].toString()) ?? 0,
      idUsuario: map['id_usuario'] is int ? map['id_usuario'] : int.tryParse(map['id_usuario'].toString()) ?? 0,
      idNegocio: map['id_negocio'] is int ? map['id_negocio'] : int.tryParse(map['id_negocio'].toString()) ?? 0,
      idProducto: map['id_producto'] is int ? map['id_producto'] : int.tryParse(map['id_producto'].toString()) ?? 0,
    );
  }

  // Método para convertir el negocio a un mapa
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fecha': fecha.toIso8601String(),
      'hora': hora.toIso8601String(),
      'descuentosaplicado': descuentosaplicado,
      'puntosgastados': puntosgastados,
      'id_usuario': idUsuario,
      'id_negocio': idNegocio,
      'id_producto': idProducto,
    };
  }

  // Método para crear una copia del negocio con algunos campos modificados
  Canje copyWith({
    int? id,
    DateTime? fecha,
    DateTime? hora,
    double? descuentosaplicado,
    int? puntosgastados,
    int? idUsuario,
    int? idNegocio,
    int? idProducto,
  }) {
    return Canje(
      id: id ?? this.id,
      fecha: fecha ?? this.fecha,
      hora: hora ?? this.hora,
      descuentosaplicado: descuentosaplicado ?? this.descuentosaplicado,
      puntosgastados: puntosgastados ?? this.puntosgastados,
      idUsuario: idUsuario ?? this.idUsuario,
      idNegocio: idNegocio ?? this.idNegocio,
      idProducto: idProducto ?? this.idProducto,
    );
  }
}




