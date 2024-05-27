class CargosModel {
  final String? id;
  final String? name;

  CargosModel({this.id, this.name,});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name
    };
  }

  static CargosModel fromMap(Map<String, dynamic> map) {
    return CargosModel(
      id: map['id'],
      name: map['name']
    );
  }
}
