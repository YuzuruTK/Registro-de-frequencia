import 'dart:developer';
import 'package:sqflite/sqflite.dart';

class Connection {
  Future<Database> connectDb() async {
    late Database db;
    try {
      final path = getDatabasesPath();
      db = await openDatabase("$path/registro.db");
      db.rawQuery("Select * from registro limit 1");
    } catch (e) {
      onCreate();
      log(e.toString());
    }
    return db;
  }

  static onCreate() async {
    final path = getDatabasesPath();
    Database db = await openDatabase("$path/registro.db");
    db.execute("DROP TABLE IF EXISTS registro;");
    db.close();
    log("Table deletada");
    String sql = """
                  CREATE TABLE registro (
	                dia TEXT,
	                ID INTEGER NOT NULL,
                  entrada TEXT,
                  saida TEXT,
                  CONSTRAINT registro_pk PRIMARY KEY (ID)
                  );
                """;
    db = await openDatabase("$path/registro.db");
    log("Table Criada");
    db.execute(sql);
    db.close();
  }

  Future<List<Map<String, Object?>>> select(
      DateTime initialDate, DateTime finalDate) async {
    final db = await connectDb();
    // String sql = "Select * from registro";
    final query = await db.query("registro",
        where: """ DATE(dia) BETWEEN DATE(?) AND DATE(?) """,
        whereArgs: [
          initialDate.toIso8601String(),
          finalDate.toIso8601String()
        ]);
    // final query = await db.rawQuery("""SELECT * FROM registro
    // WHERE DATE(dia) BETWEEN DATE("${initialDate.toIso8601String()}") AND DATE("${finalDate.toIso8601String()}")""");
    db.close();
    // log(query.toString());
    return query;
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
    bool isOnSameTurn = true;
    if (lastResult.isNotEmpty) {
      final actualTurn = dia.hour < 12
          ? 0
          : dia.hour <= 18
              ? 1
              : 2;

      final lastResultEntradaDate =
          (lastResult[0]["entrada"] as String).split(":");
      final lastResultTurn = int.parse(lastResultEntradaDate[0]) <= 12
          ? 0
          : int.parse(lastResultEntradaDate[0]) <= 18
              ? 1
              : 2;
      isOnSameTurn = actualTurn == lastResultTurn;
    }

    // SE O ULTIMO VALOR EXISTIR E NÃO POSSUIR VALOR NA SAIDA
    if (lastResult.isNotEmpty && lastResult[0]["saida"] == "" && isOnSameTurn) {
      Map<String, Object?> updatedRow = {
        "ID": lastResult.toList()[0]["ID"],
        "dia": lastResult.toList()[0]["dia"],
        "entrada": lastResult.toList()[0]["entrada"],
        "saida": lastResult.toList()[0]["saida"]
      };
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
