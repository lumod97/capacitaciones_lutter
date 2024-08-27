import 'package:capacitaciones/DAO/capacitacion_asistentes_model.dart';
import 'package:capacitaciones/database/init_database.dart';
import 'package:sqflite/sqflite.dart';

class CapacitacionAsistentesDao {
  final int? idcapacitacion;
  final String? idpersona;

  CapacitacionAsistentesDao({this.idcapacitacion, this.idpersona});

  Future<void> insertCapacitacionAsistente(
      CapacitacionAsistentesModel item) async {
    final Database database = await initDatabase();
    await database.insert(
      'capacitacion_asistentes',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  factory CapacitacionAsistentesDao.fromMap(Map<String, dynamic> map) {
    return CapacitacionAsistentesDao(
      idcapacitacion: map['idcapacitacion'],
      idpersona: map['idpersona'],
    );
  }

  Future<void> insertAsistente(CapacitacionAsistentesModel item) async {
    final Database database = await initDatabase();
    await database.insert(
      'capacitacion_asistentes',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteAsistente(int idcapacitacion, int idpersona) async {
    final Database database = await initDatabase();
    await database.delete(
      'capacitacion_asistentes',
      where: 'idcapacitacion = ? AND idpersona = ?',
      whereArgs: [idcapacitacion, idpersona],
    );
  }

  Future<void> limpiarCapacitacion(int idcapacitacion) async {
    final Database database = await initDatabase();
    await database.delete(
      'capacitacion_asistentes',
      where: 'idcapacitacion = ?',
      whereArgs: [idcapacitacion],
    );
  }

  Future<List<Map<String, dynamic>>> getCapacitacionAsistentes(id_capacitacion) async {
    final Database database = await initDatabase();

    final List<Map<String, dynamic>> maps = await database.rawQuery('''
    SELECT
      capacitacion.id capacitacion_id,
      capacitacion.description descripcion,
      capacitacion.description || DATE(capacitacion.fecha) AS nombre_archivo,
      personas.a_paterno AS a_paterno,
      personas.a_materno AS a_materno,
      personas.name AS nombres,
      personas.dni AS dni,
      areas.name AS area,
      'SIN OBSERVACIÓN' observacion
    FROM capacitacion_asistentes
    LEFT JOIN capacitacion ON capacitacion_asistentes.idcapacitacion = capacitacion.id
    LEFT JOIN personas ON capacitacion_asistentes.idpersona = personas.dni
    LEFT JOIN areas ON areas.id = personas.idarea
    WHERE capacitacion.id = '$id_capacitacion'
  ''');

    // Convertir cada mapa a formato JSON
    List<Map<String, dynamic>> jsonList = List.generate(maps.length, (i) {
      return {
        'capacitacion_id': maps[i]['capacitacion_id'],
        'descripcion': maps[i]['descripcion'],
        'nombre_archivo': maps[i]['nombre_archivo'],
        'a_paterno': maps[i]['a_paterno'],
        'a_materno': maps[i]['a_materno'],
        'nombres': maps[i]['nombres'],
        'dni': maps[i]['dni'],
        'area': maps[i]['area'],
        'observacion': maps[i]['observacion']
      };
    });

    return jsonList;
  }
}
