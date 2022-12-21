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

  bool _exibirLoading = false;
  final _paginas = [];
  String _cookie = "";
  String _textoPag = "";

  _pesquisarProd(pagina) async {
    setState(() {
      _exibirLoading = true;
      _textoPag = "Páginas:";
    });

    var meusProdutos = [];
    if (pagina == 0) {
      meusProdutos = await Api.fetch(
          "https://buscapreco.sefaz.am.gov.br/item/grupo/page/1?termoCdGtin=&descricaoProd=${_produtoController.text}&action=&consultaExata=true&_consultaExata=on",
          _cookie);
    } else {
      meusProdutos = await Api.fetch(
          "https://buscapreco.sefaz.am.gov.br/item/grupo/page/$pagina",
          _cookie);
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
      _exibirLoading = false;
      _textoPag = "Páginas:";
    });
  }

  _limpar() {
    setState(() {
      _produtos.clear();
      _textoPag = "";
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
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/logo.png",
                        color: const Color(0xFF4CAF50),
                        height: 200,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Image.asset(
                          "assets/economizar.png",
                          height: 25,
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 15, right: 15, left: 15),
                        child: TextFormField(
                          controller: _produtoController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.withAlpha(50),
                            isDense: true,
                            hintText: "Digite o produto que deseja procurar",
                            hintStyle: const TextStyle(
                                color: Colors.black54, fontSize: 14),
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
                        padding: const EdgeInsets.all(15.0),
                        child: SizedBox(
                          height: 50,
                          width: 200,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _exibirLoading
                                  ? Colors.grey
                                  : const Color(0xFF4CAF50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            onPressed: () {
                              if (!_exibirLoading) {
                                _pesquisarProd(0);
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
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(_textoPag),
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
                                padding: const EdgeInsets.only(
                                    left: 8, right: 8, bottom: 10),
                                child: SizedBox(
                                  width: 50,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: _exibirLoading
                                          ? Colors.grey
                                          : const Color(0xFF4CAF50),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _exibirLoading = true;
                                        _pesquisarProd(
                                            _paginas[index].toString());
                                      });
                                    },
                                    child: Text(
                                      _paginas[index].toString(),
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      _exibirLoading == true
                          ? const SizedBox(
                              width: 150,
                              child: LoadingIndicator(
                                indicatorType: Indicator.ballSpinFadeLoader,
                                colors: [Color(0xFF4CAF50)],
                                strokeWidth: 3,
                              ),
                            )
                          : Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: ListView.builder(
                                  itemCount: _produtos.length,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      child: ListTile(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  CardDetailsPage(
                                                _produtos[index]["item"],
                                                _produtos[index]["endereco"],
                                                _produtos[index]["valor"],
                                                _produtos[index]["loja"],
                                              ),
                                            ),
                                          );
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
                                    );
                                  },
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
