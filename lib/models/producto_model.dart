class Producto {
  final int id;
  final String nombre;
  final double precio;
  final int idNegocio;


  Producto({
    required this.id,
    required this.nombre,
    required this.precio,
    required this.idNegocio,
  });

  // Método para crear un negocio desde un mapa
  factory Producto.fromMap(Map<String, dynamic> map) {
    return Producto(
      id: map['id'] is int ? map['id'] : int.tryParse(map['id'].toString()) ?? 0,
      nombre: map['nombre'] ?? '',
      precio: map['precio'] is double ? map['precio'] : double.tryParse(map['precio'].toString()) ?? 0.0,
      idNegocio: map['id_negocio'] is int ? map['id_negocio'] : int.tryParse(map['id_negocio'].toString()) ?? 0,
    );
  }

  // Método para convertir el negocio a un mapa
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'precio': precio,
      'id_negocio': idNegocio,
    };
  }

  // Método para crear una copia del negocio con algunos campos modificados
  Producto copyWith({
    int? id,
    String? nombre,
    double? precio,
    int? idNegocio,
  }) {
    return Producto(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      precio: precio ?? this.precio,
      idNegocio: idNegocio ?? this.idNegocio,
    );
  }
}
