import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() => runApp(WebSockets());

// WebSockets allow for two-way communication with a server without polling.

class WebSockets extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = 'WebSocket Demo';

    return MaterialApp(
      title: title,
      home: MyHomePage(
        title: title,
        // Creating a WebSocketChannel that connects to a server:
        channel: IOWebSocketChannel.connect('ws://echo.websocket.org'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, @required this.title, @required this.channel})
      : super(key: key);

  final String title;

  // WebSocketChannel allows you to both listen for messages from the server
  // and push messages to the server.
  final WebSocketChannel channel;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Form(
              child: TextFormField(
                controller: _controller,
                decoration: InputDecoration(labelText: 'Send a message'),
              ),
            ),

            // Using a StreamBuilder widget to listen for new messages,
            // and a Text widget to display them.
            StreamBuilder(
              // The StreamBuilder widget connects to a Stream
              /// The WebSocketChannel provides a Stream of messages from the server.
              stream: widget.channel.stream,
              // The StreamBuilder widget asks Flutter to rebuild every time it
              // receives an event using the given builder() function
              builder: (context, snapshot) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Text(snapshot.hasData ? '${snapshot.data}' : ''),
                );
              },

              /// The Stream class provides a way to listen to async events from
              /// a data source. Unlike Future, which returns a single async response,
              /// the Stream class can deliver many events over time.
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMessage,
        tooltip: 'Send message',
        child: Icon(Icons.send),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      // To send data to the server, add() messages to the sink provided by the WebSocketChannel.
      widget.channel.sink.add(_controller.text);
    }

    /// The WebSocketChannel provides a StreamSink to push messages to the server.
    /// The StreamSink class provides a general way to add sync or async events to a data source.
  }

  @override
  void dispose() {
    // After you’re done using the WebSocket, close the connection
    widget.channel.sink.close();
    super.dispose();
  }
}
