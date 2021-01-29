import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_helper/main.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Register extends StatefulWidget {
  @override
  _Register createState() => _Register();
}

class _Register extends State<Register> {
  final _namecontroller = TextEditingController();
  var _addcontroller = TextEditingController();
  final _pscontroller = TextEditingController();
  final _rpscontroller = TextEditingController();
  final _phcontroller = TextEditingController();
  final _emcontroller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeys = GlobalKey<FormState>();
  bool _isDeactivated = true;
  Position _currentPosition;
  LatLng _center = const LatLng(45.521563, -122.677433);
  double latitude, longitude;
  String _currentAddress;
  String _password = "";
  String _rpassword = "";
  String _name = "";
  String _phone = "";
  String _address = "";
  String _email = "";
  Uint8List imageBytess;
  List<Marker> myMarker = [];
  GoogleMapController myController;
  bool _passwordVisible = false;
  bool _rememberMe = false;
  bool _isnotVisible = true;
  bool monVal = false;
  String title = "";
  final _pick = ImagePicker();
  File _fimage;
  String photoBase64;
  String fileName;
  bool _isButtonDisabled = true;
  final db = FirebaseFirestore.instance;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  @override
  void initState() {
    super.initState();
    myMarker = [];
    myMarker.add(Marker(
      markerId: MarkerId(_center.toString()),
      position: _center,
    ));
    _getCurrentLocation();
  }

