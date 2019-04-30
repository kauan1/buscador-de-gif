import 'package:flutter/material.dart';

import 'package:share/share.dart';

class GifPage extends StatelessWidget {

  final Map _gifData;

  GifPage(this._gifData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(//permite qua as coisa se sobreponha
        appBar: AppBar(//cria uma app bar
          title: Text("${_gifData["title"]}"),//define o titulo da app bar
          backgroundColor: Colors.black,//define o fundo da app bar
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.share),
              onPressed: (){
                Share.share(_gifData["images"]["fixed_height"]["url"]);
              },
            )
          ],
        ),
      backgroundColor: Colors.black,
      body: Center(//cria o corpo do scaffold
        child: Image.network(_gifData["images"]["fixed_height"]["url"]),
      ),
    );
  }
}
