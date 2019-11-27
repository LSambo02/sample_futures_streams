import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Post.dart';

class FutureSample extends StatefulWidget {
  @override
  _FutureSample createState() => _FutureSample();
}

class _FutureSample extends State<FutureSample> {
  bool _isList;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Future Screen'),
        ),
        body: Container(
          child: FutureBuilder(
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              print(snapshot.data);
              return snapshot.data != null
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
                  : CircularProgressIndicator();
            },
            future: _getPosts(),
          ),
        ));
  }

  Future<List<Post>> _getPosts() async {
    var url = 'https://jsonplaceholder.typicode.com/posts';
    var data = await http.get(url);
    var jsonData = json.decode(data.body);
    List<Post> posts = [];

    for (var p in jsonData) {
      Post post = Post(p['userId'], p['id'], p['title'], p['body']);
      posts.add(post);
    }
    print(posts.length);
    return posts;
  }
}
