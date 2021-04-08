import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ConnectionStatus extends StatefulWidget {
  ConnectionStatus({Key key}) : super(key: key);

  @override
  _ConnectionStatusState createState() => _ConnectionStatusState();
}

class _ConnectionStatusState extends State<ConnectionStatus> {
  static const sendMsg = const MethodChannel('simplemsgchannel');
  static const recvMsg = const MethodChannel('simpleReceiveChannel');
  String receivedMsg = "yet to send data";
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

  Future<void> sendingMsg() async {
    String _receivedMsg = "yet to receive";
    try {
      String result = await sendMsg.invokeMethod('handShakeMsgFunction');
      _receivedMsg = result;
      print('REceived message $result');
    } on PlatformException catch (e) {
      print("error + '${e.message}' ");
    }
    setState(() {
      receivedMsg = _receivedMsg;
    });
  }

  @override
  void initState() {
    super.initState();
    // receivingMsg();
    // sendingMsg();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Connectiion Status'),
          backgroundColor: Colors.amber[900],
        ),
        body: _buildPage(),
        bottomNavigationBar: _buildBottomNav(),
      ),
    );
  }

  Widget _buildPage() {
    return Container(
      child: Column(
        children: [
          Text(
            "Received from ble ..." + fromBle,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            "APP TO BLE ..." + receivedMsg,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          ElevatedButton(onPressed: sendingMsg, child: Text('Send Data')),
          //ElevatedButton(onPressed: receivingMsg, child: Text('Receive Data')),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            size: 30,
            color: Color(0XFFFF6F00),
          ),
          label: 'Home',
          backgroundColor: Colors.amber,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.monitor,
            size: 30,
            color: Color(0XFFFF6F00),
          ),
          label: 'Monitor',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.settings,
            size: 30,
            color: Color(0XFFFF6F00),
          ),
          label: 'Settings',
        ),
      ],
    );
  }
} // End of Class
