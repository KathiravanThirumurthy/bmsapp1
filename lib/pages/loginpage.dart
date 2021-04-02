import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:avatar_glow/avatar_glow.dart';

import 'bluetoothpage.dart';

final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['profile', 'email']);

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isAuth = false;
  GoogleSignInAccount _currentUser;

  Widget buildAuthScreen() {
    //return Text(_currentUser.displayName ?? '');
    return SafeArea(
      child: Center(
        child: Container(
          margin: EdgeInsets.only(top: 50),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(_currentUser.photoUrl),
                radius: 50,
              ),
              SizedBox(height: 15),
              Text(
                'You are logged in as ',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                ),
              ),
              SizedBox(height: 5),
              Text(
                _currentUser.email,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton(
                onPressed: _logout,
                child: Text("Logout".toUpperCase(),
                    style: TextStyle(fontSize: 14, letterSpacing: 2)),
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
              Container(
                // height: 300,
                child: AvatarGlow(
                  glowColor: Colors.blue,
                  endRadius: 70.0,
                  duration: Duration(milliseconds: 2000),
                  repeat: true,
                  showTwoGlows: true,
                  repeatPauseDuration: Duration(milliseconds: 100),
                  child: Material(
                    elevation: 4.0,
                    shape: CircleBorder(),
                    child: CircleAvatar(
                      backgroundColor: Colors.grey[200],
                      child: Image.asset(
                        'images/bt.png',
                        height: 40,
                        width: 250,
                        fit: BoxFit.fitWidth,
                      ),
                      radius: 40.0,
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => BluetoothPage()));
                },
                child: Text('Find your device',
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
            ],
          ),
        ),
      ),
    );
  }

  _login() {
    googleSignIn.signIn();
  }

  _logout() {
    googleSignIn.signOut();
  }

  Widget buildUnAuthScreen() {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Image.asset('images/touch.png'),
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(
            'Next Generation Battery',
            style: TextStyle(fontSize: 15, color: Colors.grey),
          ),
          SizedBox(
            height: 5.0,
          ),
          Container(
            child: GestureDetector(
              onTap: () {
                _login();
              },
              child: Image.asset(
                'images/signin.png',
                height: 75,
                width: 250,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          Text(
            'Sign up here',
            style: TextStyle(fontSize: 15, color: Colors.grey),
          ),
        ],
      ),
    ));
  }

  void handleSignin(GoogleSignInAccount account) {
    if (account != null) {
      print('User Signed in $account');

      setState(() {
        isAuth = true;
        _currentUser = account;
      });
    } else {
      setState(() {
        isAuth = false;
        //_currentUser = null;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      handleSignin(account);
    }, onError: (err) {
      print('Error Signiing in : $err');
    });
    // Reauthenticate user when app is opened
    /*googleSignIn.signInSilently(suppressErrors: false).then((account) {
      handleSignin(account);
    }).catchError((err) {
      print('Error Signiing in : $err');
    });*/
  }

  @override
  Widget build(BuildContext context) {
    return isAuth ? buildAuthScreen() : buildUnAuthScreen();
  }
}
