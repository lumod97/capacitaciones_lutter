class AreasModel {
  final String? id;
  final String? name;

  AreasModel({this.id, this.name});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name
    };
  }

  static AreasModel fromMap(Map<String, dynamic> map) {
    return AreasModel(
      id: map['id'],
      name: map['name']
    );
  }
}
