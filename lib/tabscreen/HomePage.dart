import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'dart:convert';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const recvMsg = const MethodChannel('simpleReceiveChannel');
  String fromBle = "waiting for message";
  String _receivedMsg = "waiting to receive....";
  bool isData = false;
  Future<void> receivingMsg() async {
    try {
      var result = await recvMsg.invokeMethod('receiveMsgFunction');
      if (result == null) {
        isData = false;
      } else {
        isData = true;
      }
      _receivedMsg = result;

      print("Result of Receiving: $result");
    } on PlatformException catch (e) {
      print("error + '${e.message}' ");
    }
    setState(() {
      isData = true;
      fromBle = _receivedMsg;
    });
  }
  /* Map<String, dynamic> user;
  Map<String, dynamic> fromBle;
  Future<void> receivingMsg() async {
    try {
      var result = await recvMsg.invokeMethod('receiveMsgFunction');
      user = jsonDecode(result);
      fromBle = user;
      print("Result of Receiving: $fromBle");
    } on PlatformException catch (e) {
      print("error + '${e.message}' ");
    }
    setState(() {
      //fromBle = _receivedMsg;
      fromBle = user;
    });
  }*/

  /*void callSetState() {
    setState(() {
      fromBle = _receivedMsg;
    });
  }*/

  @override
  void initState() {
    super.initState();
    receivingMsg();
  }

  Widget noDataScreen() {
    return Text("Data yet to receive");
  }

  Widget dataScreen() {
    return FutureBuilder(
      future: receivingMsg(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return Center(
            child: Column(
          children: [
            ElevatedButton(
              child: Text('Refresh'),
              onPressed: () {
                receivingMsg();
              },
            ),
            Text(fromBle),
          ],
        ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return isData ? dataScreen() : noDataScreen();
  }
}
