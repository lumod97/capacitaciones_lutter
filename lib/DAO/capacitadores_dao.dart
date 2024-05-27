import 'package:capacitaciones/DAO/capacitadores_model.dart';
import 'package:sqflite/sqflite.dart';
class CapacitadoresDao {
  final Database database;

  CapacitadoresDao(this.database);

  Future<void> insertCapacitador(CapacitadoresModel item) async {
    await database.insert(
      'capacitadores',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<CapacitadoresModel>> getCapacitadores() async {
    final List<Map<String, dynamic>> maps = await database.query('capacitadores');
    return List.generate(maps.length, (i) {
      return CapacitadoresModel.fromMap(maps[i]);
    });
  }

  Future<void> updateCapacitador(CapacitadoresModel item) async {
    await database.update(
      'capacitadores',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<void> deleteCapacitador(int id) async {
    await database.delete(
      'capacitadores',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
