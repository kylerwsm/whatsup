import 'package:flutter/material.dart';
import 'package:flutter_whatsapp/constants.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppConstants.appName,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: Colors.grey[100],
          brightness: Brightness.light,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        primaryTextTheme: TextTheme(
          title: TextStyle(color: Colors.black),
        ),
      ),
      home: BottomNavigatorView(),
    );
  }
}

class BottomNavigatorView extends StatefulWidget {
  @override
  _BottomNavigatorViewState createState() => _BottomNavigatorViewState();
}

class _BottomNavigatorViewState extends State<BottomNavigatorView> {
  /// Indicates the current indexed navigation bar item.
  int currentIndex = 0;

  /// The pages that is represented by each index.
  final pages = [Scaffold(), Scaffold()];

  /// The [AppBar] titles represented by each index.
  final pageTitles = ['Home', 'Settings'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitles[currentIndex]),
      ),
      bottomNavigationBar: BottomNavigationBar(
        // For styling purposes, you can have different selected
        // and unselected font sizes to emphasize the selected option.
        unselectedFontSize: 12.0,
        selectedFontSize: 12.0,
        // The current active index is represented by our
        // [currentIndex] variable.
        currentIndex: currentIndex,
        onTap: (int newIndex) {
          /// When an icon in the [BottomNavigationBar] is tapped,
          /// we want to change the current view to the new view
          /// representented by the recently tapped
          /// [BottomNavigationBarItem].
          setState(() {
            currentIndex = newIndex;
          });
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            title: Text('Home'),
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            title: Text('Settings'),
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: Container(),
    );
  }
}
