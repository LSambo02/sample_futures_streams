import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Post.dart';

class StreamScreen extends StatefulWidget {
  @override
  _StreamScreen createState() => _StreamScreen();
}

class _StreamScreen extends State<StreamScreen> {
  // var url = 'https://jsonplaceholder.typicode.com/posts';

  @override
  Widget build(BuildContext context) {
    //instancia de um stream, cast de um future
    Stream<List<String>> _posts() => Stream.fromFuture(_getUrls());

    return Scaffold(
        appBar: AppBar(
          title: Text('Stream Screen'),
        ),
        body: Container(
          child: StreamBuilder(
            builder: (context, snapshot) {
              //sempre verifique se o snapshot possue algum dado ou a aplicação crasha*
              if (!snapshot.hasData) return CircularProgressIndicator();
              return ListView.separated(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) =>
                    //chamada a método responsável por integrar cada resultado do stream
                    _getPosts(context, snapshot.data[index]),
                separatorBuilder: (context, index) => Divider(),
              );
            },
            stream: _posts(),
          ),
        ));
  }

  Future<List<String>> _getUrls() async {
    //definição de vários dados de controlo (assíncronos)
    List<String> urls = [
      'https://jsonplaceholder.typicode.com/posts/1',
      //url inválida
      'https://jsonplaceholder.typicode.com/posts/t',
      'https://jsonplaceholder.typicode.com/posts/3',
      'https://jsonplaceholder.typicode.com/posts/4',
      'https://jsonplaceholder.typicode.com/posts/5',
      'https://jsonplaceholder.typicode.com/posts/6',
    ];

    return urls;
  }

  //método responsável por mostrar os dados na tela da aplicação
  Widget _getPosts(BuildContext context, String snapshot) {
    return FutureBuilder(
      future: _getPost(snapshot),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            break;
          case ConnectionState.waiting:
            return Container();
            break;
          case ConnectionState.active:
            break;
          case ConnectionState.done:
            return ListTile(
              title: snapshot.data.title != null
                  ? Text(snapshot.data.title)
                  : Text('Invalid Url'),
              subtitle: snapshot.data.body != null
                  ? Text(snapshot.data.body)
                  : Text('Invalid Url'),
            );
            break;
        }
      },
    );
  }

//método responsável por fazer o cast de cada resultado a objecto
  //cada resultado é um future
  Future<Post> _getPost(var _url) async {
    var data = await http.get(_url);
    var jsonData = json.decode(data.body);

    Post post = Post(jsonData['userId'], jsonData['id'], jsonData['title'],
        jsonData['body']);

    //print(post.title);
    return post;
  }
}
