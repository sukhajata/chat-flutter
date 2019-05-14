import 'package:flutter/material.dart';
import 'package:everyday_language/pages/login_page.dart';
import 'package:everyday_language/models/user_model.dart';
import 'package:everyday_language/pages/chat_page.dart';
import 'package:scoped_model/scoped_model.dart';

class RootPage extends StatefulWidget {
  RootPage();

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}


class _RootPageState extends State<RootPage> {

  Widget _buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
      model: UserModel(),
      child: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {
          if (model.status == Status.Unauthenticated){
            return new LoginPage();
          } else if (model.status == Status.Authenticated){
            return new ChatScreen();
          } else if (model.status == Status.Unregistered) {
            return new Container(
              child: new Text("Not registered"),
            );
          }
        },

      )
    );
  }
  
}