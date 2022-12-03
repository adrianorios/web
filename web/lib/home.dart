import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:html/parser.dart' show parse;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _resultado = 'resultado';
  final TextEditingController _produtoController = TextEditingController();

  _recuperarCasos() async {
    String url =
        "https://buscapreco.sefaz.am.gov.br/item/grupo/page/1?termoCdGtin=&descricaoProd=${_produtoController.text}&action=";
    http.Response response = await http.post(Uri.parse(url), headers: {
      "Accept": "application/json",
    });
    setState(() {
      _resultado = response.body;
      var document = parse(_resultado);

      var cards = document.getElementsByClassName('card');

      for (var card in cards) {
        var cardTitle = card.getElementsByClassName('card-title');
        for (var title in cardTitle) {
          print(title.text);
        }

        var tbValor25 = card.getElementsByClassName('tb-valor-25');
        for (var valor in tbValor25) {
          print(valor.text.trim());
        }
      }
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
              TextField(
                controller: _produtoController,
                decoration: const InputDecoration(
                  labelText: 'Digite o nome do produto',
                ),
                style: const TextStyle(fontSize: 14),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: ElevatedButton(
                  onPressed: () {
                    _recuperarCasos();
                  },
                  child: const Text('Clique aqui'),
                ),
              ),
              Text(_resultado),
            ],
          ),
        ),
      ),
    );
  }
}
