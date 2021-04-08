import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bmsappversion1/pages/connectionStatus.dart';

//import 'connectionStatus.dart';

class BondedDevicePage extends StatefulWidget {
  BondedDevicePage({Key key}) : super(key: key);

  @override
  _BondedDevicePageState createState() => _BondedDevicePageState();
}

class _BondedDevicePageState extends State<BondedDevicePage> {
  static const getBonded = const MethodChannel('bondedchannel');
  static const getConnected = const MethodChannel('connectchannel');

  String message = "No Message from Native App";
  String messageFromNative = "Function invoking from Native";
  bool bluetoothStatus;
  //String bluetoothStatusFromNative;

  BluetoothDevice device;
  List<BluetoothDevice> btDevicelist = [];
  List<dynamic> bondedDevicelist = [];
  Future<void> bondDevice() async {
    try {
      bondedDevicelist = await getBonded.invokeMethod('getBondeddevice');
      print(' Bonded Device : $bondedDevicelist');
    } on PlatformException catch (e) {
      print("error + '${e.message}' ");
      message = "Failed to get Native App function: '${e.message}'.";
    }
    setState(() {
      message = bondedDevicelist.toString();
    });
  }

  Future<dynamic> connectDevice(index) async {
    int params = index;
    bool _bluetoothStatus;
    try {
      final bool result = await getConnected
          .invokeMethod('connectDeviceFunction', {"indexparam": params});
      _bluetoothStatus = result;
    } on PlatformException catch (e) {
      print("error + '${e.message}' ");
    }
    setState(() {
      bluetoothStatus = _bluetoothStatus;
      if (bluetoothStatus == true) {
        print("status Check + '$bluetoothStatus' ");
        showAlertDialog(context, bluetoothStatus);
      } else {
        print("status Check + '$bluetoothStatus' ");
        showAlertDialog(context, bluetoothStatus);
      }
    });
  }

  static const PLATFORM_CHANNEL = const MethodChannel('platform_channel');
// you can use whatever you like. but make sure you use the same channel string in native code also

// platform channel method calling
  Future<Null> demoFunction(BuildContext context) async {
    try {
      final String result = await PLATFORM_CHANNEL
          .invokeMethod('demoFunction', // call the native function
              <String, dynamic>{
            // data to be passed to the function
            'data': 'sample data',
          });
      // result hold the response from plaform calls
    } on PlatformException catch (error) {
      // handle error
      print('Error: $error'); // here
    }
  }

  showAlertDialog(BuildContext context, bool bleStatus) {
    // set up the button
    Widget okButton = OutlinedButton.icon(
      icon: Icon(
        Icons.bluetooth_connected,
        size: 30,
        color: Color(0XFFFF6F00),
      ),
      label: Text(
        "GO",
        style: TextStyle(fontSize: 15, color: Color(0XFFFF6F00)),
      ),
      style: ElevatedButton.styleFrom(
        side: BorderSide(
          width: 3.0,
          color: Color(0XFFFF6F00),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
      ),
      onPressed: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ConnectionStatus()),
        );
      },
    );

    Widget refreshButton = OutlinedButton.icon(
      icon: Icon(
        Icons.refresh,
        size: 30,
        color: Color(0XFFFF6F00),
      ),
      label: Text(
        "Refresh",
        style: TextStyle(fontSize: 15, color: Color(0XFFFF6F00)),
      ),
      style: ElevatedButton.styleFrom(
        side: BorderSide(
          width: 3.0,
          color: Color(0XFFFF6F00),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
      ),
      onPressed: () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => super.widget));
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      insetPadding: EdgeInsets.all(10),
      title: bluetoothStatus
          ? Text("Your Device is Connected ")
          : Text("Your Device is not Connected"),
      content: bluetoothStatus
          ? Text("You can send or receive data")
          : Text("You cannot send or receive data"),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      actions: [bluetoothStatus ? okButton : refreshButton],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // switching on blutooth adapter
    bondDevice();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: listBondedDevice(context),
    );
  }

  // listing Bonded Device
  Scaffold listBondedDevice(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[900],
        title: Center(child: Text('Paired Device List')),
      ),
      body: listViewSplitting(),
    );
  } // end of list of Bonded Device

  listViewSplitting() {
    return Center(
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: bondedDevicelist.length,
              itemBuilder: (BuildContext ctxt, int index) {
                return Container(
                  margin: EdgeInsets.only(top: 10.0),
                  padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                  child: Card(
                    elevation: 3,
                    child: ListTile(
                      leading: Icon(
                        Icons.bluetooth,
                        color: Colors.amber[900],
                        size: 30.0,
                      ),
                      //  selected: true,
                      title: Text(
                        bondedDevicelist[index].toString(),
                        style: TextStyle(fontSize: 18.0),
                      ),
                      // subtitle: Text(bluetoothStatus.toString()),
                      trailing: Icon(Icons.more_vert),
                      onTap: () {
                        print(bondedDevicelist[index].toString());
                        connectDevice(index);
                        // ConnectionStatus();
                        // showAlertDialog(context);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class BluetoothDevice {}
