import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Isolates are separate execution threads that do not share any memory with the
// main execution memory heap. This means you can’t access variables from the
// main thread, or update your UI by calling setState().

Future<List<Photo>> fetchPhotos(http.Client client) async {
  final response =
      await client.get('https://jsonplaceholder.typicode.com/photos');

  // Use the compute function to run parsePhotos in a separate isolate.
  // Isolate is a way to run Dart code on another thread.
  return compute(parsePhotos, response.body);
  // The compute() function runs expensive functions in a background isolate and
  // returns the result. In this case, run the parsePhotos() function in the background.

  // Isolate.spawn(parsePhotos, response.body);
}

// A function that converts a response body into a List<Photo>.
List<Photo> parsePhotos(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Photo>((json) => Photo.fromJson(json)).toList();
}

class Photo {
  Photo({this.albumId, this.id, this.title, this.url, this.thumbnailUrl});

  final int albumId;
  final int id;
  final String title;
  final String url;
  final String thumbnailUrl;

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      albumId: json['albumId'] as int,
      id: json['id'] as int,
      title: json['title'] as String,
      url: json['url'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
    );
  }
}

// Isolates communicate by passing messages back and forth. These messages can be
// primitive values, such as null, num, bool, double, or String, or simple objects
// such as the List<Photo> in this example.

// You might experience errors if you try to pass more complex objects,
// such as a Future or http.Response between isolates.

void main() => runApp(ParseJSON());

class ParseJSON extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Isolate Demo';

    return MaterialApp(
      title: appTitle,
      home: MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: FutureBuilder<List<Photo>>(
        future: fetchPhotos(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? PhotosList(photos: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class PhotosList extends StatelessWidget {
  PhotosList({Key key, this.photos}) : super(key: key);
  final List<Photo> photos;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        return Image.network(
            photos[index].thumbnailUrl); //Text(photos[index].url);
      },
    );
  }
}
