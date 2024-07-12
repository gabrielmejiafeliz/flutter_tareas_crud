class Tarea {
  final int? id;
  final String nombre;

  Tarea({this.id, required this.nombre});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
    };
  }
}
