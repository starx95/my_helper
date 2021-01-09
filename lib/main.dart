import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:splashscreen/splashscreen.dart';
import 'Home.dart';
import 'Register.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getString('name') != null) {
    LoginScreen.name = prefs.getString('name');
    LoginScreen.email = prefs.getString('email');
    LoginScreen.address = prefs.getString('address');
  }
  
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splash Screen',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: SplashScreenPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreenPage extends StatelessWidget {  
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

  check() {
    print("Test");
    runApp(MaterialApp(home: LoginScreen.name != '' ? Home() : LoginScreen()));
  }  
}  

class LoginScreen extends StatefulWidget {
  static var name, body, email, address;
  static var session = FlutterSession();
  static dynamic token;
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    runApp(MaterialApp(home: LoginScreen.name != '' ? Home() : LoginScreen()));
    
  }
  var _emcontroller = TextEditingController();
  var _passwordcontroller = TextEditingController();
  String _em = "";
  String _pw = "";
  bool _showPassword = true;
  bool _enabled = false;
  bool emailValid;
  void showToast() {}
  void onPressVisibility(int no) {
    setState(() {
      if(no == 1){_showPassword = !_showPassword;}
      else{}
      
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    TextEditingController pwcontroller;
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
                                      emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_em);
                                      this.enable();
                                      if(emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_em)){
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
                                      if(_pw != ''){
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
    if (RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_em) && _pw != '') {
      _enabled = true;
      onPressVisibility(2);
    } else {
      _enabled = false;
      onPressVisibility(2);
    }
  }

  Future<void> _onLogin() async {
    _em = _emcontroller.text;
    _pw = _passwordcontroller.text;
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Login...");
    await pr.show();
    http.post("https://starxdev.com/stiw2044/login_user.php", body: {
      "email": _em,
      "password": _pw,
    }).then((res) async {
      if (res.body.contains("name")) {
        await LoginScreen.session.set('user', _em);
        LoginScreen.token = await LoginScreen.session.get('user');
        print(json.decode(res.body));
        LoginScreen.body = json.decode(res.body);
        //await LoginScreen.session.set('name', LoginScreen.body[0]['name']);
        //await LoginScreen.session.set('email', LoginScreen.body[0]['email']);
        //await LoginScreen.session.set('address', LoginScreen.body[0]['address']);
        
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('name', LoginScreen.body[0]['name']);
        prefs.setString('email', LoginScreen.body[0]['email']);
        prefs.setString('address', LoginScreen.body[0]['address']);

        LoginScreen.name = prefs.getString('name');
        LoginScreen.email = prefs.getString('email');
        LoginScreen.address = prefs.getString('address');
        Toast.show(
          "Login Success",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => Home()));
      } else {
        Toast.show(
          "Login failed",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
      }
    }).catchError((err) {
      print(err);
    });

    await pr.hide();
  }

  void _onRegister() {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => Register()));
  }
}
