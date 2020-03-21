import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_whatsapp/app_state.dart';
import 'package:flutter_whatsapp/constants.dart';
import 'package:flutter_whatsapp/tab_item.dart';
import 'package:flutter_whatsapp/user_chat.dart';
import 'package:flutter_whatsapp/user_settings.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /// Forces the app to only be in portrait view.
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider(
          create: (_) => AppState(),
        ),
      ],
      child: MaterialApp(
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
        darkTheme: ThemeData.dark(),
        home: BottomNavigatorView(),
      ),
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

  /// The [AppBar] titles represented by each index.
  final List<TabItem> tabs = [
    TabItem('Chat', Icons.chat, UserChat()),
    TabItem('Settings', Icons.settings, UserSettings()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        // For styling purposes, you can have different selected
        // and unselected font sizes to emphasize the selected option.
        unselectedFontSize: 12.0,
        selectedFontSize: 12.0,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0.0,
        // The current active index is represented by our
        // [currentIndex] variable.
        currentIndex: currentIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (int newIndex) {
          /// When an icon in the [BottomNavigationBar] is tapped,
          /// we want to change the current view to the new view
          /// representented by the recently tapped
          /// [BottomNavigationBarItem].
          setState(() {
            currentIndex = newIndex;
          });
        },
        items: tabs
            .map(
              (TabItem tab) => BottomNavigationBarItem(
                title: Text(tab.name),
                icon: Icon(
                  tab.icon,
                ),
              ),
            )
            .toList(),
      ),
      body: tabs[currentIndex].page,
    );
  }
}
