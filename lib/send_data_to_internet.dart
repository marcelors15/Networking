import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// The createAlbum() method takes an argument title that is sent to the server to create an Album.
Future<Album> createAlbum(String title) async {
  // The http.post() method returns a Future that contains a Response.

  // Future is a core Dart class for working with asynchronous operations.
  // A Future object represents a potential value or error that will
  // be available at some time in the future.

  // The http.Response class contains the data received from a successful http call.
  final http.Response response = await http.post(
    'https://jsonplaceholder.typicode.com/albums',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'title': title,
    }),
  );

  if (response.statusCode == 201) {
    // If the server returns a CREATED response with a status code of 201,
    // then convert the JSON Map into an Album using the fromJson() factory method.
    // Convert the response body into a JSON Map with the dart:convert package.
    return Album.fromJson(json.decode(response.body));
  } else {
    // If the server doesn’t return a CREATED response with a status code of 201,
    // then throw an exception.
    // (Even in the case of a “404 Not Found” server response, throw an exception.
    // Do not return null. This is important when examining the data in snapshot)
    throw Exception('Failed to create album.');
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
  runApp(SendData());
}

class SendData extends StatefulWidget {
  SendData({Key key}) : super(key: key);

  @override
  _SendDataState createState() {
    return _SendDataState();
  }
}

class _SendDataState extends State<SendData> {
  final TextEditingController _controller = TextEditingController();
  Future<Album> _futureAlbum;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Create Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Create Data Example'),
        ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: (_futureAlbum == null)
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextField(
                      // Define a TextEditingController to read the user input from a TextField.
                      controller: _controller,
                      decoration: InputDecoration(hintText: 'Enter Title'),
                    ),
                    RaisedButton(
                      child: Text('Create Data'),
                      onPressed: () {
                        // On pressing the Create Data button, make the network request,
                        // which sends the data in the TextField to the server as a POST request.
                        setState(() {
                          _futureAlbum = createAlbum(_controller.text);
                        });
                      },
                    ),
                  ],
                )
              : FutureBuilder<Album>(
                  future: _futureAlbum,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(snapshot.data.title);
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    // snapshot.hasData only returns true when the snapshot contains
                    // a non-null data value. This is why the createAlbum() function
                    // should throw an exception even in the case of a “404 Not Found” server response.
                    // If createAlbum() returns null, then CircularProgressIndicator displays indefinitely.

                    return CircularProgressIndicator();
                  },
                ),
        ),
      ),
    );
  }
}
