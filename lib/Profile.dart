import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:my_helper/Home.dart';
import 'package:my_helper/main.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool _rememberMe = false;
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController address = TextEditingController();
  Future<File> file;
  String status = '';
  String base64Image;
  File tmpFile;
  String fileName;
  CollectionReference jobs;
  String errMessage = 'Error Uploading Image';
  File _fimage;
  final _pick = ImagePicker();
  var _addcontroller = TextEditingController();

  Position _currentPosition;
  LatLng _center = const LatLng(6.457510, 100.505455);
  double latitude, longitude;
  String _currentAddress;
  String _address = "";
  List<Marker> myMarker = [];
  GoogleMapController myController;
  bool monVal = false;
  String title = "";
  bool _isButtonDisabled = true;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    jobs = _firestore.collection('Jobs');
    name.text = LoginScreen.name;
    phone.text = LoginScreen.email;
    address.text = LoginScreen.address;
  }

  Future _getImage() async {
    final pickedfile = await _pick.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedfile != null) {
        _fimage = File(pickedfile.path);
        fileName = pickedfile.path.split('/').last;
      } else {
        print('No image selected.');
      }
    });
  }

  setStatus(String message) {
    setState(() {
      status = message;
    });
  }

  startUpload(names, emails, addresses) async {
    http.post("https://starxdev.com/stiw2044/updateuser.php", body: {
      "emaillama": LoginScreen.email,
      "name": names,
      "address": addresses,
      "email": emails,
    }).then((res) {
      print(res.body);
      if (res.body.contains('Duplicate')) {
        Toast.show(
          "Update failed",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
      }
      if (res.body == "succes") {
        Toast.show(
          "Update success",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
        LoginScreen.name = names;
        LoginScreen.email = emails;
        LoginScreen.address = addresses;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      } else {
        Toast.show(
          "Update failed",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
      }
    }).catchError((err) {
      print(err);
    });
    http.post("https://starxdev.com/stiw2044/uploadimage.php", body: {
      "image": base64Image,
      "name": fileName,
    }).then((res) {
      print(res.statusCode);
    }).catchError((err) {
      print(err);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(children: <Widget>[
            GestureDetector(
              onTap: _getImage,
              child: CircleAvatar(
                radius: 70,
                backgroundImage: _fimage == null ? null : FileImage(_fimage),
              ),
            ),
            TextFormField(
              controller: name,
              decoration: InputDecoration(
                icon: const Icon(Icons.person),
                labelText: 'Name',
                labelStyle: new TextStyle(
                  color: Colors.red[500],
                ),
              ),
              enabled: true,
            ),
            TextFormField(
              controller: phone,
              decoration: InputDecoration(
                labelText: 'Phone',
                icon: const Icon(Icons.phone),
                labelStyle: new TextStyle(
                  color: Colors.red[500],
                ),
              ),
              enabled: true,
            ),
            TextFormField(
              controller: address,
              decoration: InputDecoration(
                labelText: 'Address',
                labelStyle: new TextStyle(
                  color: Colors.red[500],
                ),
                icon: const Icon(Icons.location_city),
                suffixIcon: IconButton(
                  icon: Icon(Icons.pin_drop_rounded),
                  onPressed: () async => showMapDialog(context),
                ),
              ),
              enabled: true,
            ),
            SizedBox(
              height: 4,
            ),
            MaterialButton(
              child: Text("SAVE"),
              onPressed: () => startUpload(name.text, phone.text, address.text),
              color: Colors.red[500],
            )
          ]),
        ),
      ),
    );
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
                      address.text = "${addresses.first.addressLine}";
                      newLatLng.toString();
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
                                      setState(() {});
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

  void _onMapCreated(GoogleMapController controller) {
    myController = controller;
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

  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }
}
