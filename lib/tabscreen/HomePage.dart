import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //static const sendMsg = const MethodChannel('simplemsgchannel');
  static const recvMsg = const MethodChannel('simpleReceiveChannel');

  String fromBle = "waiting for message";
  Future<void> receivingMsg() async {
    String _receivedMsg = "waiting to receive....";
    try {
      String result = await recvMsg.invokeMethod('receiveMsgFunction');
      print("Result of Receiving: $result");
      _receivedMsg = result;
      print('REceived message $result');
    } on PlatformException catch (e) {
      print("error + '${e.message}' ");
    }
    setState(() {
      fromBle = _receivedMsg;
    });
  }

  @override
  void initState() {
    super.initState();
    receivingMsg();
    // sendingMsg();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        ElevatedButton(
          child: Text('Receive'),
          onPressed: () {
            receivingMsg();
          },
        ),
        Text(fromBle),
      ],
    ));
  }
}
