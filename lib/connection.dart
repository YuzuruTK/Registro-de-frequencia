import 'package:sqflite/sqflite.dart';

class connection {
  Future<Database> openMyDatabase() async {
    final database = openDatabase("registro.db");
    return database;
  }
}
