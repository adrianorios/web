import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _item = '';
  String _valor = '';
  final TextEditingController _produtoController = TextEditingController();

  _recuperarCasos() async {
    String url =
        "https://buscapreco.sefaz.am.gov.br/item/grupo/page/1?termoCdGtin=&descricaoProd=${_produtoController.text}&action=&consultaExata=true&_consultaExata=on";

    http.Response response = await http.post(
      Uri.parse(url),
    );
    var document = parse(response.body);
    var cards = document.getElementsByClassName('card');
    for (var card in cards) {
      var cardTitle = card.getElementsByClassName('card-title');
      for (var title in cardTitle) {
        print(title.text.trim());

        var tbValor25 = card.getElementsByClassName('tb-valor-25');
        for (var valor in tbValor25) {
          setState(() {
            _item = title.text.trim();
            _valor = valor.text.trim();
            /*for (var card in cards) {
        var cardTitle = card.getElementsByClassName('card-title');
        for (var title in cardTitle) {
          print(title.text);

          _item = title.text;
        }

        var tbValor25 = card.getElementsByClassName('tb-valor-25');
        for (var valor in tbValor25) {
          print(valor.text.trim());
          _valor = valor.text;
        }
      }*/
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Consumo de + Web'),
        ),
        body: Column(
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
            const Text("Quantidade itens"),
            Text(_item.length.toString()),
            Expanded(
              child: ListView.builder(
                itemCount: _item.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      print("Item $_item clicado");
                    },
                    leading: const Icon(CupertinoIcons.zzz),
                    trailing: Text(_valor.trim()),
                    title: Text(
                      _item.trim(),
                      style:
                          TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
            ),
          ],
        ));
  }
}
