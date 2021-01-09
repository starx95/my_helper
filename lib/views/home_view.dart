import 'package:flutter/material.dart';
import '../models/Trip.dart';
import 'package:intl/intl.dart';

class HomeView extends StatelessWidget {
  final List<Trip> tripsList =[
    Trip("New York", DateTime.now(), DateTime.now(), 200.00, "Car"),
    Trip("Boston", DateTime.now(), DateTime.now(), 400.00, "Plane"),
    Trip("Washington", DateTime.now(), DateTime.now(), 300.00, "Bus"),
    Trip("Austin", DateTime.now(), DateTime.now(), 250.00, "Car"),
    Trip("Scranton", DateTime.now(), DateTime.now(), 350.00, "Car"),
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      child: new ListView.builder(
        itemCount: tripsList.length,
        itemBuilder: (BuildContext context, int index) => buildTripCard(context, index)
      )
    );
  }

  Widget buildTripCard(BuildContext context, int index) {
    final trip = tripsList[index];
    return new Container(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Padding(
              padding: const EdgeInsets.only(top:8.0, bottom:4.0),
              child: Row(
                children: <Widget>[
                  Text(trip.title, style: new TextStyle(fontSize: 30.0)),
                  Spacer(),
                ]
              ),),
              Padding(
              padding: const EdgeInsets.only(top:4.0, bottom:80.0),
              child: Row(
                children: <Widget>[
                  Text("${DateFormat('dd/MM/yyyy').format(trip.startDate).toString()} - ${DateFormat('dd/MM/yyyy').format(trip.endDate).toString()}"),
                  Spacer(),
                ]
              ),),
              Padding(
              padding: const EdgeInsets.only(top:8.0, bottom:8.0),
              child:Row(children: [
                    Text("RM${trip.budget.toStringAsFixed(2)}", style: new TextStyle(fontSize: 35.0)),
                    Spacer(),
                    Text(trip.travelType),
                  ],))
                  
                  
                ],),
        ))
              );
        
      
    
  }
}