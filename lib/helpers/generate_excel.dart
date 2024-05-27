
// import 'dart:convert';
// import 'dart:io';

// import 'package:excel/excel.dart';
// Future<void> generateExcelFromJson(String jsonString) async {
//   // Decodificar el JSON
//   final jsonData = jsonDecode(jsonString);

//   // Crear una instancia de Excel
//   var excel = Excel.createExcel();

//   // Definir estilos comunes para las celdas de encabezado
//   var headerStyle = CellStyle(
//     fontColorHex: ExcelColor.black,
//     bold: true,
//     backgroundColorHex: ExcelColor.blue400,
//   );
  

//   int index = 1;
//   final sheet = excel['Sheet1'];
  
//   List<CellValue> dataList;
//   dataList = [TextCellValue('ITEM'), TextCellValue('APELLIDO PATERNO'), TextCellValue('APELLIDO MATERNO'), TextCellValue('NOMBRES'), TextCellValue('DNI'), TextCellValue('ÁREA'), TextCellValue('OBSERVACIÓN')];

//   sheet.insertRowIterables(dataList, 0);
//   sheet.setMergedCellStyle(new CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0), headerStyle);
//   String nombreArchivo = '';
//   for (var asistente in jsonData) {
//     // print(asistente);
//     dataList = [TextCellValue(index.toString()), TextCellValue(asistente['a_paterno']), TextCellValue(asistente['a_materno']), TextCellValue(asistente['nombres']), TextCellValue(asistente['dni']), TextCellValue(asistente['area']), TextCellValue(asistente['observacion'])];
//     sheet.insertRowIterables(dataList, index);
//     nombreArchivo = asistente['nombre_archivo'];
//     index++;
//   }
//   // Crear una hoja de trabajo (sheet)


//   // Guardar el archivo Excel
//   var directory = '/storage/emulated/0/Download/$nombreArchivo.xlsx'; // Cambia la ruta según tu necesidad
    

//   //stopwatch.reset();
//   List<int>? fileBytes = excel.save();
//   //print('saving executed in ${stopwatch.elapsed}');
//   print(fileBytes != null);
//   if (fileBytes != null) {
//     File(directory)
//       ..createSync(recursive: true)
//       ..writeAsBytesSync(fileBytes);
//   }
// }




// import 'dart:convert';
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:excel/excel.dart';
// import 'package:flutter/services.dart' show rootBundle;
// import 'package:permission_handler/permission_handler.dart';

// Future<void> generateExcelFromJson(String jsonString) async {
//   try {
//     // Decodificar el JSON
//     final jsonData = jsonDecode(jsonString);

//     // Leer la plantilla de Excel desde los assets
//     ByteData data = await rootBundle.load('assets/formato_capacitacion.xlsx');
//     List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
//     var excel = Excel.decodeBytes(bytes);

//     // Verificar si la hoja existe
//     final sheet = excel['CAPACITACION'];
//     if (sheet == null) {
//       print('Error: La hoja de trabajo "CAPACITACION" no existe.');
//       return;
//     }

//     // Definir el nombre del archivo
//     String nombreArchivo = 'archivo_finisimo';

//     // Mantener anchos de columnas y alturas de filas
//     // Obtén los anchos de columna

//     // Map<int, double> columnWidths = {};
//     // for (int colIndex = 0; colIndex < sheet.maxColumns; colIndex++) {
//     //   columnWidths[colIndex] = sheet.getColumnWidth(colIndex);
//     // }

//     // // Obtén las alturas de filas
//     // Map<int, double> rowHeights = {};
//     // for (int rowIndex = 0; rowIndex < sheet.maxRows; rowIndex++) {
//     //   rowHeights[rowIndex] = sheet.getRowHeight(rowIndex);
//     // }

//     // Llenar datos en celdas combinadas con verificación de celdas
//     try {
//       // Celda A10-F10 (una sola celda combinada)
//       sheet.updateCell(CellIndex.indexByString("A10"), TextCellValue("X"));

//       // Celda G11-AG11 (una sola celda combinada)
//       sheet.updateCell(CellIndex.indexByString("G11"), TextCellValue("X"));

//       // Celda G12-AG12 (una sola celda combinada)
//       sheet.updateCell(CellIndex.indexByString("G12"), TextCellValue("X"));

//       // Celda G13-Q13 (una sola celda combinada)
//       sheet.updateCell(CellIndex.indexByString("G13"), TextCellValue("X"));

