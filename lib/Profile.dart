import 'dart:typed_data';
import 'package:my_helper/Home.dart';
import 'package:my_helper/views/update_pass.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
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
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_helper/views/safety.dart';
import 'package:my_helper/views/contact.dart';
import 'package:my_helper/views/about.dart';
import 'package:my_helper/views/language.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool _rememberMe = false;
  String photoBase64;
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController address = TextEditingController();
  Future<File> file;
  String status = '';
  String base64Image;
  File tmpFile;
  bool isSwitched = false;
  String fileName;
  CollectionReference jobs;
  String errMessage = 'Error Uploading Image';
  File _fimage;
  final _pick = ImagePicker();
  var _addcontroller = TextEditingController();
  static Uint8List imageBytess;
  Position _currentPosition;
  LatLng _center = const LatLng(6.457510, 100.505455);
  double latitude, longitude;
  String _currentAddress;
  String _address = "";
  List<Marker> myMarker = [];
  GoogleMapController myController;
  bool monVal = false;
  String title = "";
  Image image;
  bool _isButtonDisabled = true;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  final db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    jobs = _firestore.collection('Jobs');
    name.text = LoginScreen.name;
    phone.text = LoginScreen.email;
    address.text = LoginScreen.address;
    imageBytess = base64.decode(LoginScreen.image);
  }

  Future _getImage() async {
    var pickedfile = await _pick.getImage(source: ImageSource.gallery);
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

  setStatus(String message) {
    setState(() {
      status = message;
    });
  }

  startUpload(names, emails, addresses) async {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    List<int> imageBytes = _fimage.readAsBytesSync();
    photoBase64 = base64Encode(imageBytes);
    print(photoBase64 + " test");
    db.collection("Users").doc(LoginScreen.email).update(
        {"name": names, "address": addresses, "image": photoBase64}).then((_) {
      Toast.show("Profile Updated", context);
    });
  }

  void _onLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("name: " + prefs.getString('name'));
    prefs.setString('name', null);
    prefs.setString('email', null);
    LoginScreen.name = null;
    LoginScreen.email = null;
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: CustomScrollView(
        physics: NeverScrollableScrollPhysics(),
        slivers: <Widget>[
          SliverPersistentHeader(
            pinned: true,
            floating: true,
            delegate: CustomSliverDelegate(
              expandedHeight: 205,
            ),
          ),
          SliverFillRemaining(
              child: Column(children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 40, right: 180),
                  child: GestureDetector(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(color: Colors.black),
                        children: [
                          WidgetSpan(
                            child: Icon(
                              Icons.notifications,
                              size: 20,
                              color: Colors.orange[900],
                            ),
                          ),
                          TextSpan(
                            text: " Notification",
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(),
                    child: Container(
                      child: Switch(
                        value: isSwitched,
                        onChanged: (value) {
                          setState(() {
                            isSwitched = value;
                            print(isSwitched);
                          });
                        },
                        activeTrackColor: const Color(0xffbe3e57),
                        activeColor: Colors.white,
                      ),
                    ))
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 40, right: 170),
                  child: GestureDetector(
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.black),
                          children: [
                            WidgetSpan(
                              child: Icon(
                                Icons.language_outlined,
                                size: 20,
                                color: Colors.orange[900],
                              ),
                            ),
                            TextSpan(
                              text: " Language",
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Language()));
                      }),
                ),
                Padding(
                    padding: EdgeInsets.only(),
                    child: Expanded(
                        child: GestureDetector(
                      child: Row(children: [
                        Text('English'),
                        IconButton(
                          icon: Icon(Icons.arrow_forward_ios),
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Language())),
                        )
                      ]),
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Language())),
                    ))
                )],
            ),
            Row(children: [
              Padding(
                padding: EdgeInsets.only(top: 15, left: 40, right: 170),
                child: GestureDetector(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.black),
                      children: [
                        WidgetSpan(
                          child: Icon(
                            Icons.lock,
                            size: 20,
                            color: Colors.orange[900],
                          ),
                        ),
                        TextSpan(
                          text: " Update Password",
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => UpdatePass()));
                  },
                ),
              ),
            ]),
            Padding(
              padding: EdgeInsets.only(top: 25, left: 40, right: 285),
              child: GestureDetector(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.black),
                    children: [
                      WidgetSpan(
                        child: Icon(
                          Icons.verified_user_outlined,
                          size: 20,
                          color: Colors.orange[900],
                        ),
                      ),
                      TextSpan(
                        text: " Safety",
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Safety()));
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 25, left: 40, right: 255),
              child: GestureDetector(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.black),
                    children: [
                      WidgetSpan(
                        child: Icon(
                          Icons.contact_mail_outlined,
                          size: 20,
                          color: Colors.orange[900],
                        ),
                      ),
                      TextSpan(
                        text: " Contact Us",
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Contact()));
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 25, left: 40, right: 270),
              child: GestureDetector(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.black),
                    children: [
                      WidgetSpan(
                        child: Icon(
                          Icons.info_outline,
                          size: 20,
                          color: Colors.orange[900],
                        ),
                      ),
                      TextSpan(
                        text: " About Us",
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => About()));
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 25, left: 40, right: 282),
              child: GestureDetector(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.black),
                    children: [
                      WidgetSpan(
                        child: Icon(
                          Icons.exit_to_app,
                          size: 20,
                          color: Colors.orange[900],
                        ),
                      ),
                      TextSpan(
                        text: " Logout",
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  _onLogout();
                },
              ),
            )
          ]))
        ],
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

class CustomSliverDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final bool hideTitleWhenExpanded;

  CustomSliverDelegate({
    @required this.expandedHeight,
    this.hideTitleWhenExpanded = true,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final appBarSize = expandedHeight - shrinkOffset;
    final cardTopPosition = expandedHeight / 2 - shrinkOffset;
    final proportion = 2 - (expandedHeight / appBarSize);
    final percent = proportion < 0 || proportion > 1 ? 0.0 : proportion;
    return SizedBox(
      height: 300,
      child: Stack(
        children: [
          SizedBox(
            height: 150,
            child: AppBar(
              backgroundColor: const Color(0xffbe3e57),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(25),
                ),
              ),
              elevation: 0.0,
              title: Center(child: Text("Profile")),
            ),
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            top: 50,
            bottom: 0.0,
            child: Opacity(
              opacity: percent,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20 * percent),
                child: Container(
                    child: Card(
                  elevation: 10.0,
                  child: Center(
                    child: ListTile(
                      title: Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: _ProfileState()._getImage,
                              child: CircleAvatar(
                                radius: 70,
                                backgroundImage:
                                    MemoryImage(_ProfileState.imageBytess),
                              ),
                            ),
                            Flexible(
                                child: Padding(
                              padding: EdgeInsets.only(top: 2),
                              child: Text(
                                LoginScreen.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            )),
                            Flexible(
                                child: Padding(
                              padding: EdgeInsets.only(top: 2),
                              child: Text(
                                LoginScreen.email,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            )),
                            Flexible(
                                child: Padding(
                              padding: EdgeInsets.only(top: 2),
                              child: Text(
                                LoginScreen.phone,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            )),
                          ],
                        ),
                      ),
                    ),
                  ),
                )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => expandedHeight + expandedHeight / 2;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
