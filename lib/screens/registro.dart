// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:registro_de_ponto/colors.dart';
import 'package:registro_de_ponto/connection.dart';

class Registro extends StatefulWidget {
  const Registro({super.key});

  @override
  _RegistroState createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  void showCustomSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  bool cooldown = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
            Colors.white,
            Colors.grey.withOpacity(0.6),
          ])),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Botão
          SizedBox(
            height: size.height * 0.1,
            width: size.width * 0.8,
            child: IgnorePointer(
              ignoring: cooldown,
              child: ElevatedButton(
                  onPressed: () async {
                    final agora = DateTime.now();
                    String entrada =
                        "${agora.hour}:${agora.minute}:${agora.second}";
                    Connection().insert(agora, entrada);
                    showCustomSnackbar(context, "Ponto Registrado");
                    setState(() {
                      cooldown = true;
                    });
                    await Future.delayed(const Duration(seconds: 2));
                    setState(() {
                      cooldown = false;
                    });
                  },
                  style: ButtonStyle(
                      backgroundColor: cooldown
                          ? const WidgetStatePropertyAll(Colors.black54)
                          : WidgetStatePropertyAll(
                              corsim[0]!.withOpacity(0.2))),
                  child: Text(
                    cooldown ? "Registrando" : "Registre o Ponto",
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white.withOpacity(0.7)),
                  )),
            ),
          ),

          SizedBox(
            height: size.height * 0.1,
            width: size.width * 0.5,
            child: ElevatedButton(
                onPressed: () async {
                  final pathing = await Connection.exportDatabase();

                  showCustomSnackbar(context, pathing.toString());
                },
                style: ButtonStyle(
                    backgroundColor:
                        WidgetStatePropertyAll(corsim[0]!.withOpacity(0.2))),
                child: Text(
                  "Exportação de Base de Dados",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withOpacity(0.7)),
                )),
          )
        ],
      ),
    );
  }
}
