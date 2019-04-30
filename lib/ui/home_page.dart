import 'dart:convert';

import 'package:buscador_de_gif/ui/gif_page.dart';//é a biblioteca da outra pagina que seria a do gif
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _search;

  int _offSet = 0;

  Future<Map> _getGifs() async {//pegando o arquivo json do site
    http.Response responce;

    if (_search == null)
      responce = await http.get(
          "https://api.giphy.com/v1/gifs/trending?api_key=UbNiCQdZ5abokeilF5YircAGt8YZN5Ir&limit=25&rating=G");
    else
      responce = await http.get(
          "https://api.giphy.com/v1/gifs/search?api_key=UbNiCQdZ5abokeilF5YircAGt8YZN5Ir&q=$_search&limit=25&offset=$_offSet&rating=G&lang=en");

    return json.decode(responce.body);
  }

  @override
  void initState() {
    super.initState();

    _getGifs().then((Map) {//inicianado o app com os gifs
      print(Map);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(//permite qua as coisa se sobreponha
      appBar: AppBar(//cria uma app bar
        backgroundColor: Colors.black,//define o funco do app bar
        title: Image.network(//pega a imagem de um site e a define como seu titulo
            "https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif"),
        centerTitle: true,//centraliza
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(//espaçamento nos lados
            padding: EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(//decoração do campo texto
                  labelText: "Pesquise aqui!!",
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder()),
              style: TextStyle(color: Colors.white, fontSize: 18.0),//estilo da escrita
              textAlign: TextAlign.center,
              onSubmitted: (text){//função que ira acontecer na hora que se clicar no botão enter do teclado
                setState(() {//faz com q a pagina se carregue
                  _search = text;
                  _offSet = 0;
                });
              },
            ),
          ),
          Expanded(//expande o objeto
            child: FutureBuilder(//Constroi o objeto com dados carregados posteriormente
                future: _getGifs(),
                builder: (context, snapshot){
                  switch(snapshot.connectionState){//verificando o estado do carregamento
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return Container(
                        width: 200.0,
                        height: 200.0,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(//circulo de carregamento
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 5.0,
                        ),
                      );
                    default:
                      if(snapshot.hasError) return Container();//se tiver erro
                      else return _createGifTable(context, snapshot);//chama a fução de criação
                  }
                }
            ),
          ),
        ],
      ),
    );
  }

  int _getCount(List data){//ve a quantidade de objetos q terão q ser criados
    if(_search == null)
      return data.length;
    else{
      return data.length+1;
    }
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot){//cria a tabela
    return GridView.builder(//tabela
      padding: EdgeInsets.all(10.0),//espaçamento
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(//propriedades da tabela
          crossAxisCount: 2,//quantidades de colunas
          crossAxisSpacing: 10.0,//espaçamento
          mainAxisSpacing: 10.0//espaçamento
        ),
        itemCount: _getCount(snapshot.data["data"]),//quantidade de itens
        itemBuilder: (context, index){//construindo os itens
          if(_search == null || index<snapshot.data["data"].length)//se não estiver pesquisando ou quantidade de intens criados for menor que a quantidade total
            return GestureDetector(//quando se clicar no objeto podera ter uma funçao
              child: FadeInImage.memoryNetwork(//cria imagens com transição
                  placeholder: kTransparentImage,
                  image: snapshot.data["data"][index]["images"]["fixed_height"]["url"],
                height: 300.0,
                fit: BoxFit.cover,
              ),
              onTap: (){//função quando clicar no obejto criado
               Navigator.push(context,
                MaterialPageRoute(builder: (context) => GifPage(snapshot.data["data"][index]))
               );
              },
              onLongPress: (){
                Share.share(snapshot.data["data"][index]["images"]["fixed_height"]["url"]);
              },
            );
          else
            return Container(
              child: GestureDetector(//quando se clicar no objeto podera ter uma funçao
                child: Column(//criação de uma coluna
                  mainAxisAlignment: MainAxisAlignment.center,//alinhamneto da coluna
                  children: <Widget>[
                    Icon(Icons.add, color: Colors.white, size: 70.0,),//criação de um icone
                    Text("Carregar mais...",//criação de um texto
                        style: TextStyle(color: Colors.white, fontSize: 22.0),//estilo do texto
                    )
                  ],
                ),
                onTap: (){//função quando clicar no obejto criado
                  setState(() {
                    _offSet += 25;
                  });
                },
              ),
            );
        }
    );
  }
}

/*
Image.network(//cria os objetos que nesse caso será uma imagem da internet
snapshot.data["data"][index]["images"]["fixed_height"]["url"],//pega a imagem
height: 300.0,//tamanho da imagem
fit: BoxFit.cover,
),
*/
