import 'package:bmsappversion1/tabscreen/HomePage.dart';
import 'package:bmsappversion1/tabscreen/MonitorPage.dart';
import 'package:bmsappversion1/tabscreen/SettingPage.dart';
import 'package:flutter/material.dart';

class ConnectionStatus extends StatefulWidget {
  ConnectionStatus({Key key}) : super(key: key);

  @override
  _ConnectionStatusState createState() => _ConnectionStatusState();
}

class _ConnectionStatusState extends State<ConnectionStatus> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      HomePage(),
      MonitorPage(),
      SettingPage(),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text('Connectiion Status'),
        backgroundColor: Colors.amber[900],
      ),
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: Row(
        children: [
          buildNavBarItem(context, 0, Icons.home),
          buildNavBarItem(context, 1, Icons.monitor),
          buildNavBarItem(context, 2, Icons.settings),
        ],
      ),
    );
  }

  Widget buildNavBarItem(BuildContext context, int index, IconData iconData) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width / 3,
        decoration: BoxDecoration(
          color: Colors.amber[900],
          // color: index == _selectedIndex ? Colors.black : Colors.white,
        ),
        child: Icon(
          iconData,
          color: index == _selectedIndex ? Colors.black : Colors.white,
        ),
      ),
    );
  }
}
