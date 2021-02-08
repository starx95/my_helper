import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:my_helper/models/Trip.dart';
import 'date_view.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoder/geocoder.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class NewJobLocationView extends StatefulWidget {
  final Trip job;
  NewJobLocationView({Key key, @required this.job}) : super(key: key);

  @override
  _NewJobLocationViewState createState() => _NewJobLocationViewState();
}

class _NewJobLocationViewState extends State<NewJobLocationView> {
  int _value = 1;
  FocusNode myFocusNode = new FocusNode();
  TextEditingController _titleController;
  TextEditingController _locationController = new TextEditingController();
  GoogleMapController myController;
  double latitude, longitude;
  final Set<Marker> _markers = {};
  List<Marker> myMarker = [];
  final LatLng _center = const LatLng(45.521563, -122.677433);
  String _currentAddress;
  bool _isButtonDisabled = true;
  bool _isButtonMapDisabled = true;
  String title = "";
  final _pick = ImagePicker();
  File _fimage;
  String photoBase64;
  String fileName;
  Uint8List imageBytess;

  @override
  void initState() {
    myMarker = [];
    myMarker.add(Marker(
      markerId: MarkerId(_center.toString()),
      position: _center,
    ));
    super.initState();
  }

  Future<void> _optionsDialogBox() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: new Row(
                      children: [
                        Column(children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.camera),
                            color: Colors.red,
                            iconSize: 48,
                            tooltip: 'Open Camera',
                            onPressed: () async {
                              var picture = await _pick.getImage(
                                  source: ImageSource.camera);
                              setState(() {
                                if (picture != null) {
                                  _fimage = File(picture.path);
                                  imageBytess = _fimage.readAsBytesSync();
                                  photoBase64 = base64Encode(imageBytess);
                                  fileName = picture.path.split('/').last;
                                  Navigator.pop(context);
                                } else {
                                  print('No image selected.');
                                }
                              });
                            },
                          ),
                          Text("Open Camera")
                        ]),
                        Padding(
                          padding: EdgeInsets.all(30.0),
                        ),
                        Column(children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.image),
                            color: Colors.red,
                            iconSize: 48,
                            tooltip: 'Open Gallery',
                            onPressed: () async {
                              final pickedfile = await _pick.getImage(
                                  source: ImageSource.gallery);
                              setState(() {
                                if (pickedfile != null) {
                                  _fimage = File(pickedfile.path);
                                  imageBytess = _fimage.readAsBytesSync();
                                  photoBase64 = base64Encode(imageBytess);
                                  fileName = pickedfile.path.split('/').last;
                                  Navigator.pop(context);
                                } else {
                                  print('No image selected.');
                                }
                              });
                            },
                          ),
                          Text("Open Gallery")
                        ])
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> showMapDialog(BuildContext context) async {
    double width = MediaQuery.of(context).size.width;
    return await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, newSetState) {
            return AlertDialog(
                insetPadding: EdgeInsets.all(15),
                title: Center(
                  child: Text("Please mark your location"),
                ),
                content: Container(
                  width: width,
                  child: GoogleMap(
                    markers: myMarker.toSet(),
                    onTap: (newLatLng) async {
                      _handleTap(newLatLng, newSetState);
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

  Future<File> imageFile;
  final imagePicker = ImagePicker();

  pickImageFromGallery(ImageSource source) {
    setState(() async {
      imageFile = (await imagePicker.getImage(source: source)) as Future<File>;
    });
  }

  Widget showImage() {
    return Padding(
        padding: EdgeInsets.only(top: 10),
        child: GestureDetector(
            onTap: () {
              _optionsDialogBox();
            },
            child: Container(
              width: MediaQuery.of(context).size.width - 10,
              height: MediaQuery.of(context).size.height / 3 - 10,
              decoration: BoxDecoration(
                  color: Colors.grey,
                  image: DecorationImage(
                    fit: BoxFit.scaleDown,
                    image: imageBytess == null? AssetImage('assets/icons/camera.png') : MemoryImage(imageBytess),
                  )),
            )));

    AlertDialog(
        content: Row(
      children: [
        Column(children: <Widget>[
          IconButton(
            icon: Icon(Icons.camera),
            color: Colors.red,
            iconSize: 48,
            tooltip: 'Open Camera',
            onPressed: () async {
              var picture = await _pick.getImage(source: ImageSource.camera);
              setState(() {
                if (picture != null) {
                  _fimage = File(picture.path);
                  imageBytess = _fimage.readAsBytesSync();
                  photoBase64 = base64Encode(imageBytess);
                  fileName = picture.path.split('/').last;
                  Navigator.pop(context);
                } else {
                  print('No image selected.');
                }
              });
            },
          ),
          Text("Open Camera")
        ]),
        Padding(
          padding: EdgeInsets.all(30.0),
        ),
        Column(children: <Widget>[
          IconButton(
            icon: Icon(Icons.image),
            color: Colors.red,
            iconSize: 48,
            tooltip: 'Open Gallery',
            onPressed: () async {
              final pickedfile =
                  await _pick.getImage(source: ImageSource.gallery);
              setState(() {
                if (pickedfile != null) {
                  _fimage = File(pickedfile.path);
                  imageBytess = _fimage.readAsBytesSync();
                  photoBase64 = base64Encode(imageBytess);
                  fileName = pickedfile.path.split('/').last;
                  Navigator.pop(context);
                } else {
                  print('No image selected.');
                }
              });
            },
          ),
          Text("Open Gallery")
        ])
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    _titleController = new TextEditingController();
    //_titleController.text = widget.job.title;

    return SingleChildScrollView(
        child: Container(
            height: MediaQuery.of(context).size.height,
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                backgroundColor: const Color(0xffbe3e57),
                title: Center(child: Text('Post New Job')),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(30),
                  ),
                ),
              ),
              body: Column(
                children: <Widget>[
                  GestureDetector(
                      onTap: () {
                      },
                      child: showImage()),
                  Padding(
                      padding: EdgeInsets.only(left: 10, top: 10),
                      child: Row(children: [Text("Job Type")])),
                  Container(
                    padding: EdgeInsets.only(left: 10.0, right: 20.0),
                    width: MediaQuery.of(context).size.width - 40.0,
                    child: Container(
                      padding: EdgeInsets.only(left: 0.0, right: 0.0),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                            isExpanded: true,
                            value: _value,
                            items: [
                              DropdownMenuItem(
                                child: Text("Beauty"),
                                value: 1,
                              ),
                              DropdownMenuItem(
                                child: Text("Catering"),
                                value: 2,
                              ),
                              DropdownMenuItem(child: Text("Dobi"), value: 3),
                              DropdownMenuItem(
                                  child: Text("Tailoring"), value: 4),
                              DropdownMenuItem(
                                  child: Text("Plumbing"), value: 5),
                              DropdownMenuItem(
                                  child: Text("Homecare"), value: 6),
                              DropdownMenuItem(child: Text("Mover"), value: 7),
                              DropdownMenuItem(child: Text("Crafts"), value: 8),
                              DropdownMenuItem(
                                  child: Text("Massage"), value: 9),
                              DropdownMenuItem(
                                  child: Text("Street Food"), value: 10),
                              DropdownMenuItem(
                                  child: Text("Runner"), value: 11),
                              DropdownMenuItem(
                                  child: Text("Event Manager"), value: 12),
                              DropdownMenuItem(
                                  child: Text("Graphic Designer"), value: 13),
                              DropdownMenuItem(
                                  child: Text("Research Assistant"), value: 14),
                              DropdownMenuItem(
                                  child: Text("Others"), value: 15),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _value = value;
                              });
                            }),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: new Theme(
                                data: new ThemeData(
                                  primaryColor: Color(0xffbe3e57),
                                  primaryColorDark: Color(0xffbe3e57),
                                  indicatorColor: Color(0xffbe3e57),
                                  cursorColor: Color(0xffbe3e57),
                                ),
                                child: new  TextFormField(
                      controller: title == null
                          ? _titleController
                          : _titleController =
                              TextEditingController(text: title),
                      onChanged: (text) {
                        title = text;
                        this._handleTaps();
                        if (title != '') {
                          _handleTaps();
                        }
                      },
                      autofocus: false,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        icon: Icon(Icons.description_outlined),
                        focusColor: const Color(0xffbe3e57),
                        hoverColor: Colors.pink[800],
                        fillColor: Colors.pink[800],
                      ),
                    )),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10),
                      child: Row(children: [
                        Container(
                            width: MediaQuery.of(context).size.width / 2 - 12,
                            child: new Theme(
                                data: new ThemeData(
                                  primaryColor: Color(0xffbe3e57),
                                  primaryColorDark: Color(0xffbe3e57),
                                  indicatorColor: Color(0xffbe3e57),
                                  cursorColor: Color(0xffbe3e57),
                                ),
                                child: new TextFormField(
                              controller: title == null
                                  ? _titleController
                                  : _titleController =
                                      TextEditingController(text: title),
                              onChanged: (text) {
                                title = text;
                                this._handleTaps();
                                if (title != '') {
                                  _handleTaps();
                                }
                              },
                              autofocus: false,
                              decoration: InputDecoration(
                                labelText: 'Payment (RM)',
                                icon: Icon(Icons.money_outlined),
                                focusColor: const Color(0xffbe3e57),
                                hoverColor: Colors.pink[800],
                                fillColor: Colors.pink[800],
                              ),
                            ))),
                        SizedBox(
                          width: 2,
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width / 2 - 10,
                            child: new Theme(
                                data: new ThemeData(
                                  primaryColor: Color(0xffbe3e57),
                                  primaryColorDark: Color(0xffbe3e57),
                                  cursorColor: Color(0xffbe3e57),
                                  indicatorColor: Color(0xffbe3e57),
                                  
                                ),
                                child: new TextFormField(
                                  focusNode: myFocusNode,
                                  controller: title == null
                                      ? _titleController
                                      : _titleController =
                                          TextEditingController(text: title),
                                  onChanged: (text) {
                                    title = text;
                                    this._handleTaps();
                                    if (title != '') {
                                      _handleTaps();
                                    }
                                  },
                                  autofocus: false,
                                  decoration: InputDecoration(
                                    
                                    labelText: 'Duration (Minutes)',
                                    icon: Icon(Icons.lock_clock),
                                  ),
                                ))),
                      ])),
                  Padding(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: new Theme(
                                data: new ThemeData(
                                  primaryColor: Color(0xffbe3e57),
                                  primaryColorDark: Color(0xffbe3e57),
                                  indicatorColor: Color(0xffbe3e57),
                                  cursorColor: Color(0xffbe3e57),
                                ),
                                child: new TextFormField(
                        controller: _locationController,
                        onChanged: (text) {
                          print(_locationController.text);
                          title = text;
                          this._handleTaps();
                          if (title != '') {
                            _handleTaps();
                          }
                        },
                        autofocus: false,
                        decoration: InputDecoration(
                          labelText: 'Location',
                          icon: Icon(Icons.location_on_outlined),
                          focusColor: const Color(0xffbe3e57),
                          hoverColor: Colors.pink[800],
                          fillColor: Colors.pink[800],
                          suffixIcon: IconButton(
                            icon: Icon(Icons.pin_drop_rounded),
                            onPressed: () async => showMapDialog(context),
                          ),
                        ),
                      ))),
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 10.0, right: 10),
                    child: ButtonTheme(
                      minWidth: MediaQuery.of(context).size.width,
                      child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          color: const Color(0xffbe3e57),
                          onPressed: () {
                            widget.job.title = _titleController.text;
                            widget.job.address = _currentAddress;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      NewJobDateView(job: widget.job)),
                            );
                          },
                          child: Text(
                            "CREATE",
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                  ),
                ],
              ),
            )));
  }

  void _onMapCreated(GoogleMapController controller) {
    myController = controller;
  }

  _handleTaps() {
    if (title != '') {
      _isButtonMapDisabled = false;
    }
  }

  _handleTap(tappedPoint, newSetState) async {
    latitude = tappedPoint.latitude;
    longitude = tappedPoint.longitude;
    final coordinates = new Coordinates(latitude, longitude);

    try {
      var addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      _currentAddress = "${addresses.first.addressLine}";
      setState(() {
        _locationController.text = _currentAddress;
      });
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
}
