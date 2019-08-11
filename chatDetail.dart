import 'package:flutter/material.dart';
import 'session.dart';
import 'dart:async';
import 'dart:convert';
import 'main.dart';
import 'chats.dart';
import 'Config.dart';

class chatDetail extends StatefulWidget {
  final String userid;
  final String otheruser;
  final String otherusername;
  chatDetail({Key key, this.userid, this.otheruser, this.otherusername}) : super (key : key);
  @override
  _chatDetailState createState() => _chatDetailState(userid: userid, otheruser: otheruser, otherusername: otherusername);
}

class _chatDetailState extends State<chatDetail> {
  Choice _selectedChoice = choices[0]; // The app's "state".

  final String userid;
  final String otheruser;
  final String otherusername;
  var otherusr;
  final myController = TextEditingController();
  String message;
  var convsDetail;
  _chatDetailState({Key key, this.userid, this.otheruser, this.otherusername});

   void _select(Choice choice) {
    // Causes the app to rebuild with the new _selectedChoice.
    setState(() {
      _selectedChoice = choice;
    });
  }

  @override
  void initState(){
    super.initState();

    var session = new Session();
    var mapData = new Map();
    mapData["other_id"] = otheruser;
    otherusr = otheruser;
    Future<String> responseFromAllConvs = session.post(Config().ipAndPort() + "ConversationDetail?id="+userid, mapData).then((value) {
      Map<String, dynamic> map = json.decode(value);
      print(value);
      bool status = map['status'];
      //sessionStatus = status;
      if(status){
        setState(() {
          print(map['data']);
          convsDetail = map['data'];
          //Map<String, dynamic> convs[] = map['data'];
//        print(convsDetail);
          print(convsDetail);
        });

      }
    });

  }

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
            title: Text(otherusername),
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
            child: Text("Loading..."),
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
            title: Text(otherusername),
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
//            body: Container(
//              padding: EdgeInsets.all(5.00),
//              child: ListView.builder(
//              itemCount: convsDetail.length,
//              itemBuilder: (context, index) {
//
//                return ListTile(
//                  title: Text(
//                      '${convsDetail[index]['text']}'
//                  ),
//                  subtitle: Text(
//                      '${convsDetail[index]['timestamp']}'
//                  ),
//                );
//
//              },
//            ),
//        ),
            body: new Column(
              children: <Widget>[
                new Expanded(
                  child: ListView.builder(
                  itemCount: convsDetail.length,
                  itemBuilder: (context, index) {
                  if(convsDetail[index]['uid'] != userid) {
                    return ListTile(
                      //leading: Icon(Icons.arrow_forward),
                      title: Text(
                          '${convsDetail[index]['text']}'
                      ),
                      subtitle: Text(
                          'Received at ${convsDetail[index]['timestamp']}'
                      ),
                    );
                  }
                  else{
                    return ListTile(

                      title: Text(
                          '${convsDetail[index]['text']}'
                      ),
                      subtitle: Text(
                          'Sent at ${convsDetail[index]['timestamp']}'
                      ),
                      //leading: Icon(Icons.arrow_back),
                    );
                  }
              },
            ),
                ),
//                new TextFormField(
//                  decoration: InputDecoration(
//                      hintText: "Type new message"
//                  ),
//                ),
                new Row(
                  children: <Widget>[
                    new Expanded(
                        child: new TextFormField(
                          controller: myController,
                          decoration: InputDecoration(
                              hintText: "Type New Message",
                          ),
                          validator: (value){
                            if(value.isEmpty) {
                              return "Please enter non-empty message";
                            }
                          },
                          onSaved: (input) => message = input,
                        ),
                    ),
                    new RaisedButton(
                      onPressed: (){
                          print(myController.text);
                          var session = new Session();
                          var mapData = new Map();
                          mapData['other_id'] = otheruser;
                          mapData['msg'] = myController.text.toString();
                          Future<String> response = session.post(Config().ipAndPort() + "NewMessage?id=" + userid, mapData).then((value){
                            print(value);
                            Map<String, dynamic> map = json.decode(value);
                            bool status = map['status'];
                            if(status){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => chatDetail(userid: userid, otheruser: otheruser, otherusername: otherusername)
                              ));
                            }
                          }
                          );
                      },
                      child: Text('Submit'),
                      ),
                  ],
                ),
              ],
            ),
//            body: ListView(
//              children: <Widget>[
//                ListView.builder(
//                  itemCount: convsDetail.length,
//                  itemBuilder: (context, index) {
//
//                    return ListTile(
//                      title: Text(
//                          '${convsDetail[index]['text']}'
//                      ),
//                      subtitle: Text(
//                          '${convsDetail[index]['timestamp']}'
//                      ),
//                    );
//
//                  },
//                ),
//                TextFormField(
//                  decoration: InputDecoration(
//                      hintText: "New message"
//                  ),
//                ),
//              ],
//            ),

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

class ChoiceCard extends StatelessWidget {
  const ChoiceCard({Key key, this.choice}) : super(key: key);

  final Choice choice;

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme.of(context).textTheme.display1;
    return Card(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(choice.icon, size: 128.0, color: textStyle.color),
            Text(choice.title, style: textStyle),
          ],
        ),
      ),
    );
  }
}
