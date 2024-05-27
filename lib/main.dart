import 'dart:convert';
import 'package:capacitaciones/DAO/capacitacion_asistentes_model.dart';
import 'package:capacitaciones/DAO/capacitacion_dao.dart';
import 'package:capacitaciones/DAO/capacitacion_model.dart';
import 'package:capacitaciones/DAO/personas_dao.dart';
import 'package:capacitaciones/DAO/personas_model.dart';
import 'package:capacitaciones/database/init_database.dart';
import 'package:capacitaciones/helpers/unencrypt_general_code.dart';
import 'package:capacitaciones/services/areas_service.dart';
import 'package:flutter/material.dart';
import 'package:capacitaciones/DAO/capacitacion_asistentes_dao.dart';
import 'package:capacitaciones/helpers/generate_excel.dart';
import 'package:capacitaciones/helpers/inicializar_daos.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  runApp(MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  inicializarDaos();
  Database database = await initDatabase();
}

Future<List<Map<String, dynamic>>> obtenerCapacitacionAsistentes() async {
  final capacitacionAsistentesDao = CapacitacionAsistentesDao();
  final capacitacionAsistentesList =
      await capacitacionAsistentesDao.getCapacitacionAsistentes();
  print('asistentes: $capacitacionAsistentesList');
  return capacitacionAsistentesList;
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextEditingController idCapacitacionController =
      TextEditingController();
  final TextEditingController idPersonaController = TextEditingController();
  final TextEditingController nombrePersonaController = TextEditingController();
  List<Map<String, dynamic>> asistentes = [];
  late Future<List<Map<String, dynamic>>> _futureCapacitaciones;


  late Database database;

  bool statusShow = false;

  @override
  void initState() {
    super.initState();
    _futureCapacitaciones = _loadCapacitaciones(statusShow);

  }

  Future<List<Map<String, dynamic>>> _loadCapacitaciones(bool status) async {
    final capacitacionDao = CapacitacionDao();
    final capacitacionesList = await capacitacionDao.getCapacitacionesByStatus(status);

  print('asistentes: $capacitacionesList');
  return capacitacionesList;
}

  // Future<List<CapacitacionModel>> _loadCapacitaciones(status) async {
  //   final capacitacionDao = CapacitacionDao();
  //   var capacitacionesList = await capacitacionDao.getCapacitaciones();
  //   var capacitacionesListR = await capacitacionDao.getCapacitacionesByStatus(status);
    
  //   print(capacitacionesListR.toString());
  //   for (var element in capacitacionesListR) {
  //     print(element.toString());
  //   }

  //   for (var element in capacitacionesList) {
  //     print(element.description);
  //   }
  //   return capacitacionesList;
  // }

  Future<void> _loadAsistentes() async {
    var asistentesList = await obtenerCapacitacionAsistentes();
    setState(() {
      asistentes = asistentesList;
    });
  }

  Future<void> _insertarAsistente() async {
    final capacitacionAsistentesDao = CapacitacionAsistentesDao();
    final personasDao = PersonasDao();
    int idpersona = int.parse(idPersonaController.value.text);
    bool existePersona = await personasDao.personaExists(72450801);
    if (existePersona) {
      capacitacionAsistentesDao.insertAsistente(CapacitacionAsistentesModel(
        idcapacitacion: 1,
        idpersona: idpersona,
      ));
    } else {
      print('La persona con DNI 72450801 no existe en la base de datos.');
    }
    // if(personas.length > 0){
    // idPersonaController.clear();
    _loadAsistentes();
    // }
  }

  Future<void> _eliminarAsistente(String idAsistente) async {
    final capacitacionAsistentesDao = CapacitacionAsistentesDao();
    capacitacionAsistentesDao.deleteAsistente(1, int.parse(idAsistente));
    // capacitacionAsistentesDao.limpiarCapacitacion(1);
    idPersonaController.clear();
    _loadAsistentes();
  }

  Future<void> _scanBarcode() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancelar', true, ScanMode.BARCODE);
    } catch (e) {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() async {
      if (barcodeScanRes != '-1') {
        String descifrado = await descifradoSanJuan(barcodeScanRes);
        print('avisa: $descifrado');
        idPersonaController.text = descifrado;
        _insertarAsistente();
        idPersonaController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          toolbarHeight: 100,
          title: Flexible(
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CAPACITACIONES',
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 10), // Espacio vertical de 10 unidades
                  Row(
                    children: [
                      Expanded(
                          child:
                              Container()), 
                      Text(statusShow ? "Transferidos" : "Pendientes"),
                      Switch(
                        value: statusShow,
                        onChanged: (value) {
                          setState(() {
                            statusShow = value;
                            _loadCapacitaciones(statusShow);
                            // Aquí podrías cambiar la lógica para filtrar las capacitaciones pendientes/completadas
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        // body: Center(
        //     child: ListView.builder(
        //   itemCount: 1,
        //   itemBuilder: (context, index) {
        //     return Container(
        //       margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        //       padding: EdgeInsets.all(10.0),
        //       decoration: BoxDecoration(
        //         color: Colors.grey[300],
        //         borderRadius: BorderRadius.circular(8.0),
        //       ),
        //       child: Column(
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [
        //           Text(
        //             'Capacitacion 1',
        //             style: TextStyle(
        //               fontWeight: FontWeight.bold,
        //               fontSize: 16.0,
        //             ),
        //           ),
        //           SizedBox(height: 5.0),
        //           Text('NOMBRE DE CAPACITADOR'),
        //           Text('DENNIS VARGAS MEOÑO'),
        //           SizedBox(height: 5.0),
        //           Text('ASISTENTES: 1'),
        //           Align(
        //             alignment: Alignment.centerRight,
        //             child: Text('2024-05-27'),
        //           ),
        //         ],
        //       ),
        //     );
        //   },
        // )),
        // Future<>
        body: FutureBuilder<List<Map<String, dynamic>>>(
          // AQUI SE CARGAN LAS CAPACITACIONES
          future: _loadCapacitaciones(statusShow),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error al cargar las capacitaciones'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No hay capacitaciones disponibles'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  var capacitacion = snapshot.data![index];
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          capacitacion['descripcion'] .toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Text(capacitacion['capacitador']),
                        Text(capacitacion['capacitador_id']),
                        SizedBox(height: 5.0),
                        Text('ASISTENTES: ${capacitacion["asistentes"]} '),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(capacitacion['fecha']),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     home: Scaffold(
  //       appBar: AppBar(
  //         title: Text('Asistentes capacitación'),
  //       ),
  //       body: Center(
  //         child: SingleChildScrollView(
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: <Widget>[
  //               ElevatedButton(
  //                 onPressed: () async {
  //                   var jsonString = jsonEncode(asistentes);
  //                   generateExcelFromJson(jsonString);
  //                 },
  //                 child: Text('Generar Excel'),
  //               ),
  //               SizedBox(height: 20),
  //               _buildTextField('ID Capacitación', idCapacitacionController),
  //               SizedBox(height: 10),
  //               _buildTextField('ID Persona', idPersonaController),
  //               ElevatedButton(
  //                 onPressed: () async {
  //                   var jsonString = await obtenerCapacitacionAsistentes();
  //                   print(jsonString.toString());
  //                   _insertarAsistente();
  //                 },
  //                 child: Text('Agregar persona'),
  //               ),
  //               ElevatedButton(
  //                 onPressed: _scanBarcode,
  //                 child: Text('Escanear código de barras'),
  //               ),
  //               SizedBox(height: 20),
  //               _buildDataTable(),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildTextField(String labelText, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: 'Enter $labelText',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildDeleteButton(String idAsistente) {
    return IconButton(
      icon: Icon(Icons.delete, color: Colors.red),
      onPressed: () {
        print('Eliminar asistente con ID: $idAsistente');
        setState(() {
          _eliminarAsistente(idAsistente);
        });
        _loadAsistentes();
      },
    );
  }

  Widget _buildDataTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          DataColumn(label: Text('DNI')),
          DataColumn(label: Text('NOMBRES')),
          DataColumn(label: Text('OBSERVACIÓN')),
          DataColumn(label: Text('ACCIONES')),
        ],
        rows: asistentes.map((asistente) {
          return DataRow(cells: [
            DataCell(Text(asistente['dni']?.toString() ?? 'N/A')),
            DataCell(
              Text('${asistente['nombres'] ?? ''} ${asistente['a_paterno'] ?? ''} ${asistente['a_materno'] ?? ''}'
                      .trim()
                      .isEmpty
                  ? 'N/A'
                  : '${asistente['nombres'] ?? ''} ${asistente['a_paterno'] ?? ''} ${asistente['a_materno'] ?? ''}'),
            ),
            DataCell(Text(asistente['observacion']?.toString() ?? 'N/A')),
            DataCell(_buildDeleteButton(asistente['dni']?.toString() ?? 'N/A')),
          ]);
        }).toList(),
      ),
    );
  }
}
