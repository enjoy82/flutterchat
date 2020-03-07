import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'auth.dart';

// ---------
// チャットページ
// ---------
class ChatPage extends StatefulWidget {
  ChatPage({this.auth, this.currentPageChatSelectSet});
  final BaseAuth auth;
  final VoidCallback currentPageChatSelectSet;
  final WebSocketChannel channel = IOWebSocketChannel.connect('ws://118.27.27.77:1337');
  @override
  _ChatPage createState() => new _ChatPage();
}


//TickerProviderStateMixinはvsync用
class _ChatPage extends State<ChatPage> with TickerProviderStateMixin{
  //メッセージリスト定義
  List<ChatMessage> _messages;
  TextEditingController _textController;
  List<String> messageList = [];
  //Widgetで使うために定義、TextEditingControllerは既存
  //bool _isComposing = false;
  //String _name = widget.auth.uid;  
  _ChatPage(){
    _messages = <ChatMessage>[];
    _textController = new TextEditingController();
    /*widget.channel.stream.listen((data) {
      setState(() {
        print(data);
        messageList.add(data);
      });
    });*/
  }

  void _handleSubmitted(String text) {
    //Widgetで埋め込むための関数ここでChatMessageテキストとコントローラ渡してつくってる
    _textController.clear();
    print(text);
    ChatMessage message = new ChatMessage(
      text: text,
      name: widget.auth.uid,
      animationController: new AnimationController(
        duration: new Duration(milliseconds: 700),
        vsync: this,
      ), 
    );
    if(message.text.length > 0){
      //socketIO.sendMessage('new message', json.encode({'message': text}));
      /*setState(() {
        _messages.insert(0, message);
        //計算量どうなの？メッセージの配列0にインソート
      });*/
      //widget.channel.sink.add(message);
      widget.channel.sink.add(text);
    }
    message.animationController.forward();
  }

  void dispose() {
    for (ChatMessage message in _messages)
      message.animationController.dispose();
    widget.channel.sink.close();
    super.dispose();
  }    

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text("チャットページ"),
        leading:(
          SignInButtonBuilder(
            text: 'go to ChatPage',
            icon: Icons.email,
            onPressed: () {
              widget.currentPageChatSelectSet();
            },
            backgroundColor: Colors.blueGrey[700],
          )
        )
      ),
      body: new Column(
      children: <Widget>[
        new Flexible(
          //message
          child: StreamBuilder(
            stream: widget.channel.stream,
            builder: (context, snapshot) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Text(snapshot.hasData ? '${snapshot.data}' : ''),
              );
            },
          )
          /*new ListView.builder(
            padding: new EdgeInsets.all(8.0),
            reverse: true, 
            itemBuilder: (_, int index) => _messages[index],
            //配列作製 謎挙動
            itemCount: _messages.length,
            //配列の個数指定 
          ),*/
        ), 
        new Divider(height: 1.0),
        new Container(
          //送信用テキストボックス
          decoration: new BoxDecoration(
            color: Theme.of(context).cardColor),
          child: _buildTextComposer(),
        ),
      ],
    )
    );
  }

  Widget _buildTextComposer() {
    return new Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: new Row(
        //横にUI並べる
        children: <Widget>[
          new Flexible(
            child: new TextField(
              controller: _textController,
              onSubmitted: _handleSubmitted,
              decoration: new InputDecoration.collapsed(
                hintText: "Send a message"),
            ),
          ),
          //箱入れて入れ子
          new Container(
            margin: new EdgeInsets.symmetric(horizontal: 4.0),
            child: new IconButton(
              icon: new Icon(Icons.send),
              onPressed: () => _handleSubmitted(_textController.text)
            ),
          ),
        ],
      ),
    );
  }
}

//チャットのUI
class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.animationController, this.name});
  //定義
  final String name;
  final String text;
  final AnimationController animationController;
  @override
  Widget build(BuildContext context) {
    return new SizeTransition(
    sizeFactor: new CurvedAnimation(
        parent: animationController, curve: Curves.easeOut),
        //???
    axisAlignment: 0.0,
    child: new Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: new CircleAvatar(child: new Text(name[0])),
            ),
            new Expanded(
              //メッセージ多いときに折り返してくれるUI
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(name, style: Theme.of(context).textTheme.subhead),
                  new Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: new Text(text),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}