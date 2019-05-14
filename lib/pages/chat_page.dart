import 'package:flutter/material.dart';
import 'package:everyday_language/config/settings.dart';
import 'package:everyday_language/config/translations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:everyday_language/services/firestore_service.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:everyday_language/models/user_model.dart';
import 'package:everyday_language/models/user.dart';

final language = appvars['firstLanguage'] == 'en' ? english : thai;
const String _name = "Tim Cranfield";

class ChatScreen extends StatefulWidget {                     
  @override                                                       
  State createState() => new ChatScreenState();                    
} 

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {                 
  //final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = new TextEditingController();
  final _firestoreService = FirestoreService();
  bool _isComposing = false;
  var _roomId = "123dw";

  @override                                                        
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model) {
        if (model.status == Status.Authenticated) {
          _buildBody();
        } else {
          Navigator.popUntil(context, ModalRoute.withName('/'));
        }
      }
    );
  
  }

  Widget _buildBody() {
    return new Scaffold(
      appBar: new AppBar(title: new Text(language['title'])),
      body: new Column(
        children: <Widget>[
          _buildMessages(),
          new Divider(height: 1.0),
          new Container(
            decoration: new BoxDecoration(
              color: Theme.of(context).cardColor
            ),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }

  Widget _buildMessages() {
    return Center(
      child: Container(
          padding: const EdgeInsets.all(10.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestoreService.getMessages(_roomId),
          builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return new Text('Loading...');
                default:
                  return new ListView(
                    children: snapshot.data.documents
                      .map((DocumentSnapshot document) {
                        return new Text(document['text']);
                    }).toList(),
                  );
              }
            },
        )
      ),
    );
  }

  Widget _buildTextComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget> [
            new Flexible(
              child: new TextField(
                controller: _textController,
                onSubmitted: _handleSubmit,
                onChanged:  (String text) {        
                  setState(() {                    
                    _isComposing = text.length > 0;
                  });                        
                },         
                decoration: new InputDecoration.collapsed(
                  hintText: language['send']),
              ),
            ),
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
              child: new IconButton(
                icon: new Icon(Icons.send),
                onPressed: _isComposing 
                ? () => _handleSubmitted()
                : null,
              )
            )
          ],
        ),
      ),
    ); 
  }

  void _handleSubmit(String text) {
    _handleSubmitted();
  }

  Future<Null> _handleSubmitted() async {
    User user = ScopedModel.of<UserModel>(context).user;
    String text = _textController.text;
    _textController.clear();
    setState(() {                                                    
      _isComposing = false;                                         
    });   
    _firestoreService.addMessage(_roomId, user.uid, user.name, text);
     ChatMessage message = new ChatMessage(                         
      text: text,            
      animationController: new AnimationController(
        duration: new Duration(milliseconds: 500),
        vsync: this,
      ),
    );    
    message.animationController.forward();
  }

}

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.animationController});
  final String text;
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    return new SizeTransition(
      sizeFactor: new CurvedAnimation(
        parent: animationController, 
        curve: Curves.easeOut,
      ),
      axisAlignment: 0.0,
      child: new Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: new CircleAvatar(child: new Text(_name[0]))
            ),
            new Expanded(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(_name, style: Theme.of(context).textTheme.subhead),
                  new Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: new Text(text)
                  )
                ],
              ),
            ),
          ],
        )
      )
    );
  }

}