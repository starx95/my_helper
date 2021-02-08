import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_helper/views/new_job/new_job.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:splashscreen/splashscreen.dart';
import 'Home.dart';
import 'Profile.dart';
import 'Register.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'gpsLocation.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:location/location.dart' as loc;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  ServiceStatus serviceStatus =
      await LocationPermissions().checkServiceStatus();
  if (serviceStatus.toString() == "ServiceStatus.disabled") {
    loc.Location locationR = loc.Location();
    if (!await locationR.serviceEnabled()) {
      locationR.requestService();
    }
  }
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getString('name') != "") {
    LoginScreen.name = prefs.getString('name');
    LoginScreen.email = prefs.getString('email');
    LoginScreen.address = prefs.getString('address');
    LoginScreen.image = prefs.getString('image');
    LoginScreen.phone = prefs.getString('phone');
  }
  print(serviceStatus.toString());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splash Screen',
      theme: ThemeData(
        primarySwatch: Colors.red,
        fontFamily: 'Roboto',
        cursorColor: Color(0xffbe3e57),
      ),
      home: SplashScreenPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  initState() {
    FirebaseAuth auth = FirebaseAuth.instance;
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 2,
      navigateAfterSeconds: LoginScreen(),
      backgroundColor: Colors.white,
      image: new Image.asset('assets/images/myHelper.png'),
      loadingText: Text("Loading"),
      photoSize: 150.0,
      loaderColor: Colors.red,
    );
  }
}

class LoginScreen extends StatefulWidget {
  static var name, body, email, address, phone, image;
  static var session = FlutterSession();
  static dynamic token;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  ProgressDialog pr;
  bool loading = false;
  final db = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Logging in...");
    AskForPermission();
    runApp(MaterialApp(home: LoginScreen.name != null ? Home() : LoginScreen()));
  }

  var _emcontroller = TextEditingController();
  var _passwordcontroller = TextEditingController();
  String _em = "";
  String _pw = "";
  SharedPreferences prefs;
  bool _showPassword = true;
  bool _enabled = false;
  bool emailValid;
  User user;

  void showToast() {}
  void onPressVisibility(int no) {
    setState(() {
      if (no == 1) {
        _showPassword = !_showPassword;
      } else {}
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
        title: 'Material App',
        home: Scaffold(
          backgroundColor: Color(0xffFFFFFF),
          body: Center(
              child: SingleChildScrollView(
                  child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                          Image.asset('assets/images/myHelper.png',
                              width: 300, height: 300),
                          GestureDetector(
                            child: Form(
                              autovalidateMode: AutovalidateMode.always,
                              child: TextFormField(
                                controller: _emcontroller,
                                onChanged: (_emcontroller) {
                                  _em = _emcontroller;
                                  emailValid = RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(_em);
                                  this.enable();
                                  if (emailValid = RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(_em)) {
                                    enable();
                                  }
                                },
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    labelText: 'Email',
                                    labelStyle: new TextStyle(
                                      color: Colors.red,
                                    ),
                                    icon: const Icon(Icons.email)),
                              ),
                            ),
                          ),
                          GestureDetector(
                              onTapCancel: () {
                                setState(() {
                                  _pw = _passwordcontroller.toString();
                                });
                              },
                              child: Form(
                                  autovalidateMode: AutovalidateMode.always,
                                  child: TextFormField(
                                    controller: _passwordcontroller,
                                    onChanged: (_passwordcontroller) {
                                      _pw = _passwordcontroller;
                                      this.enable();
                                      if (_pw != '') {
                                        enable();
                                      }
                                    },
                                    decoration: InputDecoration(
                                        labelText: 'Password',
                                        suffixIcon: IconButton(
                                            icon: Icon(
                                              _showPassword
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                            ),
                                            onPressed: () {
                                              onPressVisibility(1);
                                            }),
                                        labelStyle: new TextStyle(
                                          color: Colors.red,
                                        ),
                                        icon: const Icon(Icons.lock)),
                                    obscureText: _showPassword,
                                  ))),
                          Container(
                            height: 10,
                          ),
                          GestureDetector(
                              child: Text(
                            'Forgot password?',
                            style: new TextStyle(
                              fontSize: 16,
                              color: Colors.red,
                            ),
                          )),
                          Container(
                            height: 10,
                          ),
                          Container(
                              width: 200,
                              child: RaisedButton(
                                color: Colors.red[300],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(16.0))),
                                child: Text('Sign In'),
                                onPressed: _enabled ? _onLogin : null,
                              )),
                          GestureDetector(
                            onTap: _onRegister,
                            child: Text(
                              'Register Here',
                              style: new TextStyle(fontSize: 18),
                            ),
                          )
                        ],
                      )))),
        ));
  }

  enable() {
    if (RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(_em) &&
        _pw != '') {
      _enabled = true;
      onPressVisibility(2);
    } else {
      _enabled = false;
      onPressVisibility(2);
    }
  }

  Future<void> _onLogin() async {
    await pr.show();
    _em = _emcontroller.text;
    _pw = _passwordcontroller.text;

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _em, password: _pw);

      FirebaseFirestore.instance
          .collection('Users')
          .doc(_em)
          .get()
          .then((DocumentSnapshot documentSnapshot) async {
        if (documentSnapshot.exists) {
          prefs = await SharedPreferences.getInstance();
          prefs.setString('name', documentSnapshot.get("name"));
          prefs.setString('email', documentSnapshot.get("email"));
          prefs.setString('address', documentSnapshot.get("address"));
          prefs.setString('phone', documentSnapshot.get("phone"));
          prefs.setString('image', documentSnapshot.get("image"));
          LoginScreen.name = prefs.getString('name');
          LoginScreen.email = prefs.getString('email');
          LoginScreen.address = prefs.getString('address');
          LoginScreen.phone = prefs.getString('phone');
          print('Phone: '+LoginScreen.phone);
          LoginScreen.image = prefs.getString('image');
          checkEmailVerified();
        }
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Toast.show(
          'No user found for that email.',
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM,
        );
        pr.hide();
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        Toast.show(
          'Wrong password provided for that user.',
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM,
        );
        pr.hide();
        print('Wrong password provided for that user.');
      } else if (e.code == 'too-many-requests') {
        Toast.show(
          'Too many request in a short time try again after a few minutes',
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM,
        );
        pr.hide();
        print("Too many request in a short time try again after a few minutes");
      }
    } catch (e) {
      print(e.code + " test");
    }
  }

  Future<void> checkEmailVerified() async {
    final auth = FirebaseAuth.instance;
    user = auth.currentUser;
    if (user.emailVerified) {
      if (LoginScreen.name != "" &&
          LoginScreen.email != "" &&
          LoginScreen.address != "") {
        Future.delayed(const Duration(milliseconds: 1000), () {
          pr.hide();
          Toast.show(
            "Login Success",
            context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.TOP,
          );
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => Home(),
                  settings: RouteSettings(
                    arguments: LoginScreen.email,
                  )));
        });
      }
    } else {
      prefs.setString('name', "");
          prefs.setString('email', "");
          prefs.setString('address', "");
          prefs.setString('phone', "");
      pr.hide();
      Toast.show(
        "Please verify your email first",
        context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.TOP,
      );
    }
  }

  void _onRegister() {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => Register()));
  }
}

class CircularProgressIndicatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      backgroundColor: Colors.black12,
      strokeWidth: 8,
    );
  }
}
