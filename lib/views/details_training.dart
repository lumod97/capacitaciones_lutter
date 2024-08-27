import 'dart:convert';

import 'package:capacitaciones/DAO/capacitacion_asistentes_dao.dart';
import 'package:capacitaciones/DAO/capacitacion_asistentes_model.dart';
import 'package:capacitaciones/DAO/capacitacion_dao.dart';
import 'package:capacitaciones/DAO/capacitacion_model.dart';
import 'package:capacitaciones/DAO/personas_dao.dart';
import 'package:capacitaciones/helpers/generate_excel.dart';
import 'package:capacitaciones/helpers/unencrypt_general_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class DetailsTraining extends StatefulWidget {
  final String parameter; // Aquí define los parámetros que quieras recibir

  const DetailsTraining({Key? key, required this.parameter}) : super(key: key);

  @override
  _DetailsTrainingState createState() => _DetailsTrainingState();
}

class _DetailsTrainingState extends State<DetailsTraining> {
  final TextEditingController nombreCapacitacionController =
      TextEditingController();
  final TextEditingController idPersonaController = TextEditingController();
  final TextEditingController nombrePersonaController = TextEditingController();
  List<Map<String, dynamic>> asistentes = [];
  late Future<List<Map<String, dynamic>>> _futureCapacitaciones;
  late Future<List<CapacitacionModel>> capacitacionData;

  @override
  void initState() {
    super.initState();
    capacitacionData = cargarDataCapacitacion(widget.parameter);
    _loadAsistentes();
  }

  Future<List<CapacitacionModel>> _loadCapacitaciones(status) async {
    final capacitacionDao = CapacitacionDao();
    List<CapacitacionModel> capacitacionesList =
        await capacitacionDao.getCapacitaciones();
    return capacitacionesList;
  }

  Future<List<CapacitacionModel>> cargarDataCapacitacion(String id) async {
    final capacitacionDao = CapacitacionDao();
    List<CapacitacionModel> capacitacion =
        await capacitacionDao.getCapacitacionById(id);
    return capacitacion;
  }

  Future<List<Map<String, dynamic>>> obtenerCapacitacionAsistentes() async {
    final capacitacionAsistentesDao = CapacitacionAsistentesDao();
    final capacitacionAsistentesList = await capacitacionAsistentesDao
        .getCapacitacionAsistentes(widget.parameter);
    print('asistentes: $capacitacionAsistentesList');
    return capacitacionAsistentesList;
  }

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
    bool existePersona = await personasDao.personaExists(idpersona);
    if (existePersona == true) {
      capacitacionAsistentesDao.insertAsistente(CapacitacionAsistentesModel(
        idcapacitacion: int.tryParse(widget.parameter),
        idpersona: idpersona,
      ));
    } else {
      print('La persona con DNI $idpersona no existe en la base de datos.');
    }
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

  Future<void> _eliminarAsistente(String idAsistente) async {
    final capacitacionAsistentesDao = CapacitacionAsistentesDao();
    capacitacionAsistentesDao.deleteAsistente(1, int.parse(idAsistente));
    idPersonaController.clear();
    _loadAsistentes();
  }

  Widget _buildTextField(
      String labelText, TextEditingController controller, bool? enabled) {
    return TextField(
      controller: controller,
      enabled: enabled ?? false,
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
              Text(
                '${asistente['nombres'] ?? ''} ${asistente['a_paterno'] ?? ''} ${asistente['a_materno'] ?? ''}'
                    .trim()
                    .isEmpty
                    ? 'N/A'
                    : '${asistente['nombres'] ?? ''} ${asistente['a_paterno'] ?? ''} ${asistente['a_materno'] ?? ''}',
              ),
            ),
            DataCell(Text(asistente['observacion']?.toString() ?? 'N/A')),
            DataCell(_buildDeleteButton(asistente['dni']?.toString() ?? 'N/A')),
          ]);
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Asistentes capacitación'),
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () async {
                    var jsonString = jsonEncode(asistentes);
                    generateExcelFromJson(jsonString);
                  },
                  child: Text('Generar Excel'),
                ),
                SizedBox(height: 20),
                FutureBuilder<List<CapacitacionModel>>(
                  future: capacitacionData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Text('No hay datos disponibles');
                    } else {
                      var capacitacion = snapshot.data!.first;
                      nombreCapacitacionController.text =
                          capacitacion.description ?? 'Aun no hay datos';
                      return _buildTextField('Nombre Capacitación',
                          nombreCapacitacionController, false);
                    }
                  },
                ),
                SizedBox(height: 10),
                _buildTextField('DNI', idPersonaController, true),
                ElevatedButton(
                  onPressed: () async {
                    var jsonString = await obtenerCapacitacionAsistentes();
                    print(jsonString.toString());
                    _insertarAsistente();
                  },
                  child: Text('Agregar persona'),
                ),
                ElevatedButton(
                  onPressed: _scanBarcode,
                  child: Text('Escanear código de barras'),
                ),
                SizedBox(height: 20),
                _buildDataTable(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
