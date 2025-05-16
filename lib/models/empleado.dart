class Empleado {
  final int idUsuario;

  Empleado({
    required this.idUsuario,
  });

  // Método para crear un empleado desde un mapa
  factory Empleado.fromMap(Map<String, dynamic> map) {
    return Empleado(
      idUsuario: map['id_usuario'] is int
          ? map['id_usuario']
          : int.tryParse(map['id_usuario'].toString()) ?? 0,
    );
  }

  // Método para convertir el empleado a un mapa
  Map<String, dynamic> toMap() {
    return {
      'id_usuario': idUsuario,
    };
  }

  // Método para crear una copia del empleado con algunos campos modificados
  Empleado copyWith({
    int? idUsuario,
  }) {
    return Empleado(
      idUsuario: idUsuario ?? this.idUsuario,
    );
  }
}
