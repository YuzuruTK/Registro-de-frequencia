// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:registro_de_ponto/connection.dart';
import 'package:intl/intl.dart';

class Visualizacao extends StatefulWidget {
  const Visualizacao({super.key});

  @override
  _VisualizacaoState createState() => _VisualizacaoState();
}

class _VisualizacaoState extends State<Visualizacao> {
  Map registros = {};
  List<DateTime> datas = [];
  int actualMonth = DateTime.now().month;

  @override
  void initState() {
    super.initState();
    getRegisters(actualMonth);
  }

  getRegisters(int month) async {
    registros = {};
    DateTime now = DateTime.now();
    final registers = await Connection().select(DateTime(now.year, month, 1),
        DateTime(now.year, month, now.day).add(const Duration(days: 1)));
    for (Map element in registers) {
      registros.addAll({
        // "2024-04-22": ["10/04", "10/05"]
        element["dia"]: [element["entrada"], element["saida"]]
      });
    }
    setState(() {
      registros;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.sizeOf(context);
    Duration saldoTotal = const Duration(seconds: 0);

    List<DataColumn> getColumns() {
      List<DataColumn> columns = [];
      columns.add(
          const DataColumn(label: SizedBox(width: 40, child: Text("Data"))));
      columns.add(
          const DataColumn(label: SizedBox(width: 60, child: Text("Entrada"))));
      columns.add(
          const DataColumn(label: SizedBox(width: 40, child: Text("Saida"))));
      columns.add(
          const DataColumn(label: SizedBox(width: 40, child: Text("Saldo"))));
      return columns;
    }

    List<DataRow> getRows() {
      List<DataRow> rows = [];
      List weekdays = [
        "Nada",
        "Segunda",
        "Terça",
        "Quarta",
        "Quinta",
        "Sexta",
        "Sabado",
        "Domingo"
      ];
      for (String data in registros.keys) {
        DateTime day = DateTime.parse(data);
        String dia = "${day.day}/${day.month} - ${weekdays[day.weekday]}";
        final timeFormat = DateFormat("HH:mm:ss");
        final entrada = timeFormat.parse(registros[data][0]);

        final saida = registros[data][1] != ""
            ? timeFormat.parse(registros[data][1])
            : DateTime(0);
        Duration saldo = registros[data][1] != ""
            ? saida.difference(entrada)
            : Duration.zero;
        saldoTotal += saldo;
        rows.add(DataRow(cells: [
          DataCell(Text(dia)),
          DataCell(Text(timeFormat.format(entrada))),
          DataCell(Text(timeFormat.format(saida))),
          DataCell(Text(saldo.toString().split('.').first.padLeft(8, "0")))
        ]));
      }

      return rows;
    }

    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
            Colors.white,
            Colors.grey.withOpacity(0.6),
          ])),
      child: ListView(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(20),
              ),
              child: DropdownButton(
                underline: const Text(""),
                elevation: 4,
                value: actualMonth,
                borderRadius: BorderRadius.circular(20),
                items: const [
                  DropdownMenuItem(value: 1, child: Text("Janeiro")),
                  DropdownMenuItem(value: 2, child: Text("Fevereiro")),
                  DropdownMenuItem(value: 3, child: Text("Março")),
                  DropdownMenuItem(value: 4, child: Text("Abril")),
                  DropdownMenuItem(value: 5, child: Text("Maio")),
                  DropdownMenuItem(value: 6, child: Text("Junho")),
                  DropdownMenuItem(value: 7, child: Text("Julho")),
                  DropdownMenuItem(value: 8, child: Text("Agosto")),
                  DropdownMenuItem(value: 9, child: Text("Setembro")),
                  DropdownMenuItem(value: 10, child: Text("Outubro")),
                  DropdownMenuItem(value: 11, child: Text("Novembro")),
                  DropdownMenuItem(value: 12, child: Text("Dezembro")),
                ],
                onChanged: (month) {
                  DateTime now = DateTime.now();
                  // DateTime teste = DateTime(now.year, month ?? now.month);
                  setState(() {
                    actualMonth = month ?? now.month;
                  });
                },
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  getRegisters(actualMonth);
                },
                child: const Text("Atualizar"))
          ]),
          Container(
              padding: const EdgeInsets.all(5),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: getColumns(),
                  rows: getRows(),
                  border:
                      TableBorder.all(borderRadius: BorderRadius.circular(20)),
                  headingTextStyle: const TextStyle(fontSize: 15),
                ),
              )),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(4),
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black.withOpacity(0.1)),
            child: Text(
                "Saldo Total: ${saldoTotal.toString().split('.').first.padLeft(8, "0")}"),
          )
        ],
      ),
    );
  }
}
