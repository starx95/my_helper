import 'package:flutter/material.dart';
import 'package:my_helper/models/Trip.dart';
import 'date_view.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoder/geocoder.dart';

class NewJobLocationView extends StatefulWidget {
  final Trip job;
  NewJobLocationView({Key key, @required this.job}) : super(key: key);

  @override
  _NewJobLocationViewState createState() => _NewJobLocationViewState();
}

class _NewJobLocationViewState extends State<NewJobLocationView> {
  TextEditingController _titleController;
  GoogleMapController myController;
  double latitude, longitude;
  final Set<Marker> _markers = {};
  List<Marker> myMarker = [];
  final LatLng _center = const LatLng(45.521563, -122.677433);
  String _currentAddress;
  bool _isButtonDisabled = true;
  bool _isButtonMapDisabled = true;
  String title = "";

  @override
  void initState() {
    myMarker = [];
    myMarker.add(Marker(
      markerId: MarkerId(_center.toString()),
      position: _center,
    ));
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    _titleController = new TextEditingController();
    //_titleController.text = widget.job.title;
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffbe3e57),
        title: Text('Post New Job'),
        shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Enter job name"),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: TextField(
              controller: title == null ? _titleController : _titleController = TextEditingController(text: title),
              onChanged: (text) {
                title = text;
                this._handleTaps();
                if(title != ''){
                  _handleTaps();
                }

              },
              autofocus: false,
              decoration: InputDecoration(
                focusColor: const Color(0xffbe3e57),
                hoverColor: Colors.pink[800],
                fillColor: Colors.pink[800],
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: const Color(0xffbe3e57)),
                ),
              ),
            ),
          ),
          (_currentAddress != null)
              ? Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Center(
                      child: Text(
                    "Address: " + _currentAddress,
                    textAlign: TextAlign.center,
                  )))
              : Text(
                  "Address: ",
                  textAlign: TextAlign.center,
                ),
          FlatButton.icon(
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            icon: Icon(Icons.map), //icon image
            label: Text('Open Map'), //text to show in button
            textColor: Colors.white, //button text and icon color.
            color: const Color(0xffbe3e57), //button background color
            onPressed: () async {
              await showMapDialog(context);
            },
          ),
          FlatButton.icon(
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: const Color(0xffbe3e57),
            textColor: Colors.white,
            label: Text("Continue"),
            icon: Icon(Icons.arrow_forward),
            onPressed:  () {
              widget.job.title = _titleController.text;
              widget.job.address =  _currentAddress;
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NewJobDateView(job: widget.job)),
              );
            },
          )
        ],
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    myController = controller;
  }

  _handleTaps(){

      if(title != ''){
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
      print(addresses.first.addressLine);
      _currentAddress = "${addresses.first.addressLine}";
      setState(() {});
    } catch (e) {
      print(e);
    }
    newSetState(() {
      myMarker.clear();
      if(_currentAddress != "" && title != ""){
        _isButtonDisabled = false;
      }
      myMarker.add(Marker(markerId: MarkerId('New'), position: tappedPoint));
    });
  }
}
