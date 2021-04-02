import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  String bluetoothStatus = "Yet to receive";
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

  Future<void> connectDevice(index) async {
    int params = index;
    String _bluetoothStatus;
    try {
      // print(index);
      final String result = await getConnected
          .invokeMethod('connectDeviceFunction', {"indexparam": params});
      _bluetoothStatus = result;
    } on PlatformException catch (e) {
      print("error + '${e.message}' ");
    }
    setState(() {
      bluetoothStatus = _bluetoothStatus;
      print("status Check + '$bluetoothStatus' ");
    });
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
                      subtitle: Text(bluetoothStatus),
                      trailing: Icon(Icons.more_vert),
                      onTap: () {
                        print(bondedDevicelist[index].toString());
                        connectDevice(index);
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
