
import 'package:flutter/material.dart';
import 'package:text_scan/cameraInput.dart';
import 'package:text_scan/manualInput.dart';
import 'package:text_scan/stringCalculation.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StringChecker',
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        textTheme: TextTheme(overline: TextStyle(color: Colors.amberAccent)),
        scaffoldBackgroundColor: Colors.grey.withAlpha(50),
        primarySwatch: Colors.amber,
      ),
      home: MyHomePage(title: 'StringMenu'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var pagesIdx = 0;
  var pages = [
    KeyboardInput(),
    CameraInput()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[pagesIdx],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blueGrey.withAlpha(100),
        currentIndex: pagesIdx,
        items: [
          BottomNavigationBarItem(
            title: Text('Manual'),
            icon: Icon(Icons.keyboard),
          ),
          BottomNavigationBarItem(
            title: Text('Camera'),
            icon: Icon(Icons.camera)
          )
        ],
        onTap: (value){
          setState(() {
            pagesIdx = value;
          });
        },
      ),
    );
  }
}
