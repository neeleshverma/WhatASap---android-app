import 'package:flutter/material.dart';
import 'session.dart';
//import 'package:http/browser_client.dart';
import 'dart:async';
import 'dart:convert';
import 'chats.dart';
import 'dart:io';
import 'Config.dart';
void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Login Form';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
        ),
        body: loginForm(),
      ),
    );
  }
}

class loginForm extends StatefulWidget{
  @override
  loginFormState createState(){
    return loginFormState();
  }
}

class loginFormState extends State<loginForm> {

  final _formKey = GlobalKey<FormState>();
  bool _validate = false;
  String username, password;

  Future<String> printData(String str)
  {
    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text('Checking user authentication ${str}')));
  }
  Future<bool> _onBackPressed() async{
//    return showDialog(
//        context: context,
//        builder: (context)=>AlertDialog(
//          title: Text("Do you really want to exit the app?"),
//          actions: <Widget>[
//            FlatButton(
//              child: Text("No"),
//              onPressed: ()=>Navigator.pop(context,false),
//            ),
//            FlatButton(
//                child: Text("Yes"),
//                onPressed: ()=>exit(0),
//            ),
//          ],
//        )
//    );
  return  false;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Form(
      //onWillPop: _onBackPressed,
      key: _formKey,
      autovalidate: _validate,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              hintText: "Username"
            ),
            validator: (value) {
              if(value.isEmpty) {
                return "Please enter a valid username";
              }
            },
            onSaved: (input) => username = input,
          ),
          TextFormField(
            scrollPadding: const EdgeInsets.all(20.0),
            decoration: InputDecoration(
                hintText: "Password"
            ),
            validator: (value) {
              if(value.isEmpty) {
                return "Please enter a non-empty password";
              }
            },
            onSaved: (input) => password = input,
            obscureText: true,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: RaisedButton(
                onPressed: () {
                  if(_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    print("Name $username");
//                    var response = Session().post("http://localhost:8080/chatapp/src/LoginServlet", {"userid" : username, "password" : password});
//                    print(response);
                    var session = new Session();
                    var mapData = new Map();
                    mapData["userid"] = username;
                    print(username);
                    mapData["password"] = password;
                    Future<String> response= session.post(Config().ipAndPort() + "LoginServlet", mapData).then((value) {
                      Map<String, dynamic> map = json.decode(value);
                      bool status = map['status'];
                      //print(value);
                      if(!status) {
                        Scaffold.of(context)
                            .showSnackBar(SnackBar(content: Text(
                            'Authentication failed')));
                      }
                      else{
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => BasicAppBarSample(userid: username)),
                        );
//                        var route = new MaterialPageRoute(
//                            builder: (BuildContext context) =>
//                                new BasicAppBarSample(userid: username),
//                        );
//                        Navigator.of(context).push(route);


                      }
                    });

                    //response.whenComplete(() => print(response.toString()));
//                    response.whenComplete(() => Scaffold.of(context)
//                                                  .showSnackBar(SnackBar(content: Text('Checking user authentication ${response.toString()}'))));
//                    .then((value) =>
//                      Scaffold.of(context)
//                          .showSnackBar(SnackBar(content: Text('Checking user authentication ${value}'))));
                  }
                  else{
                    setState(() {
                        _validate = true;
                    });
                  }
                },
               child: Text('Submit'),
            ),
          )
        ],
      ),
    );
  }
}