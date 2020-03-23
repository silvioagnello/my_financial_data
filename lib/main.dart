import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:my_financial_data/home_bloc.dart';

void main() async {
  runApp(MaterialApp(
    home: Home(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
          hintStyle: TextStyle(color: Colors.amber),
        )),
  ));
}


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  HomeBloc bloc = HomeBloc();

  void _clearAll() {
    bloc.realController.text = "";
    bloc.dolarController.text = "";
    bloc.euroController.text = "";
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("\$ Conversor \$"),
        backgroundColor: Colors.amber,
        centerTitle: true,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.refresh), onPressed: _clearAll)
        ],
      ),
      body: FutureBuilder<Map>(
        future: bloc.getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(
                  child: Text("Carregando dados...",
                      style: TextStyle(color: Colors.amber, fontSize: 25.0),
                      textAlign: TextAlign.center));
            default:
              if (snapshot.hasError) {
                return Center(
                    child: Text("Erro ao carregar dados!!!",
                        style: TextStyle(color: Colors.amber, fontSize: 25.0),
                        textAlign: TextAlign.center));
              } else {
                bloc.setValue();
                return SingleChildScrollView(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(
                        Icons.monetization_on,
                        size: 100.0,
                        color: Colors.amber,
                      ),
                      Divider(),
                      buildTextField(
                          "Reais", "R\$", true, bloc.realController, bloc.valueChanged),
                      Divider(),
                      buildTextField("Dolares", "US\$", false, bloc.dolarController,
                          bloc.valueChanged),
                      Divider(),
                      buildTextField(
                          "Euros", "€", false, bloc.euroController, bloc.valueChanged)
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}

TextField buildTextField(String label, String prefix, bool focus,
    TextEditingController c, Function f) {
  return TextField(
    autofocus: focus,
    controller: c,
    decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.amber),
        border: OutlineInputBorder(),
        prefixText: prefix),
    style: TextStyle(color: Colors.amber, fontSize: 25.0),
    onChanged: f,
    keyboardType: TextInputType.number,
  );
}
