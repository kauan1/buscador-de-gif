import 'package:flutter/material.dart';

import 'package:buscador_de_gif/ui/home_page.dart';//é a biblioteca da outra pagina que seria a home
import 'package:buscador_de_gif/ui/gif_page.dart';

void main(){
  runApp(MaterialApp(
    home: HomePage(),//chama a função
    theme: ThemeData(hintColor: Colors.white),//define o tema da tela
  ));
}


