import 'package:flutter/material.dart';
import 'session.dart';
import 'dart:async';
import 'dart:convert';
import 'main.dart';
import 'chatDetail.dart';
import 'createConversation.dart';
import 'Config.dart';

class Person {
  final String uid;
  final int num_msgs;

  Person({this.uid, this.num_msgs});
  factory Person.fromJson(Map<String, dynamic> json){
    return Person(
      uid: json['uid'] as String,
      num_msgs: json['num_msgs'] as int,
    );
  }
}

class BasicAppBarSample extends StatefulWidget {
  final String userid;
  BasicAppBarSample({Key key, this.userid}) : super (key : key);
  @override
  _BasicAppBarSampleState createState() => _BasicAppBarSampleState(userid: userid);
}

class _BasicAppBarSampleState extends State<BasicAppBarSample> {
  Choice _selectedChoice = choices[0]; // The app's "state".
  final myController = TextEditingController();
  int x = 0;
  bool find = false;
  List<String> listStrings = new List<String>();
  final String userid;
  var convsDetail;
 _BasicAppBarSampleState({Key key, this.userid});

 //getConvsDetail(userid);

 //Future<String> responseFromAllConvs = session.get("http://10.196.27.185:8080/whatasap/LogoutServlet?id="+userid);
  void _select(Choice choice) {
    // Causes the app to rebuild with the new _selectedChoice.
    setState(() {
      _selectedChoice = choice;
    });
  }

  @override
  void initState(){
    super.initState();
    myController.addListener(_printvalue);

    var session = new Session();
    Future<String> responseFromAllConvs = session.get(Config().ipAndPort() + "AllConversations?id="+userid).then((value) {
      Map<String, dynamic> map = json.decode(value);
      bool status = map['status'];
      print(value);
      //sessionStatus = status;
      if(status){
        setState(() {
          print(map['data']);
          convsDetail = map['data'];
          //Map<String, dynamic> convs[] = map['data'];
//        print(convsDetail);
          //print(convsDetail);
        });

      }
    });

  }

  _printvalue(){
    listStrings = new List<String>();
    //print("${myController.text}");
    //print(convsDetail);
    print(convsDetail.length);
//    if("p2".contains("p")){
//      print("Contains");
//    }
    for(int i=0; i<convsDetail.length; i++){
      print(convsDetail[i]['uid'].toString());
      print(myController.text.toString());
      if(convsDetail[i]['uid'].toString().toLowerCase().contains(myController.text.toString().toLowerCase()) || convsDetail[i]['name'].toString().toLowerCase().contains(myController.text.toString().toLowerCase()))
      {
          find = true;
          listStrings.add(convsDetail[i]['name'].toString()+"+" +convsDetail[i]['last_timestamp'].toString());
      }
      //listStrings.add(convsDetail[i]['uid'].toString()+"+" +convsDetail[i]['last_timestamp'].toString());
    }
    print(listStrings);
    setState(() {
      x = x+1;
    });
  }

