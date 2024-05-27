import 'dart:convert';

class CapacitacionAsistentesModel {
  final int? idcapacitacion;
  final int? idpersona;
  
  CapacitacionAsistentesModel({this.idcapacitacion, this.idpersona});

  Map<String, dynamic> toMap() {
    return {
      'idcapacitacion': idcapacitacion,
      'idpersona': idpersona,
    };
  }

  factory CapacitacionAsistentesModel.fromMap(Map<String, dynamic> map) {
    return CapacitacionAsistentesModel(
      idcapacitacion: map['idcapacitacion'],
      idpersona: map['idpersona'],
    );
  }

  String toJson() => jsonEncode(toMap());

  factory CapacitacionAsistentesModel.fromJson(String source) =>
      CapacitacionAsistentesModel.fromMap(jsonDecode(source));
}
