import 'package:capacitaciones/DAO/user_model.dart';
import 'package:sqflite/sqflite.dart';
class UserDao {
  final Database database;

  UserDao(this.database);

  Future<void> insertUser(UserModel item) async {
    await database.insert(
      'users',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<UserModel>> getUsers() async {
    final List<Map<String, dynamic>> maps = await database.query('users');
    return List.generate(maps.length, (i) {
      return UserModel.fromMap(maps[i]);
    });
  }

  Future<void> updateUser(UserModel item) async {
    await database.update(
      'users',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<void> deleteUser(int id) async {
    await database.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
