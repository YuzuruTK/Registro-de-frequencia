import 'dart:developer';
import 'package:sqflite/sqflite.dart';

class Connection {
  Future<Database> connectDb() async {
    late Database db;
    try {
      final path = getDatabasesPath();
      db = await openDatabase("$path/registro.db");
      db.rawQuery("Select * from registro");
    } catch (e) {
      log(e.toString());
    }
    return db;
  }

  static onCreate() async {
    final path = getDatabasesPath();
    log("SOCORRO");
    final db = await openDatabase("$path/registro.db");
    String sql = """
                  --DROP TABLE IF EXISTS registro;

                  CREATE TABLE registro (
	                dia TEXT,
	                ID INTEGER NOT NULL,
                  entrada TEXT,
                  saida TEXT,
                  CONSTRAINT registro_pk PRIMARY KEY (ID)
                  );
                """;
    log("Table deletada, Table Criada");
    db.execute(sql);
    db.close();
  }

  Future<List<Map<String, Object?>>> select() async {
    final db = await connectDb();
    // String sql = "Select * from registro";
    final query = await db.query("registro");
    db.close();
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

  insert(String dia, String horaEntrada) async {
    final db = await connectDb();
    final last_result = await lastResultSelect(db);
    if (last_result.isNotEmpty && last_result[0]["saida"] == "") {
      Map<String, Object?> updated_row = {
        "ID": last_result.toList()[0]["ID"],
        "dia": last_result.toList()[0]["dia"],
        "entrada": last_result.toList()[0]["entrada"],
        "saida": last_result.toList()[0]["saida"]
      };
      updated_row["saida"] = horaEntrada;
      final result = await db.update("registro", updated_row,
          where: "ID == ?", whereArgs: [updated_row["ID"]]);
      log("ATUALIZADO");
      if (result != 0) {
        db.close();
      } else {
        log("ERRO EM ATUALIZAR");
      }
    } else {
      final result = await db.insert(
          "registro", {"dia": dia, "entrada": horaEntrada, "saida": ""});
      log("INSERTED");
      if (result != 0) {
        db.close();
      } else {
        log("ERRO NO INSERT");
      }
    }
  }
}
