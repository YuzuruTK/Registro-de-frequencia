import 'package:flutter/material.dart';
import 'package:registro_de_ponto/colors.dart';

class Registro extends StatefulWidget {
  const Registro({Key? key}) : super(key: key);

  @override
  _RegistroState createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
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
          // Container(
          //     margin: EdgeInsets.fromLTRB(size.width * 0.2, size.width * 0.2,
          //         size.width * 0.2, size.height * 0.1),
          //     alignment: Alignment.center,
          //     decoration: BoxDecoration(
          //         color: Colors.black.withOpacity(0.2),
          //         borderRadius: BorderRadius.circular(20)),
          //     child: Text(
          //       "Registro do Ponto",
          //       style: TextStyle(
          //           fontSize: 25,
          //           fontWeight: FontWeight.bold,
          //           color: contrastColor),
          //     )),
          Container(
            height: size.height * 0.1,
            width: size.width * 0.5,
            child: ElevatedButton(
                onPressed: () {},
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
          )
        ],
      ),
    );
  }
}
