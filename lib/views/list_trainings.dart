import 'package:capacitaciones/DAO/capacitacion_dao.dart';
import 'package:flutter/material.dart';
import 'package:capacitaciones/helpers/inicializar_daos.dart';

class ListTraining extends StatefulWidget {
  @override
  _ListTrainingState createState() => _ListTrainingState();
}

class _ListTrainingState extends State<ListTraining> {
  final TextEditingController idCapacitacionController =
      TextEditingController();
  final TextEditingController idPersonaController = TextEditingController();
  final TextEditingController nombrePersonaController = TextEditingController();
  List<Map<String, dynamic>> asistentes = [];
  late Future<List<Map<String, dynamic>>> _futureCapacitaciones;
  bool statusShow = false;

  @override
  void initState() {
    super.initState();
    _futureCapacitaciones = _loadCapacitaciones(statusShow);
    inicializarDaos();
  }

  Future<List<Map<String, dynamic>>> _loadCapacitaciones(bool status) async {
    final capacitacionDao = CapacitacionDao();
    final capacitacionesList =
        await capacitacionDao.getCapacitacionesByStatus(status);
    return capacitacionesList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: Flexible(
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('CAPACITACIONES', overflow: TextOverflow.ellipsis),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: Container()),
                    Text(statusShow ? "Transferidos" : "Pendientes"),
                    Switch(
                      value: statusShow,
                      onChanged: (value) {
                        setState(() {
                          statusShow = value;
                          _futureCapacitaciones =
                              _loadCapacitaciones(statusShow);
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
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _futureCapacitaciones,
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
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/details',
                      arguments: capacitacion['capacitacion_id'].toString(),
                    );
                  },
                  child: Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          capacitacion['descripcion'].toString(),
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
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
