import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Post.dart';

class FutureScreen extends StatefulWidget {
  @override
  _FutureScreen createState() => _FutureScreen();
}

class _FutureScreen extends State<FutureScreen> {
  bool _isList = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Future Screen'),
          actions: <Widget>[
            _isList == false
                ? FlatButton(
                    //botão que permite obter dados do _getPost(apenas um resultado) ou _getPosts (lista de resultados)
                    onPressed: () {
                      setState(() {
                        _isList = true;
                      });
                    },
                    child: Text('Lista'))
                : FlatButton(
                    onPressed: () {
                      setState(() {
                        _isList = false;
                      });
                    },
                    child: Text('Single'))
          ],
        ),
        body: Container(
          child: FutureBuilder(
            //definição do builder do nosso future
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return snapshot.data != null
                  ? (_isList == true
                      //para a lista
                      ? ListView.separated(
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              title: Text(snapshot.data[index].title),
                              subtitle: Text(snapshot.data[index].body),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              Divider(),
                        )
                      //para o future com apenas um dado
                      : Container(
                          child: Column(
                            children: <Widget>[
                              Text(
                                snapshot.data.title,
                                style: TextStyle(fontSize: 25.0),
                              ),
                              Text(snapshot.data.body)
                            ],
                          ),
                        ))
                  : CircularProgressIndicator();
            },
            //dependendo do botão seleccionado para apresentar a lista ou resultado único
            // usamos os futures abaixo
            future: _isList == true ? _getPosts() : _getPost(),
          ),
        ));
  }

  //obtendo dados json e passando a futures (a resposta é um future)

  Future<Post> _getPost() async {
    //nosso dado de controlo
    var url = 'https://jsonplaceholder.typicode.com/posts/2';

    //aguardando a resposta a requisição assíncrona
    var data = await http.get(url);
    //obtendo os dados da requisição
    var jsonData = json.decode(data.body);

    //passando os dados a objecto
    Post post = Post(jsonData['userId'], jsonData['id'], jsonData['title'],
        jsonData['body']);

    return post;
  }

  Future<List<Post>> _getPosts() async {
    var url = 'https://jsonplaceholder.typicode.com/posts';
    var data = await http.get(url);
    var jsonData = json.decode(data.body);
    List<Post> posts = [];

    //passando os dados a objectos
    for (var p in jsonData) {
      Post post = Post(p['userId'], p['id'], p['title'], p['body']);
      posts.add(post);
    }
    //print(posts.length);
    return posts;
  }
}
