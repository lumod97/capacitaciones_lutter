class CapacitacionModel {
  final String? id;
  final String? description;
  final String? tipo;
  final String? fecha;
  final String? capacitador_id;
  final String? horas_estimadas;
  final String? created_by;
  final String? created_at;
  final String? updated_by;
  final String? updated_at;

  
  CapacitacionModel({this.id, this.description, this.tipo, this.fecha, this.capacitador_id, this.horas_estimadas, this.created_by, this.created_at, this.updated_by, this.updated_at});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'tipo': tipo,
      'fecha': fecha, 
      'capacitador_id': capacitador_id, 
      'horas_estimadas': horas_estimadas, 
      'created_by': created_by, 
      'created_at': created_at, 
      'updated_by': updated_by, 
      'updated_at': updated_at
    };
  }

  static CapacitacionModel fromMap(Map<String, dynamic> map) {
    return CapacitacionModel(
      id: map['id'],
      description: map['description'],
      tipo: map['tipo'],
      fecha: map['fecha'], 
      capacitador_id: map['capacitador_id'], 
      horas_estimadas: map['horas_estimadas'], 
      created_by: map['created_by'], 
      created_at: map['created_at'], 
      updated_by: map['updated_by'], 
      updated_at: map['updated_at']
    );
  }
}
