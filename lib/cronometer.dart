import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Cronometer extends StatefulWidget {
  const Cronometer({super.key});

  @override
  _CronometerState createState() => _CronometerState();
}

class _CronometerState extends State<Cronometer> {
  int milisegundos = 0;
  late Timer timer;
  bool estaCorriendo = false;

  void iniciarCronometro() {
    if (!estaCorriendo) {
      timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
        this.milisegundos += 10;
        setState(() {});
        estaCorriendo = true;
      });
    }
  }

  void detenerCronometro() {
    timer.cancel();
    estaCorriendo = false;
  }

  String formatearTiempo() {
    Duration duration = Duration(milliseconds: this.milisegundos);

    String dosValores(int valor) {
      return valor >= 10 ? "$valor" : "0$valor";
    }

    String horas = dosValores(duration.inHours);
    String minutos = dosValores(duration.inMinutes.remainder(60));
    String segundos = dosValores(duration.inSeconds.remainder(60));
    String milisegundos = dosValores(duration.inMilliseconds.remainder(1000));

    String trim = milisegundos.substring(0, 2);

    return "$horas:$minutos:$segundos:$trim";
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Text(formatearTiempo(), style: TextStyle(fontSize: 50)),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CupertinoButton(
              child: Icon(Icons.not_started_outlined,
                  color: Colors.green, size: 50),
              onPressed: iniciarCronometro),
          CupertinoButton(
              child: Icon(Icons.stop_outlined, size: 50, color: Colors.red),
              onPressed: detenerCronometro),
        ],
      ),
      CupertinoButton(
          child: Icon(Icons.restart_alt, size: 50, color: Colors.orange),
          onPressed: () {
            this.milisegundos = 0;
            setState(() {});
          }),
    ]);
  }
}
