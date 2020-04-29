import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

class WebSocket {
  WebSocketChannel  channel;
  WebSocket(){
    try {
      channel = IOWebSocketChannel.connect('ws://118.27.27.77:1337');
    } catch(e){
      print("can't connect");
    }
  }

  setuid(String uid){
    channel.sink.add(json.encode({
       "action": "join",
       "uid": uid
    }));
  }
}