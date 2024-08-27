import 'package:capacitaciones/DAO/areas_dao.dart';
import 'package:capacitaciones/DAO/areas_model.dart';
import 'package:capacitaciones/DAO/capacitacion_dao.dart';
import 'package:capacitaciones/DAO/capacitacion_model.dart';
import 'package:capacitaciones/DAO/capacitadores_dao.dart';
import 'package:capacitaciones/DAO/capacitadores_model.dart';
import 'package:capacitaciones/DAO/cargos_dao.dart';
import 'package:capacitaciones/DAO/cargos_model.dart';
import 'package:capacitaciones/DAO/personas_dao.dart';
import 'package:capacitaciones/DAO/personas_model.dart';
import 'package:capacitaciones/DAO/tipo_capacitacion_dao.dart';
import 'package:capacitaciones/DAO/tipo_capacitacion_model.dart';
import 'package:capacitaciones/database/init_database.dart';
import 'package:capacitaciones/services/areas_service.dart';
import 'package:capacitaciones/services/capacitaciones_service.dart';
import 'package:capacitaciones/services/cargos_service.dart';
import 'package:capacitaciones/services/personas_service.dart';
import 'package:capacitaciones/services/tipos_capacitacion_service.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void insertAreas(Database database) async{

  var dbPath = await getDatabasesPath();
  print('path: $dbPath');
  final areasDao = AreasDao(database);
  List areas = await AreasService().getAreas();

  for (var element in areas) {
    // Crear una instancia de PersonasModel
    AreasModel area = AreasModel(
      id: element['idarea'],
      name: element['descripcion'],
    );

    // Imprimir el valor de a_materno
    print(join(area.id??'', ' ', area.name));

    // Insertar la persona en la base de datos
    await areasDao.deleteArea(area.id);
    await areasDao.insertAreas(area);
  }
}

void insertTiposCapacitacion(Database database) async{
  final tiposCapacitacionDao = TipoCapacitacionDao(database);
  List tiposCapacitacion = await TiposCapacitacionService().getTiposCapacitacion();

  for (var element in tiposCapacitacion) {
    // Crear una instancia de PersonasModel
    TiposCapacitacionModel tiposCapacitacion = TiposCapacitacionModel(
      id: element['id'],
      descripcion: element['descripcion'],
    );

    // Imprimir el valor de a_materno
    print(join(tiposCapacitacion.id??'', ' ', tiposCapacitacion.descripcion));

    // Insertar la persona en la base de datos
    await tiposCapacitacionDao.deleteTipoCapacitacion(tiposCapacitacion.id);
    await tiposCapacitacionDao.insertTipoCapacitacion(tiposCapacitacion);
  }
}

void insertCapacitaciones(Database database) async{
  final capacitacionesDao = CapacitacionDao();
  List capacitaciones = await CapacitacionesService().getCapacitaciones();

  for (var element in capacitaciones) {
    // Crear una instancia de PersonasModel
    CapacitacionModel capacitacion = CapacitacionModel(
      id: element['id'],
      description: element['descripcion'],
      tipo: element['tipo'],
      fecha: element['fecha'],
      capacitador_id: element['capacitador_id'],
      horas_estimadas: element['horas_estimadas'],
      created_by: element['created_by'],
      created_at: element['created_at'],
      updated_by: element['updated_by'],
      updated_at: element['updated_at'],
    );

    // Imprimir el valor de a_materno
    print(join(capacitacion.id as String, ' ', capacitacion.description));

    // Insertar la persona en la base de datos
    await capacitacionesDao.deleteCapacitacion(capacitacion.id);
    await capacitacionesDao.insertCapacitacion(capacitacion);
  }
}

void insertCargos(Database database) async{
  final cargosDao = CargosDao(database);
  List cargos = await CargosService().getCargos();

  for (var element in cargos) {
    // Crear una instancia de PersonasModel
    CargosModel cargo = CargosModel(
      id: element['idcargo'],
      name: element['descripcion'],
    );
    // Insertar la persona en la base de datos
    print(cargo.name);
    await cargosDao.deleteCargo(cargo.id);
    await cargosDao.insertCargo(cargo);
  }
}

void insertPersonas() async {
  final personasDao = PersonasDao();
  List personas = await PersonasService().getPersonas();

  for (var element in personas) {
    // Crear una instancia de PersonasModel
    PersonasModel persona = PersonasModel(
      idcodigogeneral: element['idcodigogeneral'],
      idarea: element['idarea'],
      dni: element['dni'],
      name: element['nombres'],
      a_paterno: element['a_paterno'],
      a_materno: element['a_materno'],
    );

    // Imprimir el valor de a_materno
    print(persona.a_materno);

    // Insertar la persona en la base de datos
    await personasDao.deletePersona(persona.dni);
    await personasDao.insertPersona(persona);
  }
}


void inicializarDaos() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = await initDatabase();
  // Obtener la fecha y hora actual
  DateTime now = DateTime.now();
  // Formatear en el formato deseado
  String formattedDate = '${now.year.toString().padLeft(4, '0')}-'
      '${now.month.toString().padLeft(2, '0')}-'
      '${now.day.toString().padLeft(2, '0')} '
      '${now.hour.toString().padLeft(2, '0')}:'
      '${now.minute.toString().padLeft(2, '0')}:'
      '${now.second.toString().padLeft(2, '0')}';

  // Inicialización de DAOs
  // final capacitacionDao = CapacitacionDao(database);
  final capacitadoresDao = CapacitadoresDao(database);
  // final cargosDao = CargosDao(database);
  // final personasDao = PersonasDao();
  // final capacitacionAsistentesDao = CapacitacionAsistentesDao();

  try {
    insertAreas(database);
    insertPersonas();
    insertCargos(database);
    insertTiposCapacitacion(database);
    insertCapacitaciones(database);


    // Insertar capacitadores
    // await capacitadoresDao.insertCapacitador(CapacitadoresModel(
    //   id: '1',
    //   idcargo: '230',
    //   idpersona: '72450801',
    // ));
    // await capacitadoresDao.insertCapacitador(CapacitadoresModel(
    //   id: '2',
    //   idcargo: '230',
    //   idpersona: '72450801',
    // ));


    // Insertar capacitaciones
    // await capacitacionDao.insertCapacitacion(CapacitacionModel(
    //   capacitador_id: '72450801',
    //   created_at: formattedDate,
    //   created_by: 1,
    //   description: 'CUIDADO Y USO CORRECTO DE EPPS',
    //   fecha: formattedDate,
    //   horas_estimadas: '1',
    //   id: 1,
    //   tipo: 1,
    //   updated_at: formattedDate,
    //   updated_by: 1,
    // ));

    // Insertar asistentes a capacitaciones
    // await capacitacionAsistentesDao
    //     .insertCapacitacionAsistente(CapacitacionAsistentesModel(
    //   idcapacitacion: 1,
    //   idpersona: 1,
    // ));
    // await capacitacionAsistentesDao
    //     .insertCapacitacionAsistente(CapacitacionAsistentesModel(
    //   idcapacitacion: 1,
    //   idpersona: 2,
    // ));
    // await capacitacionAsistentesDao
    //     .insertCapacitacionAsistente(CapacitacionAsistentesModel(
    //   idcapacitacion: 1,
    //   idpersona: 3,
    // ));

    // Éxito
    print('Operaciones de inicialización completadas correctamente.');
  } catch (e) {
    // Manejo de errores
    print('Error en las operaciones de inicialización: $e');
  } finally {
    // Cerrar la base de datos
    // await database.close();
  }
}
