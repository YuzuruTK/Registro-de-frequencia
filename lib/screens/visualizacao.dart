import 'package:flutter/material.dart';
import 'package:registro_de_ponto/connection.dart';

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
    getRegisters();
  }

  getRegisters() async {
    final registers = await Connection().select();
    for (Map element in registers) {
      registros.addAll({
        element["dia"]: [element["entrada"], element["saida"]]
      });
    }
    setState(() {
      registros;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    List<DataColumn> getColumns() {
      List<DataColumn> columns = [];
      columns.add(DataColumn(label: Container(width: 40, child: Text("Data"))));
      columns
          .add(DataColumn(label: Container(width: 60, child: Text("Entrada"))));
      columns
          .add(DataColumn(label: Container(width: 60, child: Text("Saida"))));
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
        String dia = "${day.day}/${day.month} - ${weekdays[day.weekday]}";
        rows.add(DataRow(cells: [
          DataCell(Text(dia)),
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
              padding: EdgeInsets.all(5),
              child: DataTable(
                columns: getColumns(),
                rows: getRows(),
                border:
                    TableBorder.all(borderRadius: BorderRadius.circular(20)),
                headingTextStyle: TextStyle(fontSize: 15),
              ))
        ],
      ),
    );
  }
}
