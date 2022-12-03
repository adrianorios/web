import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _resultado = 'resultado';

  _recuperarCasos() async {
    String url =
        "https://buscapreco.sefaz.am.gov.br/item/grupo/page/1?termoCdGtin=&descricaoProd=dipirona&action=";
    http.Response response = await http.post(Uri.parse(url), headers: {
      "Accept": "application/json",
    });
    setState(() {
      _resultado = response.body;
      print(_resultado);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consumo de Serviços Web'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  _recuperarCasos();
                },
                child: const Text('Clique aqui'),
              ),
              Text(_resultado),
            ],
          ),
        ),
      ),
    );
  }
}
