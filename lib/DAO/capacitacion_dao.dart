import 'package:capacitaciones/DAO/capacitacion_model.dart';
import 'package:capacitaciones/database/init_database.dart';
import 'package:sqflite/sqflite.dart';

class CapacitacionDao {
  Future<void> insertCapacitacion(CapacitacionModel item) async {
    final Database database = await initDatabase();

    await database.insert(
      'capacitacion',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<CapacitacionModel>> getCapacitaciones() async {
    final Database database = await initDatabase();

    final List<Map<String, dynamic>> maps =
        await database.query('capacitacion');
    return List.generate(maps.length, (i) {
      return CapacitacionModel.fromMap(maps[i]);
    });
  }

  Future<List<CapacitacionModel>> getCapacitacionById(id) async {
    final Database database = await initDatabase();

    final List<Map<String, dynamic>> maps =
        await database.query('capacitacion',
        where: 'id = ?',
        whereArgs: [id]);
    return List.generate(maps.length, (i) {
      return CapacitacionModel.fromMap(maps[i]);
    });
  }

  Future<List<Map<String, dynamic>>> getCapacitacionesByStatus(
      bool status) async {
    final Database database = await initDatabase();

    final List<Map<String, dynamic>> maps = await database.rawQuery('''
    SELECT
      capacitacion.id capacitacion_id,
      capacitacion.description,
      capacitacion.fecha,
      personas.name || ' ' || personas.a_paterno || ' ' || personas.a_materno capacitador,
      IFNULL(x.cantidad_asistentes, '0') asistentes,
      capacitacion.capacitador_id
    FROM capacitacion
    INNER JOIN capacitadores on capacitadores.idpersona = capacitacion.capacitador_id
    INNER JOIN personas on personas.dni = capacitadores.idpersona
    LEFT JOIN (SELECT COUNT(*) cantidad_asistentes, idcapacitacion FROM capacitacion_asistentes GROUP BY idcapacitacion) x ON x.idcapacitacion = capacitacion.id
  ''');

    // Convertir cada mapa a formato JSON
    List<Map<String, dynamic>> jsonList = List.generate(maps.length, (i) {
      return {
        'capacitacion_id': maps[i]['capacitacion_id'],
        'descripcion': maps[i]['description'],
        'fecha': maps[i]['fecha'],
        'capacitador': maps[i]['capacitador'],
        'asistentes': maps[i]['asistentes'],
        'capacitador_id': maps[i]['capacitador_id'],
      };
    });

    return jsonList;
  }

  Future<void> updateCapacitacion(CapacitacionModel item) async {
    final Database database = await initDatabase();

    await database.update(
      'capacitacion',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<void> deleteCapacitacion(String? id) async {
    final Database database = await initDatabase();

    await database.delete(
      'capacitacion',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
