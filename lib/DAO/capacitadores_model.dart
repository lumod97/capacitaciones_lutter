class CapacitadoresModel {
  final String? id;
  final String? idpersona;
  final String? idcargo;

  CapacitadoresModel({this.id, this.idpersona, this.idcargo});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idpersona': idpersona,
      'idcargo': idcargo,
    };
  }

  static CapacitadoresModel fromMap(Map<String, dynamic> map) {
    return CapacitadoresModel(
      id: map['id'],
      idpersona: map['idpersona'],
      idcargo: map['idcargo'],
    );
  }
}
