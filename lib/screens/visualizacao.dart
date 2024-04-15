import 'package:flutter/material.dart';

class Visualizacao extends StatefulWidget {
  const Visualizacao({Key? key}) : super(key: key);

  @override
  _VisualizacaoState createState() => _VisualizacaoState();
}

class _VisualizacaoState extends State<Visualizacao> {
  Map registros = {};

  @override
  void initState() {
    super.initState();
    registros.addAll({
      "2024-04-13": ["15:28", "17:30"]
    });
  }

  @override
  Widget build(BuildContext context) {
    List<DataColumn> getColumns() {
      List<DataColumn> columns = [];
      columns.add(DataColumn(label: Text("Data")));
      columns.add(DataColumn(label: Text("Ponto Entrada")));
      columns.add(DataColumn(label: Text("Ponto Saida")));
      return columns;
    }

    List<DataRow> getRows() {
      List<DataRow> rows = [];
      List weekdays = [
        "Domingo",
        "Segunda",
        "Terça",
        "Quarta",
        "Quinta",
        "Sexta",
        "Sabado"
      ];
      for (String data in registros.keys) {
        DateTime day = DateTime.parse(data);
        rows.add(DataRow(cells: [
          DataCell(
              Text("${day.day} / ${day.month} - ${weekdays[day.weekday]}")),
          DataCell(Text(registros[data][0])),
          DataCell(Text(registros[data][1]))
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
      child: Column(
        children: [
          Container(
              padding: EdgeInsets.all(20),
              child: DataTable(
                columns: getColumns(),
                rows: getRows(),
                border:
                    TableBorder.all(borderRadius: BorderRadius.circular(20)),
              ))
        ],
      ),
    );
  }
}
