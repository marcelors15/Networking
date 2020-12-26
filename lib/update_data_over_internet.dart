import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Album> updateAlbum(String title) async {
  final http.Response response = await http.put(
    'https://jsonplaceholder.typicode.com/albums/1',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'title': title,
    }),
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response, then parse the JSON.
    // If the server returns an UPDATED response with a status code of 200,
    // then convert the JSON Map into an Album using the fromJson() factory method.
    return Album.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response, then throw an exception.
    // Even in the case of a “404 Not Found” server response, throw an exception.
    // Do not return null. This is important when examining the data in snapshot.
    throw Exception('Failed to update album.');
  }
}

Future<Album> fetchAlbum() async {
  final response =
      await http.get('https://jsonplaceholder.typicode.com/albums/1');
  // Send authorization headers to the backend.
  //headers: {HttpHeaders.authorizationHeader: "Basic your_api_token_here"},);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response, then parse the JSON.
    return Album.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response, then throw an exception.
    throw Exception('Failed to load album');
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
  runApp(UpdateData());
}

class UpdateData extends StatefulWidget {
  UpdateData({Key key}) : super(key: key);

  @override
  _UpdateDataState createState() {
    return _UpdateDataState();
  }
}

class _UpdateDataState extends State<UpdateData> {
  final TextEditingController _controller = TextEditingController();
  Future<Album> _futureAlbum;

  @override
  void initState() {
    super.initState();
    _futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Update Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Update Data Example'),
        ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder<Album>(
            future: _futureAlbum,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(snapshot.data.title),
                      // Create a TextField to enter a title.
                      TextField(
                        //Define a TextEditingController to read the user input from a TextField.
                        controller: _controller,
                        decoration: InputDecoration(hintText: 'Enter Title'),
                      ),
                      // Create a RaisedButton to update the data on server.
                      RaisedButton(
                        child: Text('Update Data'),
                        onPressed: () {
                          // When the RaisedButton is pressed, the _futureAlbum is set to
                          // the value returned by updateAlbum() method.
                          setState(() {
                            _futureAlbum = updateAlbum(_controller.text);
                            // On pressing the Update Data button, a network request
                            // sends the data in the TextField to the server as a POST request.
                          });
                        },
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
              }
              // snapshot.hasData only returns true when the snapshot contains a non-null
              // data value. This is why the updateAlbum function should throw an exception
              // even in the case of a “404 Not Found” server response. If updateAlbum returns
              // null then CircularProgressIndicator will display indefinitely.
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
