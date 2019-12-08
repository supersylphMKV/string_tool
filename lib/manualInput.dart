import 'package:flutter/material.dart';
import 'package:text_scan/stringCalculation.dart';

class KeyboardInput extends StatefulWidget {
  @override
  _KeyboardInputState createState() => _KeyboardInputState();
}

class _KeyboardInputState extends State<KeyboardInput> {
  var itteration = 'Itteration Count';
  var textRes = '';
  List<Widget> textResults = <Widget>[
    Text('Itteration Count',
      style: TextStyle(
        color: Colors.amber,
      ),
    )
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(48),
            child: TextField(
              style: TextStyle(color: Colors.lightBlue),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.blueGrey.withAlpha(100),
                hintStyle: TextStyle(color: Colors.amberAccent.withAlpha(100)),
                hintText: 'Input String'
              ),
              onSubmitted: (value)async{
                if(value != ''){
                  StringResult encode = await readText(value.toLowerCase());
                  setState(() {
                    textRes = encode.result;
                    textResults = <Widget>[
                      Text( encode.stackTrace.length.toString() +  ' itterations',
                        style: TextStyle(
                          color: Colors.amber,
                        ),
                      )
                    ];

                    for(var i=0; i < encode.stackTrace.length;i++){
                      textResults.add(Text('[' + encode.stackTrace[i] + ']',
                        style: TextStyle(
                          color: Colors.amber,
                          fontStyle: FontStyle.italic
                        ),
                      ));
                    }
                  });
                }
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(40, 0 , 40 ,40),
            child: Card(
              color: Colors.blueGrey.withAlpha(50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      children : <Widget>[
                        Text('Result',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.amber,
                          ),
                        ),
                        Text(textRes,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.amber,
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ]
                    )
                  ),
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: textResults,
                    ),
                  )
                ],
              ),
            )
          )
        ],
      ),
    );
  }
}