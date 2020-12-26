import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Album> fetchAlbum() async {
  final response =
      await http.get('https://jsonplaceholder.typicode.com/albums/1');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response, then parse the JSON.
    return Album.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response, then throw an exception.
    throw Exception('Failed to load album');
  }
}

Future<Album> deleteAlbum(String id) async {
  // The http.delete() method returns a Future that contains a Response.
  final http.Response response = await http.delete(
    'https://jsonplaceholder.typicode.com/albums/$id',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response, then parse the JSON.
    // After deleting, you'll get an empty JSON `{}` response.
    // Don't return `null`, otherwise `snapshot.hasData`
    // will always return false on `FutureBuilder`.
    return Album.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a "200 OK response", then throw an exception.
    throw Exception('Failed to delete album.');
  }
}

class Album {
  Album({this.id, this.title});

  final int id;
  final String title;

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'],
      title: json['title'],
    );
  }
}

void main() {
  runApp(DeleteData());
}

class DeleteData extends StatefulWidget {
  DeleteData({Key key}) : super(key: key);

  @override
  _DeleteDataState createState() {
    return _DeleteDataState();
  }
}

class _DeleteDataState extends State<DeleteData> {
  Future<Album> _futureAlbum;

  // In order to check whether the data has been deleted or not, first fetch the data
  // from the JSONPlaceholder using the http.get() method, and display it in the screen.
  @override
  void initState() {
    super.initState();
    _futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Delete Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Delete Data Example'),
        ),
        body: Center(
          child: FutureBuilder<Album>(
            future: _futureAlbum,
            builder: (context, snapshot) {
              // If the connection is done, check for response data or an error.
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('${snapshot.data?.title ?? 'Deleted'}'),
                      // Se o snapshot.data não for null, atribuir o valor do title,
                      // se ele for null, atribuir a string 'Deleted' ao Widget Text.
                      RaisedButton(
                        child: Text('Delete Data'),
                        onPressed: () {
                          setState(() {
                            _futureAlbum =
                                deleteAlbum(snapshot.data.id.toString());
                          });
                          // When you click on the Delete Data button, the deleteAlbum()
                          // method is called and the id you are passing is the id of the
                          // data that you retrieved from the internet. This means you are
                          // going to delete the same data that you fetched from the internet.
                        },
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
              }
              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}