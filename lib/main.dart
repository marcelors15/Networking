import 'package:Networking/delete_data_on_internet.dart';
import 'package:Networking/send_data_to_internet.dart';
import 'package:Networking/update_data_over_internet.dart';
import 'package:flutter/material.dart';

import 'Parse_JSON_in_background.dart';
import 'Work_with_WebSockets.dart';
import 'fetch_data_from_internet.dart';

void main() {
  runApp(MaterialApp(
    title: 'Networking with Flutter',
    home: HomeRoute(),
  ));
}

class HomeRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Networking in Flutter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text('Fetch Data from Internet'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => (FetchData())),
                );
              },
            ),
            RaisedButton(
              child: Text('Send Data to Internet'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => (SendData())),
                );
              },
            ),
            RaisedButton(
              child: Text('Delete Data on Internet'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => (DeleteData())),
                );
              },
            ),
            RaisedButton(
              child: Text('Update Data on Internet'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => (UpdateData())),
                );
              },
            ),
            RaisedButton(
              child: Text('Parse JSON in background'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => (ParseJSON())),
                );
              },
            ),
            RaisedButton(
              child: Text('Work with WebSockets'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => (WebSockets())),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
