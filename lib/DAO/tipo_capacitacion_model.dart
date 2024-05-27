
class TiposCapacitacionModel {
  final String? id;
  final String? descripcion;

  TiposCapacitacionModel({this.id, this.descripcion});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'descripcion': descripcion
    };
  }

  static TiposCapacitacionModel fromMap(Map<String, dynamic> map) {
    return TiposCapacitacionModel(
      id: map['id'],
      descripcion: map['descripcion']
    );
  }
}
