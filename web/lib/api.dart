import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

class Api {
  static fetch(url, _cookie) async {
    // String url = "https://buscapreco.sefaz.am.gov.br/item/grupo/page/1?termoCdGtin=&descricaoProd=${_produtoController.text}&action=&consultaExata=true&_consultaExata=on";
    var produtos = [];
    var paginas = [];
    http.Response response = await http.post(Uri.parse(url), headers: {
      // ignore: prefer_interpolation_to_compose_strings
      'Cookie': 'JSESSIONID=' + _cookie
    });
    inspect(response.body);
    var cookie = "";
    if (response.headers['set-cookie'].toString().isNotEmpty &&
        response.headers['set-cookie'].toString().length > 43) {
      cookie = response.headers['set-cookie'].toString().substring(11, 43);
    }

    var document = parse(response.body);

    var cards = document.getElementsByClassName('card');
    for (var card in cards) {
      var cardTitle = card.getElementsByClassName('card-title');
      for (var title in cardTitle) {
        var tbValor25 = card.getElementsByClassName(
            'tb-valor-25 indigo-text text-darken-4 padding10');
        var tbValor10 = card.getElementsByClassName(
            'truncate grey-text text-darken-4 tb-valor-10 tooltipped');
        var tbValorloja =
            card.getElementsByClassName('truncate tooltipped padding10');
        for (var loja in tbValorloja) {
          for (var valor in tbValor25) {
            for (var endereco in tbValor10) {
              produtos.add({
                "item": title.text.trim(),
                "valor": valor.text.trim(),
                "endereco": endereco.text.trim(),
                "loja": loja.text.trim(),
              });
            }
          }
        }
      }
    }

    var paginacao = document.querySelectorAll('li.waves-effect');
    for (var element in paginacao) {
      var pagina = element.querySelector('a');
      paginas.add(pagina?.text);
    }

    return [produtos, paginas, cookie];
  }
}
