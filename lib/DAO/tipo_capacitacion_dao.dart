import 'package:capacitaciones/DAO/tipo_capacitacion_model.dart';
import 'package:sqflite/sqflite.dart';
class TipoCapacitacionDao {
  final Database database;

  TipoCapacitacionDao(this.database);

  Future<void> insertTipoCapacitacion(TiposCapacitacionModel item) async {
    await database.insert(
      'tipo_capacitacion',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<TiposCapacitacionModel>> getTipoCapacitacion() async {
    final List<Map<String, dynamic>> maps = await database.query('tipo_capacitacion');
    return List.generate(maps.length, (i) {
      return TiposCapacitacionModel.fromMap(maps[i]);
    });
  }

  Future<void> updateTipoCapacitacion(TiposCapacitacionModel item) async {
    await database.update(
      'tipo_capacitacion',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<void> deleteTipoCapacitacion(String? id) async {
    await database.delete(
      'tipo_capacitacion',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
