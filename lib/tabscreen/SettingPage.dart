import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  static const sendMsg = const MethodChannel('simplemsgchannel');
  String receivedMsg = "yet to send data";
  List list = [];
  final Map<String, dynamic> formData = {
    'current': null,
    'voltage': null,
    'temperature': null
  };
  final _formKey = GlobalKey<FormState>();
  void _submitForm() {
    print('Submitting form');
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save(); //onSaved is called!
      print(formData);
      list.add(formData);
      print(list);
      sendingMsg();
    }
  }

  Future<void> sendingMsg() async {
    String _receivedMsg = "yet to receive";
    try {
      String result = await sendMsg.invokeMethod('handShakeMsgFunction');
      _receivedMsg = result.toString();
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Form'),
        actions: <Widget>[
          new IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                _submitForm();
              })
        ],
      ),
      body: Form(
        key: _formKey,
        child: new Column(
          children: <Widget>[
            new ListTile(
              leading: const Icon(Icons.person),
              title: new TextFormField(
                decoration: new InputDecoration(
                  hintText: "Current",
                ),
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Preencha a senha';
                  }
                },
                onSaved: (String value) {
                  formData['current'] = value;
                },
              ),
            ),
            new ListTile(
              leading: const Icon(Icons.phone),
              title: new TextFormField(
                decoration: new InputDecoration(
                  hintText: "Voltage",
                ),
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Preencha a senha';
                  }
                },
                onSaved: (String value) {
                  formData['voltage'] = value;
                },
              ),
            ),
            new ListTile(
              leading: const Icon(Icons.email),
              title: new TextFormField(
                decoration: new InputDecoration(
                  hintText: "Temperature",
                ),
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'This is not a valid value';
                  }
                },
                onSaved: (String value) {
                  formData['temperature'] = value;
                },
              ),
            ),
            const Divider(
              height: 1.0,
            ),
          ],
        ),
      ),
    );
  }
}
