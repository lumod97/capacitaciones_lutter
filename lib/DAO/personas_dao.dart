import 'package:capacitaciones/DAO/personas_model.dart';
import 'package:capacitaciones/database/init_database.dart';
import 'package:sqflite/sqflite.dart';
class PersonasDao {

  Future<void> insertPersona(PersonasModel item) async {
      final Database database = await initDatabase();

    await database.insert(
      'personas',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<PersonasModel>> getPersonas() async {
      final Database database = await initDatabase();

    final List<Map<String, dynamic>> maps = await database.query('personas');
    return List.generate(maps.length, (i) {
      return PersonasModel.fromMap(maps[i]);
    });
  }

  Future<void> updatePersona(PersonasModel item) async {
      final Database database = await initDatabase();

    await database.update(
      'personas',
      item.toMap(),
      where: 'idcodigogeneral = ? or dni = ?',
      whereArgs: [item.idcodigogeneral, item.dni],
    );
  }

  Future<void> deletePersona(String? dni) async {
      final Database database = await initDatabase();

    await database.delete(
      'personas',
      where: 'dni = ?',
      whereArgs: [dni],
    );
  }

  Future<List<PersonasModel>> getPersonasById(int idPersona) async {
      final Database database = await initDatabase();

    final List<Map<String, dynamic>> maps = await database.query(
      'personas',
      where: 'idcodigogeneral = $idPersona OR dni = $idPersona'
    );

    return List.generate(maps.length, (i) {
      return PersonasModel.fromMap(maps[i]);
    });
  }

  Future<bool> personaExists(int idPersona) async {
  final Database database = await initDatabase();

  final List<Map<String, dynamic>> maps = await database.query(
    'personas',
    where: 'idcodigogeneral = $idPersona OR dni = $idPersona'
  );

  // Si la lista de resultados tiene al menos un elemento, significa que la persona existe
  return maps.isNotEmpty;
}


}
