import 'package:flutter/material.dart';

import 'package:websocket_manager/websocket_manager.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  final TextEditingController _urlController = TextEditingController(text: 'wss://echo.websocket.org');
  final TextEditingController _messageController = TextEditingController();
  WebsocketManager? socket;
  String _message = '';
  String _closeMessage = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Websocket Manager Example'),
        ),
        body: Column(
          children: <Widget>[
            TextField(
              controller: _urlController,
            ),
            Wrap(
              children: <Widget>[
                ElevatedButton(
                  child: const Text('CONFIG'),
                  onPressed: () =>
                  socket = WebsocketManager(_urlController.text,{}),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (socket != null) {
                      socket!.connect();
                    }
                  },
                  child:  const Text('CONNECT'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (socket != null) {
                      socket!.close();
                    }
                  },
                  child:  const Text('CLOSE'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (socket != null) {
                      socket!.onMessage((dynamic message) {
                        print('New message: $message');
                        setState(() {
                          _message = message.toString();
                        });
                      });
                    }
                  },
                  child:  const Text('LISTEN MESSAGE'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (socket != null) {
                      socket!.onClose((dynamic message) {
                        print('Close message: $message');
                        setState(() {
                          _closeMessage = message.toString();
                        });
                      });
                    }
                  },
                  child:  const Text('LISTEN DONE'),
                ),
                ElevatedButton(
                  onPressed: () {
                    WebsocketManager.echoTest();
                  },
                  child:  const Text('ECHO TEST'),
                ),

              ],
            ),
            TextField(
              controller: _messageController,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (socket != null) {
                      socket!.send(_messageController.text);
                    }
                  },
                ),
              ),
            ),
            const Text('Received message:'),
            Text(_message),
            const Text('Close message:'),
            Text(_closeMessage),
          ],
        ),
      ),
    );
  }
}
