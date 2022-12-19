import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:web/api.dart';
import 'package:web/detail.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _produtos = [];

  final TextEditingController _produtoController = TextEditingController();

  bool _exibirOBagulho = false;
  var _paginas = [];
  String _cookie = "";

  _recuperarCasos(pagina) async {
    setState(() {
      _exibirOBagulho = true;
    });
    
    var meusProdutos = [];
    if (pagina == 0) {
      meusProdutos = await Api.fetch("https://buscapreco.sefaz.am.gov.br/item/grupo/page/1?termoCdGtin=&descricaoProd=${_produtoController.text}&action=&consultaExata=true&_consultaExata=on", _cookie);
    } else {
      meusProdutos = await Api.fetch("https://buscapreco.sefaz.am.gov.br/item/grupo/page/" + pagina, _cookie);
    }
    
    setState(() {
      _produtos.clear();
      _paginas.clear();
      _produtos.addAll(meusProdutos[0]);
      _paginas.addAll(meusProdutos[1]);
      if (meusProdutos[2].isNotEmpty) { 
        _cookie = meusProdutos[2];
      }
    });
    
    

    setState(() {
      _exibirOBagulho = false;
    });
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: SingleChildScrollView(
              child: Column(children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.9,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/logo.png",
                        height: 200,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 15, right: 15, left: 15),
                        child: Image.asset(
                          "assets/economizar.png",
                          height: 30,
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 20, right: 25, left: 25),
                        child: TextFormField(
                          controller: _produtoController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.withAlpha(50),
                            isDense: true,
                            hintText: "Digite o produto que deseja procurar",
                            hintStyle: TextStyle(
                                color: Colors.grey.shade200, fontSize: 14),
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
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: SizedBox(
                          height: 50,
                          width: 150,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _exibirOBagulho
                                  ? Colors.grey
                                  : const Color(0xFF4CAF50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            onPressed: () {
                              if (!_exibirOBagulho) {
                                _recuperarCasos(0);
                                _limpar();
                              }
                            },
                            child: const Text(
                              "Pesquisar",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: _exibirOBagulho == true
                            ? const SizedBox(
                                width: 100,
                                child: LoadingIndicator(
                                  indicatorType: Indicator.ballBeat,
                                  colors: [Color(0xFF4CAF50)],
                                  strokeWidth: 3,
                                ),
                              )
                            : ListView.builder(
                                itemCount: _produtos.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    child: Card(
                                      child: ListTile(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CardDetailsPage(
                                                        _produtos[index]
                                                            ["item"],
                                                        _produtos[index]
                                                            ["endereco"],
                                                        _produtos[index]
                                                            ["valor"],
                                                        _produtos[index]
                                                            ["loja"],
                                                      )));
                                        },
                                        trailing: Text(
                                          _produtos[index]['valor'].trim(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        title: Text(
                                          _produtos[index]['item'].trim(),
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: _produtos.isNotEmpty,
                  child: SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _paginas.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: SizedBox(
                            height: 10,
                            width: 40,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _exibirOBagulho
                                    ? Colors.grey
                                    : const Color(0xFF4CAF50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  _exibirOBagulho = true;
                                  _recuperarCasos(_paginas[index].toString());
                                });
                              },
                              child: Text(
                                _paginas[index].toString(),
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              ]),
            ),
          ),
        ),
      ),
    );
  }
}