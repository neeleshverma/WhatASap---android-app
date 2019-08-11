import 'package:flutter/material.dart';
import 'session.dart';
import 'dart:async';
import 'dart:convert';
import 'main.dart';
import 'chats.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'chatDetail.dart';
import 'Config.dart';

//class SampleApi<T> extends SearchApi
//{
//
//
//  var _names =  [
//    'p1',
//    'p2',
//    'p3',
//    'p4',
//    'p5',
//    'p6',
//    'p7',
//    'p8',
//    'p9',
//  ];
//
//  @override
//  Future<ServiceResult<Iterable<String>>> exec<T>(String input) async {
//    await new Future.delayed(new Duration(seconds: 1)); //simulate a slow response
//    var results = _names.where((x) => x.toLowerCase().contains(input.trim().toLowerCase())).toList();
//    final ServiceResult<Iterable<String>> sr = new ServiceResult<Iterable<String>>();
//    sr.model = results;
//    sr.ok = true;
//    return new Future.value(sr);
//  }
//}

class createConversation extends StatefulWidget {
  final String userid;

  createConversation({Key key, this.userid}) : super (key : key);
  @override
  _createConversation createState() => _createConversation(userid: userid);
}

class _createConversation extends State<createConversation> {
  Choice _selectedChoice = choices[0]; // The app's "state".
  final _formKey = GlobalKey<FormState>();
  final String userid;
  var convsDetail = "Howdy";
  _createConversation({Key key, this.userid});
  void _select(Choice choice) {
    // Causes the app to rebuild with the new _selectedChoice.
    setState(() {
      _selectedChoice = choice;
    });
  }

//  @override
//  void initState(){
//    super.initState();
//
//    var session = new Session();
//    var mapData = new Map();
//    mapData["other_id"] = otheruser;
//    Future<String> responseFromAllConvs = session.post("http://10.196.27.185:8080/whatasap/ConversationDetail?id="+userid, mapData).then((value) {
//      Map<String, dynamic> map = json.decode(value);
//      bool status = map['status'];
//      //sessionStatus = status;
//      if(status){
//        setState(() {
//          print(map['data']);
//          convsDetail = map['data'];
//          //Map<String, dynamic> convs[] = map['data'];
////        print(convsDetail);
//          print(convsDetail);
//        });
//
//      }
//    });
//
//  }

  @override
  Widget build(BuildContext context) {
    //List<String> convsDetail;
//    var session = new Session();
//    bool sessionStatus = false;
//    var convsDetail;
//    Future<String> responseFromAllConvs = session.get("http://10.196.27.185:8080/whatasap/AllConversations?id="+userid).then((value) {
//      Map<String, dynamic> map = json.decode(value);
//      bool status = map['status'];
//      sessionStatus = status;
//      if(status){
//        print(map['data']);
//        convsDetail = map['data'];
//        //Map<String, dynamic> convs[] = map['data'];
////        print(convsDetail);
//        print(convsDetail);
//      }
//    });
    if(convsDetail == null){

      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Create Conversation'),
            actions: <Widget>[
              // action button
              IconButton(
                icon: Icon(choices[0].icon),
                onPressed: () {
                  // _select(choices[0]);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BasicAppBarSample(userid: userid)),
                  );
                },
              ),
              // action button
              IconButton(
                icon: Icon(choices[1].icon),
                onPressed: () {
                  //_select(choices[2]);
                  var session = new Session();
                  //print("Running");
                  Future<String> response = session.get(Config().ipAndPort() + "LogoutServlet?id="+userid).then((value) {
                    print(value);
                    Map<String, dynamic> map = json.decode(value);
                    bool status = map['status'];
                    if(status){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => MyApp()));
                    }
                  }
                  );
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            //child: Cho  iceCard(choice: _selectedChoice),
            child: Text("Loading"),
          ),
//      body: ListView.builder(
//          itemCount: convsDetail.length,
//          itemBuilder: (context, index) {
//            if(sessionStatus) {
//              return ListTile(
//                title: Text('${convsDetail[index]}'),
//              );
//            }
//          },
//      ),
        ),
      );

    }

    else {
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Create Conversation'),
            actions: <Widget>[
              // action button
              IconButton(
                icon: Icon(choices[0].icon),
                onPressed: () {
                  // _select(choices[0]);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BasicAppBarSample(userid: userid)),
                  );
                },
              ),
              // action button
              IconButton(
                icon: Icon(choices[1].icon),
                onPressed: () {
                  //_select(choices[2]);
                  var session = new Session();
                  //print("Running");
                  Future<String> response = session.get(
                      Config().ipAndPort() + "LogoutServlet?id=" +
                          userid).then((value) {
                    print(value);
                    Map<String, dynamic> map = json.decode(value);
                    bool status = map['status'];
                    if (status) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => MyApp()));
                    }
                  }
                  );
                },
              ),
            ],
          ),
//          body: Padding(
//            padding: const EdgeInsets.all(16.0),
//            //child: Cho  iceCard(choice: _selectedChoice),
//            child: Text("${userid}"),
//          ),
          body: TypeAheadField(
            textFieldConfiguration: TextFieldConfiguration(
              autofocus: true,

//              decoration: InputDecoration(
//                border: OutlineInputBorder()
//              )
            ),
            suggestionsCallback: (pattern) async {
              var session = new Session();
              var mapData = new Map();
              var result;
              mapData["term"] = pattern;
              String response = await session.post(Config().ipAndPort() + "AutoCompleteUser?id=" + userid, {"term": pattern});
              print(response);
              return json.decode(response);
            },
            itemBuilder: (context, suggestion){
              print(suggestion['label'].toString().split(',')[0].split(' ')[1]);
              return ListTile(
                title: Text(suggestion['label']),
                subtitle: Text(suggestion['value']),
              );
            },

            onSuggestionSelected: (suggestion){
             // print('suggestion {$suggestion}');
              var session = new Session();
//              var mapData = new Map();
//              mapData["other_id"] = suggestion['label']['uid'];
              //print(json.decode(suggestion));
              //print('Sugesskggjfgdkgkdf $suggestion');
              String otheruser = suggestion['label'].toString().split(',')[0].split(' ')[1];
              String otherusername1 = suggestion['label'].toString().split(',')[1].split(' ')[2];
              //String[] arr = suggestn.split(",");
              print(otheruser);
              var mapData = new Map();
              mapData["other_id"] = otheruser;
              Future<String> response = session.post(Config().ipAndPort() + "CreateConversation?id=" + userid, mapData).then((value){
                print(value);
                Map<String, dynamic> map = json.decode(value);
                bool status = map['status'];
                if(!status){
                  if(otheruser == userid){
                    //print("Hereeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
                    Scaffold.of(context)
                        .showSnackBar(SnackBar(content: Text(
                        'Cannot create a conversation with itself')));
                  }
                  else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          chatDetail(userid: userid, otheruser: otheruser, otherusername: otherusername1,)),
                    );
                  }
                }
                else{
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => chatDetail(userid: userid, otheruser: otheruser, otherusername: otherusername1,)),
                      );
                }
              });
            },
          ),
        ),
      );
    }
  }
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Home', icon: Icons.home),
  // const Choice(title: 'Create', icon: Icons.create),
  const Choice(title: 'Exit', icon: Icons.exit_to_app),
//  const Choice(title: 'Bus', icon: Icons.directions_bus),
//  const Choice(title: 'Train', icon: Icons.directions_railway),
//  const Choice(title: 'Walk', icon: Icons.directions_walk),
];