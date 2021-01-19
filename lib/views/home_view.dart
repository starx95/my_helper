import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:my_helper/main.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  dynamic data;
  String title = "";
  bool count = true;
  int no = 0;
  List<Placemark> placemark;
  List<Placemark> placemarkR;

  var db;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection("Jobs").snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return Center(
                  child: Text("Loading Please wait..."),
                );

              return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot job = snapshot.data.docs[index];
                    return SingleChildScrollView(
                            child: _getRegisteredAddress() == _getAddress(job["address"])
                        ? null
                        : ListTile(
                            leading: Image.network(
                                "https://eitrawmaterials.eu/wp-content/uploads/2016/09/person-icon.png"),
                            title: Text(job["title"]),
                            subtitle: Text(job["address"]),
                          ));
                  });
            }),
      ),
    ));
  }

  _getAddress(address) async {
    placemark = await Geolocator().placemarkFromAddress(address);
    print(placemark[0].postalCode);
    return placemark[0].postalCode;
  }

  _getRegisteredAddress() async {
    List<Placemark> placemarkR =
        await Geolocator().placemarkFromAddress(LoginScreen.address);
        print(placemarkR[0].postalCode);
    return placemarkR[0].postalCode;
  }
}
