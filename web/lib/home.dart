import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _produtos = [];

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
        var tbValor25 = card.getElementsByClassName('tb-valor-25');
        for (var valor in tbValor25) {
          setState(() {
            _produtos.add({
              "item": title.text.trim(),
              "valor": valor.text.trim(),
            });
          });
        }
      }
    }
  }

  _limpar() {
    setState(() {
      _produtos.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Image.asset("assets/logo.png"),
              Text(
                "Começe a economizar agora!",
                style: TextStyle(color: Colors.green, fontSize: 25),
              )
            ],
          ),
        ),
      ),
    );
  }
}

    
    
    
    
    
    
    
    
    /*Scaffold(
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
                  _limpar();
                },
                child: const Text('Clique aqui'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: ElevatedButton(
                onPressed: () {
                  _limpar();
                },
                child: const Text('Limpar'),
              ),
            ),
            const Text("Quantidade itens"),
            Text(_produtos.length.toString()),
            Expanded(
              child: ListView.builder(
                itemCount: _produtos.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      // print("Item $_item clicado");
                    },
                    trailing: Text(_produtos[index]['valor'].trim()),
                    title: Text(
                      _produtos[index]['item'].trim(),
                      style: const TextStyle(
                          fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
            ),
          ],
        ));
  }
}
*/