  Future<bool> _onBackPressed(){
    //print("Calllllllllllllllllllllllleeeeeeeeeeeeeeeeeee");
    return showDialog(
      context: context,
      builder: (context)=>AlertDialog(
        title: Text("Do you really want to logout?"),
        actions: <Widget>[
          FlatButton(
            child: Text("No"),
            onPressed: ()=>Navigator.pop(context,false),
          ),
          FlatButton(
            child: Text("Yes"),
            onPressed: (){
              var session = new Session();
              //print("Running");
              Future<String> response = session.get(Config().ipAndPort() + "LogoutServlet?id="+userid).then((value) {
                print(value);
                Map<String, dynamic> map = json.decode(value);
                bool status = map['status'];
                if(status){
                  Navigator.push(context,
                      new MaterialPageRoute(builder: (context) => MyApp()));
                }
              }
              );
            }
          ),
        ],
      )
    );
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
        //onWillPop: _onBackPressed,
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Chats'),
            actions: <Widget>[
//              TextFormField(
//                controller: myController,
//                decoration: InputDecoration(
//                  hintText: "Search",
//                ),
//              ),
              // action button
              new Expanded(
                flex: 2,
                child: new Center(
                  child: Container(
                    child: Text('Chats'),
                  ),
                ),
              ),
              new Expanded(
                flex: 4,
                child: new TextFormField(
                  controller: myController,
                  decoration: InputDecoration(
                    hintText: "Search",
                  ),
                ),
              ),
              new Expanded(
                flex: 1,
                child: IconButton(
                  icon: Icon(choices[0].icon),
                  onPressed: () {
                    // _select(choices[0]);
                  },
                ),
              ),
              // action button
              new Expanded(
                flex: 1,
                child: IconButton(
                  icon: Icon(choices[1].icon),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => createConversation(userid: userid)));
                    // _select(choices[1]);
                  },
                ),
              ),
              new Expanded(
                flex: 1,
                child: IconButton(
                  icon: Icon(choices[2].icon),
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

    else if(myController.text.toString().isEmpty) {
      return MaterialApp(
        //onWillPop: _onBackPressed,
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Chats'),
            actions: <Widget>[
              new Expanded(
                flex: 2,
                child: new Center(
                  child: Container(
                    child: Text('Chats'),
                  ),
                ),
              ),
              new Expanded(
                  flex: 4,
                  child: new TextFormField(
                    controller: myController,
                    decoration: InputDecoration(
                      hintText: "Search",
                    ),
                  ),
              ),
              // action button
              new Expanded(
                  flex: 1,
                  child: IconButton(
                    icon: Icon(choices[0].icon),
                    onPressed: () {
                      // _select(choices[0]);
                    },
                  ),
              ),

              // action button
              new Expanded(
                  flex: 1,
                  child: IconButton(
                    icon: Icon(choices[1].icon),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => createConversation(userid: userid)));
                      // _select(choices[1]);
                    },
                  ),
              ),
              new Expanded(
                  flex: 1,
                  child: IconButton(
                    icon: Icon(choices[2].icon),
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
              ),

            ],
          ),
//          body: Padding(
//            padding: const EdgeInsets.all(16.0),
//            //child: Cho  iceCard(choice: _selectedChoice),
//            child: Text("${userid}"),
//          ),
          body: ListView.builder(
              itemCount: convsDetail.length,
              itemBuilder: (context, index) {
                  if(convsDetail[index]['last_timestamp']==null){
                    return ListTile(
                        title: Text(
                            '${convsDetail[index]['name']}'
                        ),
                        subtitle: Text(
                            'No messages '
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => chatDetail(userid: userid, otheruser: convsDetail[index]['uid'], otherusername: convsDetail[index]['name'])),
                          );
                        }
                    );
                  }
                  else{
                    return ListTile(
                        title: Text(
                            '${convsDetail[index]['name']}'
                        ),
                        subtitle: Text(
                            '${convsDetail[index]['last_timestamp']}'
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => chatDetail(userid: userid, otheruser: convsDetail[index]['uid'], otherusername: convsDetail[index]['name'])),
                          );
                        }
                    );
                  }


              },
          ),
        ),
      );
    }
    else{
      return MaterialApp(
        //onWillPop: _onBackPressed,
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Chats'),
            actions: <Widget>[
              new Expanded(
                flex: 2,
                child: new Center(
                  child: Container(
                    child: Text('Chats'),
                  ),
                ),
              ),
              new Expanded(
                flex: 4,
                child: new TextFormField(
                  controller: myController,
                  decoration: InputDecoration(
                    hintText: "Search",
                  ),
                ),
              ),
              // action button
              new Expanded(
                flex: 1,
                child: IconButton(
                  icon: Icon(choices[0].icon),
                  onPressed: () {
                    // _select(choices[0]);
                  },
                ),
              ),
              // action button
              new Expanded(
                flex: 1,
                child: IconButton(
                  icon: Icon(choices[1].icon),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => createConversation(userid: userid)));
                    // _select(choices[1]);
                  },
                ),
              ),
              new Expanded(
                flex: 1,
                  child: IconButton(
                    icon: Icon(choices[2].icon),
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
              ),

            ],
          ),
//          body: Padding(
//            padding: const EdgeInsets.all(16.0),
//            //child: Cho  iceCard(choice: _selectedChoice),
//            child: Text("${userid}"),
//          ),
          body: ListView.builder(
            itemCount: listStrings.length,
            itemBuilder: (context, index) {
              String str = listStrings[index];
              String title = str.split("+")[0];
              String sub = str.split("+")[1];
              if(sub == "null") {
                return ListTile(
                    title: Text(
                        title
                    ),
                    subtitle: Text(
                        "No messages"
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                            chatDetail(userid: userid,
                                otheruser: convsDetail[index]['uid'],
                                otherusername: convsDetail[index]['name'])),
                      );
                    }
                );
              }
              else{
                return ListTile(
                    title: Text(
                        title
                    ),
                    subtitle: Text(
                        sub
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => chatDetail(userid: userid, otheruser: convsDetail[index]['uid'], otherusername: convsDetail[index]['name'])),
                      );
                    }
                );
              }


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
  const Choice(title: 'Create', icon: Icons.create),
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

void getConvsDetail(String userid){
  var session = new Session();
  String conversations;
  Future<String> responseFromAllConvs = session.get(Config().ipAndPort() + "AllConversations?id="+userid).then((value) {
    Map<String, dynamic> map = json.decode(value);
    bool status = map['status'];
    print(value);
  }

  );

}