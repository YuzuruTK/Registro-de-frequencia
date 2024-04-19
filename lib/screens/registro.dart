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
    final snackBar = SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {
          // Some action to perform when 'OK' is pressed
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

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
          Container(
            height: size.height * 0.1,
            width: size.width * 0.5,
            child: ElevatedButton(
                onPressed: () {
                  final agora = DateTime.now();
                  // String data = "${agora.year}-${agora.month}-${agora.day}";
                  String data = agora.toIso8601String();
                  String entrada =
                      "${agora.hour}:${agora.minute}:${agora.second}";
                  Connection().insert(data, entrada);
                  showCustomSnackbar(context, "Ponto Registrado");
                },
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(corsim[0]!.withOpacity(0.2))),
                child: Text(
                  "Registre o Ponto",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withOpacity(0.7)),
                )),
          ),
          Container(
            height: size.height * 0.1,
            width: size.width * 0.5,
            child: ElevatedButton(
                onPressed: () {
                  Connection.onCreate();
                  // Connection().select();
                },
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(corsim[0]!.withOpacity(0.2))),
                child: Text(
                  "Primeiro Acesso",
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