  Future<void> showMapDialog(BuildContext context) async {
    double width = MediaQuery.of(context).size.width;
    return await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, newSetState) {
            return AlertDialog(
                title: Center(
                  child: Text("Please mark your location"),
                ),
                content: Container(
                  width: width,
                  child: GoogleMap(
                    markers: myMarker.toSet(),
                    onTap: (newLatLng) async {
                      _handleTap(newLatLng, newSetState);
                      Coordinates coordinates = new Coordinates(
                          newLatLng.latitude, newLatLng.longitude);
                      var addresses = await Geocoder.local
                          .findAddressesFromCoordinates(coordinates);
                      print(addresses.first.addressLine);
                      _currentAddress = "${addresses.first.addressLine}";
                      newLatLng.toString();
                      _addcontroller.text = _currentAddress;
                    },
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: _center,
                      zoom: 17.0,
                    ),
                  ),
                ),
                actions: <Widget>[
                  Column(children: <Widget>[
                    Center(
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Text(
                              'Address: ' + _currentAddress.toString(),
                              textAlign: TextAlign.left,
                            ),
                          )
                        ],
                      ),
                    )
                  ]),
                  new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                              width: 300,
                              child: Row(
                                children: [
                                  FlatButton(
                                    child: Text("OK", textAlign: TextAlign.end),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  FlatButton(
                                      child: Text(
                                        "Close",
                                        textAlign: TextAlign.end,
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      }),
                                ],
                              )),
                        )
                      ]),
                ]);
          });
        });
  }

  _handleTap(tappedPoint, newSetState) async {
    latitude = tappedPoint.latitude;
    longitude = tappedPoint.longitude;
    final coordinates = new Coordinates(latitude, longitude);

    try {
      var addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      print(addresses.first.addressLine);
      _currentAddress = "${addresses.first.addressLine}";
      setState(() {});
    } catch (e) {
      print(e);
    }
    newSetState(() {
      myMarker.clear();
      if (_currentAddress != "" && title != "") {
        _isButtonDisabled = false;
      }
      myMarker.add(Marker(markerId: MarkerId('New'), position: tappedPoint));
    });
  }

  _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        if (_currentPosition != position) {
          _currentPosition = position;
          _center = LatLng(position.latitude, position.longitude);
        }
      });

      _getAddressFromLatLng();
      print(_currentPosition);
    }).catchError((e) {
      print(e);
    });
  }

  Future _getImage() async {
    final pickedfile = await _pick.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedfile != null) {
        _fimage = File(pickedfile.path);
        imageBytess = _fimage.readAsBytesSync();
        photoBase64 = base64Encode(imageBytess);
        fileName = pickedfile.path.split('/').last;
      } else {
        print('No image selected.');
      }
    });
  }

  _getAddressFromLatLng() async {
    try {
      final coordinates = new Coordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      var addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      setState(() {
        print(addresses.first.addressLine);
        _currentAddress = "${addresses.first.addressLine}";
        setState(() {});
        _address = _currentAddress;
      });
      _addcontroller.text = _currentAddress;
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      body: Form(
        autovalidateMode: AutovalidateMode.always,
        child: Center(
          child: Container(
              padding: EdgeInsets.all(10),
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  Text('REGISTER'),
                  GestureDetector(
                    onTap: _getImage,
                    child: CircleAvatar(
                      radius: 70,
                      backgroundImage: imageBytess == null? NetworkImage("https://toppng.com/uploads/preview/donna-picarro-dummy-avatar-115633298255iautrofxa.png") : MemoryImage(imageBytess),
                    ),
                  ),
                  Form(
                    autovalidateMode: AutovalidateMode.always,
                    key: _formKeys,
                    child: TextFormField(
                      controller: _namecontroller,
                      onChanged: (_namecontroller) {
                        _name = _namecontroller;
                        this._validateAll();
                        setState(() {});
                      },
                      validator: (_namecontroller) {
                        if (_namecontroller == '') {
                          return 'Please enter your name';
                        } else {
                          _name = _namecontroller;
                        }
                      },
                      decoration: InputDecoration(
                          labelText: 'Name', icon: const Icon(Icons.person)),
                    ),
                  ),
                  TextFormField(
                    controller: _addcontroller,
                    onChanged: (_addcontroller) {
                      _address = _addcontroller;
                      this._validateAll();
                      setState(() {});
                    },
                    decoration: InputDecoration(
                        labelText: 'Address',
                        icon: const Icon(Icons.location_city),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.pin_drop_rounded),
                          onPressed: () async => showMapDialog(context),
                        )),
                  ),
                  Form(
                      autovalidateMode: AutovalidateMode.always,
                      key: _formKey,
                      child: TextFormField(
                          controller: _emcontroller,
                          onChanged: (_emcontroller) {
                            _email = _emcontroller;
                            setState(() {});
                          },
                          keyboardType: TextInputType.emailAddress,
                          validator: (_emcontroller) {
                            if (_emcontroller == '') {
                              return 'Please Enter your email address';
                            } else if (EmailValidator.validate(_emcontroller) ==
                                false) {
                              //_email = '';
                              return 'Please enter a valid email';
                            } else {
                              _email = _emcontroller;
                            }
                          },
                          decoration: InputDecoration(
                              labelText: 'Email',
                              icon: const Icon(Icons.email)))),
                  Form(
                      child: TextFormField(
                          autovalidateMode: AutovalidateMode.always,
                          controller: _phcontroller,
                          onChanged: (_phcontroller) {
                            this._validateAll();
                            setState(() {});
                          },
                          validator: (_phcontroller) {
                            _phone = _phcontroller;
                            if (_phone == '') {
                              return 'Please enter your phone no';
                            } else if (_phone.length < 10) {
                              _phone = _phcontroller;
                              this._validateAll();
                              return 'Please enter a valid phone number';
                            } else {
                              _phone = _phcontroller;
                              this._validateAll();
                            }
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              labelText: 'Phone',
                              icon: const Icon(Icons.phone_android)))),
                  Form(
                    autovalidateMode: AutovalidateMode.always,
                    child: TextFormField(
                      controller: _pscontroller,
                      onChanged: (_pscontroller) {
                        this._validateAll();
                      },
                      validator: (_pscontroller) {
                        if (_pscontroller == '') {
                          _isDeactivated = true;
                          return 'please enter password';
                        } else {
                          return validatePassword(_pscontroller);
                        }
                      },
                      decoration: InputDecoration(
                        labelText: 'Password',
                        icon: Icon(Icons.lock),
                      ),
                      obscureText: _isnotVisible,
                    ),
                  ),
                  Form(
                    autovalidateMode: AutovalidateMode.always,
                    child: TextFormField(
                      controller: _rpscontroller,
                      onChanged: (_rpscontroller) {
                        _rpassword = _rpscontroller;
                        validateRPassword(_rpscontroller, _password);
                        this._validateAll();
                        setState(() {});
                      },
                      validator: (_rpscontroller) {
                        if (_rpscontroller == '') {
                          _isDeactivated = true;
                          return 'Please repeat your password';
                        } else {
                          return validateRPassword(_rpscontroller, _password);
                        }
                      },
                      decoration: InputDecoration(
                          labelText: 'Repeat Password',
                          icon: Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isnotVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isnotVisible = !_isnotVisible;
                              });
                            },
                          )),
                      obscureText: _isnotVisible,
                    ),
                  ),
                  CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text('I agree to the Terms and Conditions'),
                    value: monVal,
                    onChanged: (bool value) {
                      if (value == true) {
                        print(value);
                        monVal = value;
                      } else {
                        print(value);
                        monVal = value;
                      }
                      this._validateAll();
                      setState(() {});
                    },
                  ),
                  Container(
                    height: 10,
                  ),
                  Container(
                      width: 200,
                      child: RaisedButton(
                        color: Colors.red[300],
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(16.0))),
                        child: Text('Register'),
                        onPressed: _isDeactivated ? null : _showDialog,
                      )),
                ],
              ))),
        ),
      ),
    );
  }

  int dah = 0;

  void _onMapCreated(GoogleMapController controller) {
    myController = controller;
  }

  bool _validateAll() {
    if (_name != '' &&
        _password != '' &&
        _rpassword != '' &&
        _password == _rpassword &&
        _phone != '' &&
        _phone.length >= 10 &&
        _address != '' &&
        _email != '' &&
        monVal == true) {
      _isDeactivated = false;
    } else {
      _isDeactivated = true;
    }
  }

  // user defined function
  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Confirm Registration"),
          content:
              new Text("Are you sure to register with the following details?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();
                _onRegister();
              },
            ),
          ],
        );
      },
    );
  }

  void _onRegister() async {
    _name = _namecontroller.text;
    _password = _pscontroller.text;
    _rpassword = _rpscontroller.text;
    _phone = _phcontroller.text;
    _address = _addcontroller.text;
    _email = _emcontroller.text;

    if (_password != _rpassword) {
      if (!validatePhone(_phone)) {
        Toast.show(
          "Check your phone/password",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
        return;
      }
    }
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Registering...");
    await pr.show();

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: _email, password: _password);
      var user = await FirebaseAuth.instance.currentUser;

      await FirebaseAuth.instance.currentUser.updateProfile(
        displayName: _name,
        photoURL: 'define an url',
      );
      await db.collection("Users").doc(_email).set({
        'name': _name,
        'address': _address,
        'email': _email,
        'phone': _phone,
        'image': photoBase64
      });

      user.sendEmailVerification();
      Toast.show(
        "Registration success. Please check your email for OTP verification.",
        context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.TOP,
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        Toast.show(
          "Registration failed Email address already exist",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
        print('An account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    await pr.hide();
  }

  void _onLogin() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
  }

  void _onChange(bool value) {
    setState(() {
      print(monVal);
      _rememberMe = value;
    });
  }

  void savepref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _phone = _phcontroller.text;
    _password = _pscontroller.text;
    await prefs.setString('phone', _phone);
    await prefs.setString('password', _password);
    await prefs.setBool('rememberme', true);
  }

  bool validatePhone(String value) {
    Pattern pattern = r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$';
    RegExp regex = new RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
  }

  String validatePassword(String value1) {
    String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    if (!regExp.hasMatch(value1)) {
      _isDeactivated = true;
      _validateAll();
      return "Your password must have at least 8 characters included\n with a number, one uppercase letter and one \nlowercase letter";
    } else {
      _isDeactivated = false;
      _password = value1;
      _validateAll();
    }
  }

  String validateRPassword(String value2, String value1) {
    if (value2 != value1) {
      return "Password missmatch";
    } else {
      _rpassword = value2;
      _validateAll();
    }
  }
}
