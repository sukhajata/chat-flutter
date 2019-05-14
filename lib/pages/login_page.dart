import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:everyday_language/models/user_model.dart';

class LoginPage extends StatelessWidget {
  
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
       builder: (context, child, model) {
        return new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new MaterialButton(
              //padding: new EdgeInsets.all(16.0),
              minWidth: 150.0,
              onPressed: () => model.signIn(),
              child: new Text('Sign in with Facebook'),
              color: Colors.lightBlueAccent,
            ),
            new Padding(
              padding: const EdgeInsets.all(5.0),
            ),
            new MaterialButton(
              minWidth: 150.0,
              onPressed: () => model.signOut(),
              child: new Text('Sign Out'),
              color: Colors.lightBlueAccent,
            ),
          ],
        );
      }
    );
  }

}