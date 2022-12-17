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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.info_rounded,
                color: Color(0xFF4CAF50),
              )),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Image.asset(
                "assets/logo.png",
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15, right: 15, left: 15),
                child: Image.asset(
                  "assets/economizar.png",
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, right: 25, left: 25),
                child: TextFormField(
                  controller: _produtoController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.withAlpha(50),
                    isDense: true,
                    hintText: "Digite o produto que deseja procurar",
                    hintStyle:
                        TextStyle(color: Colors.grey.shade400, fontSize: 14),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.black,
                      size: 21,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(60),
                      borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 20)),
              SizedBox(
                height: 50,
                width: 200,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  onPressed: () {
                    _recuperarCasos();
                    _limpar();
                  },
                  child: const Text(
                    "Pesquisar",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
