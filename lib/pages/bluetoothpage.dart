import 'package:bmsappversion1/pages/bondeddevicepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BluetoothPage extends StatefulWidget {
  BluetoothPage({Key key}) : super(key: key);

  @override
  _BluetoothPageState createState() => _BluetoothPageState();
}

class _BluetoothPageState extends State<BluetoothPage> {
  String message = "No Message from Native App";
  String messageFromNative = "Function invoking from Native";
  static const platformbOn = const MethodChannel('bonChannel');
  bool bleStatus = false;

  Future<void> onBluetooth() async {
    try {
      bleStatus = await platformbOn.invokeMethod('checkBluetoothState');
      //print("status: +$message");
      print("Status: + $bleStatus");
      // print(' Bonded Device : $bondedDevicelist');
    } on PlatformException catch (e) {
      print("error + '${e.message}' ");
      message = "Failed to get Native App function: '${e.message}'.";
    }
    setState(() {
      // message = bleStatus.toString();
      bleStatus = bleStatus;
    });
  }

  Widget getBondedDevice() {
    return bleStatus
        ? SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BondedDevicePage(),
                  ),
                );
              },
              child: Text('SHOW PAIRED DEVICE',
                  style: TextStyle(fontSize: 15, letterSpacing: 2)),
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.amber[900]),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: BorderSide(color: Colors.amber[900]),
                  ),
                ),
              ),
            ),
          )
        : Text("Turn your bluetooth on to get Paired Device");
  }

  Widget discoverDevice() {
    return bleStatus
        ? SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => BluetoothPage()));
              },
              child: Text('DISCOVER NEW DEVICE',
                  style: TextStyle(fontSize: 15, letterSpacing: 2)),
              style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.amber[900]),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: BorderSide(color: Colors.amber[900])))),
            ),
          )
        : Text("Turn your bluetooth on to get Scan Device");
  }

  @override
  void initState() {
    super.initState();
    // switching on blutooth adapter
    onBluetooth();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[900],
        title: Text('Bluetooth Page'),
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                bleStatus.toString(),
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onBluetooth,
                  child: Text('BLUETOOTH ON/OFF',
                      style: TextStyle(fontSize: 15, letterSpacing: 2)),
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.amber[900]),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: BorderSide(color: Colors.amber[900]),
                      ),
                    ),
                  ),
                ),
              ),
              getBondedDevice(),
              discoverDevice(),
            ],
          ),
        ),
      ),
    );
  }
}
