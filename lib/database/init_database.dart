
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
// INICIALIZAR BASE DE DATOS
Future<Database> initDatabase() async {
  return openDatabase(
    join(await getDatabasesPath(), 'example.db'),
    onCreate: (db, version) {
      db.execute(
        "CREATE TABLE areas(id TEXT PRIMARY KEY, name TEXT)",
      );
      db.execute(
        "CREATE TABLE tipo_capacitacion(id TEXT PRIMARY KEY, descripcion TEXT)",
      );
      db.execute(
        '''
          CREATE TABLE capacitacion (
            id TEXT PRIMARY KEY,
            description TEXT,
            tipo TEXT,
            fecha TEXT,
            capacitador_id TEXT,
            horas_estimadas TEXT,
            created_by TEXT,
            created_at TEXT,
            updated_by TEXT,
            updated_at TEXT
          );
        ''',
      );
      db.execute(
        '''
          CREATE TABLE capacitadores (
            id TEXT PRIMARY KEY,
            idpersona TEXT,
            idcargo TEXT
          );
        ''',
      );
      db.execute(
        '''
        CREATE TABLE cargos (
          id TEXT PRIMARY KEY,
          name TEXT
        )
        '''
      );
      db.execute('''
        CREATE TABLE personas (
          idcodigogeneral TEXT PRIMARY KEY,
          idarea TEXT,
          name TEXT,
          a_paterno TEXT,
          a_materno TEXT,
          dni TEXT
        )
      ''');

      db.execute('''
        CREATE TABLE users (
          id INTEGER PRIMARY KEY,
          user_name TEXT,
          id_user TEXT,
          password TEXT
        )
      ''');

      db.execute('''
        CREATE TABLE capacitacion_asistentes (
          idcapacitacion INTEGER,
          idpersona INTEGER,
          FOREIGN KEY (idcapacitacion) REFERENCES capacitacion(id),
          FOREIGN KEY (idpersona) REFERENCES personas(id),
          PRIMARY KEY (idcapacitacion, idpersona)
        )
      ''');


    },
    version: 6,
  );
}