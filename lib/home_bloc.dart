import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeBloc {
  String request = "https://economia.awesomeapi.com.br/all/USD-BRL,EUR-BRL";

  Future<Map> getData([snapshot]) async {
    http.Response response = await http.get(request);
    return json.decode(response.body);
  }

  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  double real;
  double dolar;
  double euro;

  // final StreamController _streamController = StreamController.broadcast();

  // Sink get input => _streamController.sink;
  // Stream get output => _streamController.stream;

  void setValue() {
    getData().then((Map d) {
      euro = double.parse(d["EUR"]["high"]);
      dolar = double.parse(d["USD"]["high"]);
    });
  }

  valueChanged(text) {
    if (text == '') {
      realController.text = dolarController.text = euroController.text = '';
      return;
    }
    if (dolarController.text == text) {
      double dolar = double.parse(text);
      realController.text = (dolar * this.dolar).toStringAsFixed(2);
      euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
    } else {
      if (euroController.text == text) {
        double euro = double.parse(text);
        realController.text  = (euro * this.euro).toStringAsFixed(2);
        dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
      } else {
        if (realController.text == text) {
          double real = double.parse(text);
          dolarController.text = (real * this.dolar).toStringAsFixed(2);
          euroController.text  = (real * this.euro).toStringAsFixed(2);
        }
      }
    }
  }

  // void dispose() {
  //   _streamController.close();
  // }
}
