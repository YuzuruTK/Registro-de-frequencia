import 'dart:developer';
import 'package:csv/csv.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class Connection {
  Future<Database> connectDb() async {
    late Database db;
    try {
      final path = getDatabasesPath();
      db = await openDatabase("$path/registro.db");
      final testquery = await db.rawQuery("Select * from registro limit 1");
    } catch (e) {
      log(e.toString());
      onCreate();
    }
    return db;
  }

  static onCreate() async {
    final path = getDatabasesPath();
    Database db = await openDatabase("$path/registro.db");
    // db.execute("DROP TABLE IF EXISTS registro;");
    // db.close();
    // log("Table deletada");
    String sql = """
                  CREATE TABLE registro (
	                dia TEXT,
	                ID INTEGER NOT NULL,
                  entrada TEXT,
                  saida TEXT,
                  CONSTRAINT registro_pk PRIMARY KEY (ID)
                  );
                """;
    // db = await openDatabase("$path/registro.db");
    db.execute(sql);
    log("Table Criada");
    final result =
        await db.query("SELECT name FROM sqlite_master WHERE type='table';");
    db.close();
  }

  Future<List<Map<String, Object?>>> select(
      DateTime initialDate, DateTime finalDate) async {
    final db = await connectDb();
    final query = await db.query("registro",
        where: """ DATE(dia) BETWEEN DATE(?) AND DATE(?) """,
        whereArgs: [
          initialDate.toIso8601String(),
          finalDate.toIso8601String()
        ]);
    db.close();
    return query;
  }

  static exportDatabase() async {
    final Databasepath = getDatabasesPath();
    Database db = await openDatabase("$Databasepath/registro.db");

    final query =
        await db.query("registro", columns: ["id", "dia", "entrada", "saida"]);
    log("Database Retrieved");

    List<List<dynamic>> rows = [
      ["id", "dia", "entrada", "saida"]
    ];

    query.forEach((x) => rows.add(x.values.toList()));
    log("Database converted to csv");

    final csv = const ListToCsvConverter().convert(rows);

    // Request storage permission if necessary
    if (await Permission.storage.request().isGranted) {
      // Get the Downloads directory
      Directory? downloadsDirectory = await getDownloadsDirectory();
      if (downloadsDirectory != null) {
        final filePath =
            path.join(downloadsDirectory.path, 'registro_de_ponto.csv');
        final file = File(filePath);

        // Write content to the file
        await file.writeAsString(csv);

        log('File saved to: $filePath');
        return filePath;
      } else {
        log('Unable to access the Downloads folder.');
      }
    } else {
      log('Storage permission denied.');
    }
  }

  Future<List<Map<String, Object?>>> lastResultSelect(Database db) async {
    String sql = """
    Select * from registro
    order by ID desc
    limit 1
    """;
    final query = await db.rawQuery(sql);
    return query;
  }

  insert(DateTime dia, String horaEntrada) async {
    final db = await connectDb();
    final lastResult = await lastResultSelect(db);
    bool isOnSameDay = true;

    if (lastResult.isNotEmpty) {
      // Data de Hoje
      final actualDate = dia;
      // Ultimo registro de data
      final lastDate = DateTime.parse((lastResult[0]["dia"] as String));
      // Caso ambos sejam no mesmo dia e mês é verdadeiro
      isOnSameDay = (actualDate.day == lastDate.day) &&
          (actualDate.month == lastDate.month);
    }

    // Caso exista um registro no banco sem saida e for no mesmo dia
    if (lastResult.isNotEmpty && lastResult[0]["saida"] == "" && isOnSameDay) {
      // cria um map com as informações da ultima linha
      Map<String, Object?> updatedRow = {
        "ID": lastResult.toList()[0]["ID"],
        "dia": lastResult.toList()[0]["dia"],
        "entrada": lastResult.toList()[0]["entrada"],
        "saida": lastResult.toList()[0]["saida"]
      };
      // altera a saida para o valor recem criado
      updatedRow["saida"] = horaEntrada;

      final result = await db.update("registro", updatedRow,
          where: "ID == ?", whereArgs: [updatedRow["ID"]]);
      log("ATUALIZADO");
      if (result != 0) {
        db.close();
      } else {
        log("ERRO EM ATUALIZAR");
      }
    } else {
      final result = await db.insert("registro",
          {"dia": dia.toIso8601String(), "entrada": horaEntrada, "saida": ""});
      log("INSERTED");
      if (result != 0) {
        db.close();
      } else {
        log("ERRO NO INSERT");
      }
    }
  }
}
