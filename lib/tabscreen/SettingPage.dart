import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  static const sendMsg = const MethodChannel('simplemsgchannel');
  String receivedMsg = "yet to send data";
  var extractedData;
  List list = [];
  final Map<String, dynamic> formData = {
    'lowcurrent': null,
    'highcurrent': null,
    'lowvoltage': null,
    'highvoltage': null,
    'temperaturelow': null,
    'temperaturehigh': null,
  };
  final _formKey = GlobalKey<FormState>();
  void _submitForm() {
    print('Submitting form');
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save(); //onSaved is called!
      print("values from fomr : $formData");
      // json.encode(formData);
      list.add(formData);
      extractedData = json.encode(formData);
      print("list value: $list");
      print("to json: $extractedData");
      sendingMsg();
    }
  }

  Future<void> sendingMsg() async {
    String _receivedMsg = "yet to receive";
    try {
      String result =
          await sendMsg.invokeMethod('handShakeMsgFunction', formData);
      // _receivedMsg = result.toString();
      print('REceived message $result');
    } on PlatformException catch (e) {
      print("error + '${e.message}' ");
    }
    setState(() {
      //receivedMsg = _receivedMsg;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(children: [
        Container(
          // padding: EdgeInsets.only(top: 2, left: 10, right: 10, bottom: 30),
          padding: EdgeInsets.only(top: 2, left: 10, right: 10, bottom: 2),
          height: 600,
          child: Card(
            child: Form(
              key: _formKey,
              child: new Column(
                children: <Widget>[
                  // current lowcutoff
                  new ListTile(
                    leading: const Icon(Icons.flash_on),
                    title: Text(
                      'CurrentLowCutOff',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.amber[900]),
                    ),
                    trailing: Container(
                      height: 40,
                      width: 60,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.amber[900])),
                      child: new TextFormField(
                        decoration:
                            new InputDecoration(border: InputBorder.none),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Preencha a senha';
                          }
                        },
                        onSaved: (String value) {
                          formData['lowcurrent'] = value;
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  //current highcutoff
                  new ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(
                      'CurrentHighCutOff',
                      style: TextStyle(
                          color: Colors.amber[900],
                          fontWeight: FontWeight.bold),
                    ),
                    trailing: Container(
                      height: 40,
                      width: 60,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.amber[900]),
                      ),
                      child: new TextFormField(
                        decoration:
                            new InputDecoration(border: InputBorder.none),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Preencha a senha';
                          }
                        },
                        onSaved: (String value) {
                          formData['highcurrent'] = value;
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  //voltage lowcutoff
                  new ListTile(
                    leading: const Icon(Icons.phone),
                    title: Text(
                      'VoltageLowCutOff',
                      style: TextStyle(
                          color: Colors.amber[900],
                          fontWeight: FontWeight.bold),
                    ),
                    trailing: Container(
                      height: 40,
                      width: 60,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.amber[900])),
                      child: new TextFormField(
                        decoration:
                            new InputDecoration(border: InputBorder.none),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Preencha a senha';
                          }
                        },
                        onSaved: (String value) {
                          formData['lowvoltage'] = value;
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  //voltage highcutoff
                  new ListTile(
                    leading: const Icon(Icons.phone),
                    title: Text(
                      'VoltageHighCutOff',
                      style: TextStyle(
                          color: Colors.amber[900],
                          fontWeight: FontWeight.bold),
                    ),
                    trailing: Container(
                      height: 40,
                      width: 60,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.amber[900])),
                      child: new TextFormField(
                        decoration:
                            new InputDecoration(border: InputBorder.none),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Preencha a senha';
                          }
                        },
                        onSaved: (String value) {
                          formData['highvoltage'] = value;
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  //temp lowcutoff
                  new ListTile(
                    leading: const Icon(Icons.email),
                    title: Text(
                      'TempLowCutOff',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.amber[900]),
                    ),
                    trailing: Container(
                      height: 40,
                      width: 60,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.amber[900])),
                      child: new TextFormField(
                        decoration:
                            new InputDecoration(border: InputBorder.none),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'This is not a valid value';
                          }
                        },
                        onSaved: (String value) {
                          formData['temperaturelow'] = value;
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  //temp highcutoff
                  new ListTile(
                    leading: const Icon(Icons.phone),
                    title: Text(
                      'TempHighCutOff',
                      style: TextStyle(
                          color: Colors.amber[900],
                          fontWeight: FontWeight.bold),
                    ),
                    trailing: Container(
                      height: 40,
                      width: 60,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.amber[900])),
                      child: new TextFormField(
                        decoration:
                            new InputDecoration(border: InputBorder.none),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Preencha a senha';
                          }
                        },
                        onSaved: (String value) {
                          formData['temperaturehigh'] = value;
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // ignore: deprecated_member_use
                  // //  ElevatedButton(
                  // child: Text('Receive'),
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.amber[700], // background
                        ),
                        child: Text(
                          'Set As',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),

                        //color: Colors.amber[900],
                        onPressed: () {
                          _submitForm();
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  const Divider(
                    height: 1.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

// https://bezkoder.com/dart-flutter-convert-object-to-json-string/
class User {
  int lowcurrent;
  int highcurrent;
  int lowvoltage;
  int highvoltage;
  int temperaturelow;
  int temperaturehigh;

  User(this.lowcurrent, this.highcurrent, this.lowvoltage, this.highvoltage,
      this.temperaturelow, this.temperaturehigh);

  Map toJson() => {
        'lowcurrent': lowcurrent,
        'highcurrent': highcurrent,
        'lowvoltage': lowvoltage,
        'highvoltage': highvoltage,
        'temperaturelow': temperaturelow,
        'temperaturehigh': temperaturehigh
      };
}
