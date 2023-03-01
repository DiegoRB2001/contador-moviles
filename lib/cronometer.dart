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

  //Temporales
  int submili = 0;
  late Timer subtimer;

  late Timer timer;
  bool estaCorriendo = false;
  List<String> tiempos = [];

  void iniciarCronometro() {
    if (!estaCorriendo) {
      timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
        this.milisegundos += 10;
        setState(() {});
        estaCorriendo = true;
      });

      subtimer = Timer.periodic(Duration(milliseconds: 10), (timer) {
        this.submili += 10;
      });
    }
  }

  void detenerCronometro() {
    timer.cancel();
    subtimer.cancel();
    estaCorriendo = false;
  }

  String formatearTiempo(tiempo) {
    Duration duration = Duration(milliseconds: tiempo);

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
    return Padding(
      padding: const EdgeInsets.only(top: 150),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(formatearTiempo(this.milisegundos),
            style: TextStyle(fontSize: 50, color: Colors.white)),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CupertinoButton(
                child: Icon(Icons.check_circle_outline,
                    size: 50, color: Colors.orange),
                onPressed: () {
                  print('agregado');
                  tiempos.insert(
                    0,
                    formatearTiempo(this.submili),
                  );
                  submili = 0;
                  setState(() {});
                }),
            CupertinoButton(
                child: Icon(Icons.restart_alt, size: 50, color: Colors.orange),
                onPressed: () {
                  this.milisegundos = 0;
                  this.submili = 0;
                  tiempos.clear();
                  setState(() {});
                }),
          ],
        ),
        Expanded(
          child: Container(
              color: Colors.black,
              child: ListView.separated(
                  itemBuilder: (context, index) {
                    String tiempo;
                    int length = tiempos.length;
                    if (index == 0) {
                      tiempo = formatearTiempo(this.submili);
                    } else {
                      tiempo = tiempos[index - 1];
                    }
                    return ListTile(
                      leading: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Lap ${(length - index) + 1}',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ],
                      ),
                      title: Text(tiempo,
                          style: TextStyle(fontSize: 20, color: Colors.white),
                          textAlign: TextAlign.end),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Divider(
                      color: Colors.white38,
                      thickness: 2,
                    );
                  },
                  itemCount: tiempos.length + 1)),
        ),
      ]),
    );
  }
}
