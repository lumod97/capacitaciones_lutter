class PersonasModel {
  final String? idcodigogeneral;
  final String? idarea;
  final String? dni;
  final String? name;
  final String? a_paterno;
  final String? a_materno;
  
  

  PersonasModel({this.idcodigogeneral, this.idarea, this.dni, this.name, this.a_paterno,this.a_materno});

  Map<String, dynamic> toMap() {
    return {
      'idcodigogeneral': idcodigogeneral,
      'idarea': idarea,
      'dni': dni,
      'name': name,
      'a_paterno': a_paterno,
      'a_materno': a_materno
    };
  }

  static PersonasModel fromMap(Map<String, dynamic> map) {
    return PersonasModel(
      idcodigogeneral: map['idcodigogeneral'],
      idarea: map['idarea'],
      dni: map['dni'],
      name: map['name'],
      a_paterno: map['a_paterno'],
      a_materno: map['a_materno'],
    );
  }
}
