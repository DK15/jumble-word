import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jumble Word Game',
      theme: ThemeData.dark(),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
//   List<String> taskList = [
//     '💃 Jump up and down 10 times',
//     'Spin around in a circle 5 times',
//     'Hop on one foot 5 times',
//     '🏃‍Run to touch nearest door and come back',
//     ' 🐻 Walk like a bear',
//     'Do 10 Jumping Jack',
//     '🐸 Hop like a Frog 5 times',
//     'Balance on your left foot for 10 seconds',
//     'Balance on your right foot for 10 seconds',
//     'Walk backwards 10 steps and come back',
//     'Run sideways and come back',
//     'Bend down and touch your toes 5 times',
//     'Ride a pretend cycle',
//     'Do a funny run and come back',
//     'Sing your favorite song',
//     'Draw a picture using only 3 colors of your choice',
//     'Draw your favorite cartoon character',
//     'Wear your favorite dress and say few lines'
//   ];

  Random random = Random();

  String textInput;
  String textOutput;

  List<String> inputList = [];
  List<String> outputList = [];
  bool acceptData = false;

  final TextEditingController _controller = TextEditingController();

  bool showTask = false;

  bool _isVisible = true;

  // bool _showInstruction = false;

  void showToast() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Speller'),
        ),
        body: ListView(padding: EdgeInsets.only(top: 10), children: <Widget>[
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(left: 10),
                    alignment: Alignment.centerLeft,
                    child:
                        Text('How To Play:', style: TextStyle(fontSize: 20))),
                Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Container(
                      margin: EdgeInsets.only(left: 10),
                      alignment: Alignment.centerLeft,
                      child: Text(
                          '1. Enter any text you want to jumble and hit Jumble button')),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Container(
                        margin: EdgeInsets.only(left: 10),
                        alignment: Alignment.centerLeft,
                        child: Text(
                            '2. Drag and drop letters to create correct spelling of the word. '))),
//               Padding(
//               padding: EdgeInsets.only(top: 5),
//               child: Container(
//                 alignment: Alignment.centerLeft,
//                 margin: EdgeInsets.only(left: 10),
//               child: Text('3. Hit Jumble button again that will show a fun task as a result of identifying correct order of the spelling. Repeat this until you want to jumble the same word, or go to step 1 for new word.'))
//               )
              ]),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  width: 200,
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                        hintText: 'Enter text',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey)),
                        suffixIcon: IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              _controller.clear();
                              //  _showInstruction = false;
                            })),
                    onSubmitted: (input) {
                      setState(() {
                        textInput = input;
                      });
                    },
                  )),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 15),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    color: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    onPressed: () {
                      setState(() {
                        acceptData = false;
                        _generateJumble(textInput);
                        _controller.clear();
                        //  _showInstruction = true;
                        showTask = true;
                        showToast();
                      });
                    },
                    child: Text('Jumble'),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: inputList.map((i) {
              return Draggable<String>(
                data: i,
                feedback: Container(
                    margin: EdgeInsets.only(right: 5),
                    alignment: Alignment.center,
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(i.toUpperCase(),
                        style: TextStyle(color: Colors.white, fontSize: 18),
                        textAlign: TextAlign.center)),
                child: Container(
                    margin: EdgeInsets.only(right: 5),
                    alignment: Alignment.center,
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(i.toUpperCase(),
                        style: TextStyle(color: Colors.white, fontSize: 18),
                        textAlign: TextAlign.center)),
              );
            }).toList(),
          ),
          Padding(
              padding: EdgeInsets.only(top: 15),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: outputList.map((o) {
                    return DragTarget<String>(
                        builder: (BuildContext context,
                            List<String> candidateData,
                            List<dynamic> rejectedData) {
                          if (acceptData == false && candidateData.isEmpty) {
                            return Container(
                                margin: EdgeInsets.only(right: 5),
                                alignment: Alignment.center,
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text('?',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                    textAlign: TextAlign.center));
                          } else {
                            return Container(
                                margin: EdgeInsets.only(right: 5),
                                alignment: Alignment.center,
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(o.toUpperCase(),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                    textAlign: TextAlign.center));
                          }
                        },
                        onWillAccept: (data) {
                          if (data == o) {
                            acceptData = true;
                            //  showTask = true;
                            return true;
                          } else {
                            acceptData = false;
                            //  showTask = false;
                            return false;
                          }
                        },
                        onAccept: (data) {
                          //  acceptData = true;
                          print(data);
                          if (data == o) {
                            showTask = true;
                          }
                          return true;
                        },
                        onLeave: (data) {});
                  }).toList())),
//           Visibility(
//           visible: _isVisible,
//           child: Padding(
//               padding: EdgeInsets.only(top: 20),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     Text(showTask ? showRandomTask(taskList) : '', style: TextStyle(fontSize: 25))
//                   ])),
//           )
        ]));
  }

  List<String> _generateJumble(String input) {
    inputList = input.split('');
    inputList = inputList.toList()..shuffle();
    outputList = input.split('');

    return inputList;
  }

  showRandomTask(List<String> taskList) {
    var i = random.nextInt(taskList.length);
    return (taskList[i]);
  }
}
