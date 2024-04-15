import 'package:flutter/material.dart';
import 'package:registro_de_ponto/colors.dart';
import 'package:registro_de_ponto/screens/registro.dart';
import 'package:registro_de_ponto/screens/visualizacao.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with SingleTickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    controller = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: TabBar(
            indicatorColor: corsim[0],
            labelColor: corsim[0]!.withOpacity(0.8),
            controller: controller,
            tabs: const [
              Tab(child: Text("Registro")),
              Tab(child: Text("Visualização"))
            ]),
        body: TabBarView(
          controller: controller,
          children: const [
            Registro(),
            Visualizacao(),
          ],
        ),
      ),
    );
  }
}
