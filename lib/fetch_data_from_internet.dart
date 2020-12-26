import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Album> fetchAlbum() async {
  // The http.get() method returns a Future that contains a Response.

  // Future is a core Dart class for working with async operations.
  // A Future object represents a potential value or error that will
  // be available at some time in the future.

  // The http.Response class contains the data received from a successful http call.
  final response = await http.get(
    'https://jsonplaceholder.typicode.com/albums/1',
    // To fetch data from most web services, you need to provide authorization.
    // Send authorization headers to the backend using the Authorization HTTP header
    headers: {HttpHeaders.authorizationHeader: "Basic your_api_token_here"},
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response, then parse the JSON.
    return Album.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response, then throw an exception.
    throw Exception('Failed to load album');
  }
}

class Album {
  Album({this.userId, this.id, this.title});

  final int userId;
  final int id;
  final String title;

  // Factory constructor that creates an Album from JSON.
  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}

void main() => runApp(FetchData());

class FetchData extends StatefulWidget {
  FetchData({Key key}) : super(key: key);

  @override
  _FetchDataState createState() => _FetchDataState();
}

class _FetchDataState extends State<FetchData> {
  Future<Album> futureAlbum;

  // The initState() method is called exactly once and then never again.
  // If you want to have the option of reloading the API in response to an
  // InheritedWidget changing, put the call into the didChangeDependencies() method.

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fetch Data Example'),
        ),
        body: Center(
          // The FutureBuilder widget makes it easy to work with asynchronous data sources.
          // You must provide two parameters:
          // The Future you want to work with.
          // A builder function that tells Flutter what to render, depending on
          // the state of the Future: loading, success, or error.
          child: FutureBuilder<Album>(
            future: futureAlbum,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data.title);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              // Note that snapshot.hasData only returns true when the snapshot contains
              // a non-null data value. This is why the fetchAlbum function should throw
              // an exception even in the case of a “404 Not Found” server response.
              // If fetchAlbum returns null then the spinner displays indefinitely.

              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
