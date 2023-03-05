import 'dart:async';
import 'dart:math';

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

  late Timer timer;
  bool estaCorriendo = false;
  List<int> tiemposMeta = [];
  List<int> tiemposTotal = [];

  void iniciarCronometro() {
    if (!estaCorriendo) {
      timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
        milisegundos += 10;
        setState(() {});
      });
      estaCorriendo = true;
    }
  }

  void detenerCronometro() {
    timer.cancel();
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
        Text(formatearTiempo(milisegundos),
            style: const TextStyle(fontSize: 50, color: Colors.white)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CupertinoButton(
                onPressed: iniciarCronometro,
                child: const Icon(Icons.not_started_outlined,
                    color: Colors.green, size: 50)),
            CupertinoButton(
                onPressed: detenerCronometro,
                child: const Icon(Icons.stop_outlined,
                    size: 50, color: Colors.red)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CupertinoButton(
                child: const Icon(Icons.check_circle_outline,
                    size: 50, color: Colors.orange),
                onPressed: () {
                  if (estaCorriendo) {
                    if (tiemposMeta.isEmpty) {
                      tiemposMeta.insert(
                        0,
                        milisegundos,
                      );
                    } else {
                      tiemposMeta.insert(0, milisegundos - submili);
                    }
                    tiemposTotal.insert(
                      0,
                      (milisegundos),
                    );
                    submili = milisegundos;
                    setState(() {});
                  }
                }),
            CupertinoButton(
                child: const Icon(Icons.restart_alt,
                    size: 50, color: Colors.orange),
                onPressed: () {
                  milisegundos = 0;
                  submili = 0;
                  tiemposMeta.clear();
                  tiemposTotal.clear();
                  setState(() {});
                }),
          ],
        ),
        ListTile(
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'Vueltas',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ],
          ),
          title: const Padding(
            padding: EdgeInsets.only(right: 60.0),
            child: Text('Tiempo',
                style: TextStyle(fontSize: 20, color: Colors.white),
                textAlign: TextAlign.center),
          ),
          trailing: const Padding(
            padding: EdgeInsets.only(right: 60.0),
            child: Text('Total',
                style: TextStyle(fontSize: 20, color: Colors.white)),
          ),
        ),
        Expanded(
          child: Container(
              color: Colors.black,
              child: ListView.separated(
                  itemBuilder: (context, index) {
                    String tiempo;
                    String subtiempo;
                    int length = tiemposMeta.length;
                    Color color = Colors.white;
                    if (tiemposMeta.isEmpty) {
                      return const Text('');
                    }
                    if (index == 0) {
                      tiempo = formatearTiempo(milisegundos - submili);
                      subtiempo = formatearTiempo(milisegundos);
                    } else {
                      tiempo = formatearTiempo(tiemposMeta[index - 1]);
                      subtiempo = formatearTiempo(tiemposTotal[index - 1]);
                      if (tiemposMeta[index - 1] == tomarMayor(tiemposMeta)) {
                        color = Colors.red;
                      }
                      if (tiemposMeta[index - 1] == tomarMenor(tiemposMeta)) {
                        color = Colors.green;
                      }
                    }
                    return ListTile(
                      leading: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${(length - index) + 1}',
                            style: TextStyle(fontSize: 20, color: color),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      trailing: Text(subtiempo,
                          style: TextStyle(fontSize: 20, color: color),
                          textAlign: TextAlign.end),
                      title: Text(tiempo,
                          style: TextStyle(fontSize: 20, color: color),
                          textAlign: TextAlign.center),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Divider(
                      color: Colors.white38,
                      thickness: 2,
                    );
                  },
                  itemCount: tiemposMeta.length + 1)),
        ),
      ]),
    );
  }

  int tomarMayor(List<int> lista) {
    return lista.reduce(max);
  }

  int tomarMenor(List<int> lista) {
    return lista.reduce(min);
  }
}