//       // Celda G14-Q14 (una sola celda combinada)
//       sheet.updateCell(CellIndex.indexByString("G14"), TextCellValue("X"));
//     } catch (e) {
//       print('Error al actualizar celdas: $e');
//       return;
//     }

//     // // // // // // // Restaurar anchos de columnas y alturas de filas
//     // // // // // // columnWidths.forEach((colIndex, width) {
//     // // // // // //   if (width != null) {
//     // // // // // //     sheet.setColumnWidth(colIndex, width);
//     // // // // // //   }
//     // // // // // // });

//     // // // // // // rowHeights.forEach((rowIndex, height) {
//     // // // // // //   if (height != null) {
//     // // // // // //     sheet.setRowHeight(rowIndex, height);
//     // // // // // //   }
//     // // // // // // });

//     // // Solicitar permisos
//     // var status = await Permission.storage.status;
//     // if (!status.isGranted) {
//     //   status = await Permission.storage.request();
//     //   if (!status.isGranted) {
//     //     // Si el permiso no es concedido, manejar el error
//     //     print('Permiso de almacenamiento denegado');
//     //     return;
//     //   }
//     // }

//     // Guardar el archivo Excel
//     var directory = '/storage/emulated/0/Download/$nombreArchivo.xlsx'; // Cambia la ruta según tu necesidad

//     // Guardar el archivo modificado
//     List<int>? fileBytes = excel.save();
//     if (fileBytes != null) {
//       File(directory)
//         ..createSync(recursive: true)
//         ..writeAsBytesSync(fileBytes);
//       print('Archivo guardado exitosamente en $directory');
//     } else {
//       print('Error al guardar el archivo');
//     }
//   } catch (e) {
//     print('Error al generar el archivo Excel: $e');
//   }
// }




import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

Future<void> generateExcelFromJson(String jsonString) async {
  try {
    // Decodificar el JSON
    final jsonData = jsonDecode(jsonString);

    // Leer la plantilla de Excel desde los assets
    ByteData data = await rootBundle.load('assets/formato_capacitacion.xlsx');
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    // Usar SpreadsheetDecoder para decodificar el archivo
    var decoder = SpreadsheetDecoder.decodeBytes(bytes, update: true);

    // Obtener la hoja de trabajo
    var sheet = decoder.tables['CAPACITACION'];
    if (sheet == null) {
      print('Error: La hoja de trabajo "CAPACITACION" no existe.');
      return;
    }
    // Definir el nombre del archivo
    String nombreArchivo = 'archivo_finisimo';

    // Llenar datos en celdas combinadas
    // Celda A10-F10 (una sola celda combinada)
    decoder.updateCell('CAPACITACION', 3, 9, 'X');  // Fila 10 (índice 9), Columna A (índice 0)

    // Celda G11-AG11 (una sola celda combinada)
    decoder.updateCell('CAPACITACION', 7, 10, 'MANEJO DEFENSIVO'); // Fila 11 (índice 10), Columna G (índice 7)

    // Celda G12-AG12 (una sola celda combinada)
    decoder.updateCell('CAPACITACION', 7, 11, '2024-05-27'); // Fila 12 (índice 11), Columna G (índice 7)

    // Celda G13-Q13 (una sola celda combinada)
    decoder.updateCell('CAPACITACION', 7, 12, 'DENNIS VARGAS MEOÑO'); // Fila 13 (índice 12), Columna G (índice 7)

    // Celda G14-Q14 (una sola celda combinada)
    decoder.updateCell('CAPACITACION', 7, 13, '1 hora'); // Fila 14 (índice 13), Columna G (índice 7)

    // // Solicitar permisos
    // var status = await Permission.storage.status;
    // if (!status.isGranted) {
    //   status = await Permission.storage.request();
    //   if (!status.isGranted) {
    //     // Si el permiso no es concedido, manejar el error
    //     print('Permiso de almacenamiento denegado');
    //     return;
    //   }
    // }

    // Guardar el archivo Excel
    // Directory? directory = await getExternalStorageDirectory();
    // var path = '${directory.path}/$nombreArchivo.xlsx'; // Cambia la ruta según tu necesidad
    var path = '/storage/emulated/0/Download/$nombreArchivo.xlsx'; // Cambia la ruta según tu necesidad

    // Guardar el archivo modificado
    var file = File(path);
    await file.writeAsBytes(decoder.encode());

    print('Archivo guardado exitosamente en $path');
  } catch (e) {
    print('Error al generar el archivo Excel: $e');
  }
}
