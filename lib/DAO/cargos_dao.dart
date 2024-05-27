import 'package:capacitaciones/DAO/cargos_model.dart';
import 'package:sqflite/sqflite.dart';
class CargosDao {
  final Database database;

  CargosDao(this.database);

  Future<void> insertCargo(CargosModel item) async {
    await database.insert(
      'cargos',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<CargosModel>> getCargos() async {
    final List<Map<String, dynamic>> maps = await database.query('cargos');
    return List.generate(maps.length, (i) {
      return CargosModel.fromMap(maps[i]);
    });
  }

  Future<void> updateCargo(CargosModel item) async {
    await database.update(
      'cargos',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<void> deleteCargo(String? id) async {
    await database.delete(
      'cargos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
