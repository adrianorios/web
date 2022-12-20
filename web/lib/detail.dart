import 'package:flutter/material.dart';

class CardDetailsPage extends StatelessWidget {
  final String name;
  final String endereco;
  final String valor;
  final String loja;

  const CardDetailsPage(this.name, this.endereco, this.valor, this.loja,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF4CAF50),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        bottomNavigationBar: Container(
          color: Colors.grey,
          height: 60,
        ),
        body: Column(
          children: [
            const Expanded(
              child: Center(
                child: Text(
                  "Detalhe do produto",
                  style: TextStyle(color: Colors.white, fontSize: 35),
                ),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 40),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(45),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.green.shade200,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10, top: 25),
                      child: Text(
                        valor,
                        style: const TextStyle(
                            fontSize: 25,
                            color: Color.fromARGB(255, 1, 60, 108),
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10, top: 10),
                      child: Text(
                        loja,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20, top: 20),
                      child: Text(
                        "Endereço: $endereco",
                        style: const TextStyle(fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Row(
                      children: const [
                        Icon(
                          Icons.warning,
                          color: Colors.amber,
                        ),
                        Text(
                          "   Aviso Legal",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 8, left: 8, top: 8),
                      child: Text(
                        // ignore: prefer_interpolation_to_compose_strings, prefer_adjacent_string_concatenation
                        "       As informações exibidas pelo sistema Busca Preço Amazonas " +
                            "são públicas, obtidas a partir das Notas Fiscais de Consumidor " +
                            "Eletrônica (NFC-e), e não configuram anúncios por parte dos " +
                            "estabelecimentos emitentes, podendo haver alteração de preços " +
                            "ou indisponibilidade de produtos em qualquer momento posterior " +
                            "à emissão da nota fiscal. O sistema não exibe valores de operações " +
                            "entre pessoas jurídicas acobertadas por Notas Fiscais " +
                            "Eletrônicas modelo 55 (NF-e).",
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
