import 'package:capacitaciones/DAO/areas_model.dart';
import 'package:sqflite/sqflite.dart';
class AreasDao {
  final Database database;

  AreasDao(this.database);

  Future<void> insertAreas(AreasModel item) async {
    await database.insert(
      'areas',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<AreasModel>> getAreas() async {
    final List<Map<String, dynamic>> maps = await database.query('areas');
    return List.generate(maps.length, (i) {
      return AreasModel.fromMap(maps[i]);
    });
  }

  Future<void> updateArea(AreasModel item) async {
    await database.update(
      'areas',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<void> deleteArea(String? id) async {
    await database.delete(
      'areas',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
