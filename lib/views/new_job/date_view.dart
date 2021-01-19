import 'package:flutter/material.dart';
import 'package:my_helper/models/Trip.dart';
import 'wages.dart';

class NewJobDateView extends StatefulWidget {
  final Trip job;

  NewJobDateView({Key key, @required this.job}) : super(key: key);

  @override
  _NewJobDateViewState createState() => _NewJobDateViewState();
}

class _NewJobDateViewState extends State<NewJobDateView> {
  DateTime selectedDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now();

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  _selectEndDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedEndDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Select Start Date - ${widget.job.title}'),
          backgroundColor: Colors.red[500],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "${selectedDate.toLocal()}".split(' ')[0],
                    style: TextStyle(fontSize: 55, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  RaisedButton(
                    onPressed: () => _selectDate(context), // Refer step 3
                    child: Text(
                      'Select start date',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    color: Colors.red[500],
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "${selectedEndDate.toLocal()}".split(' ')[0],
                    style: TextStyle(fontSize: 55, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  RaisedButton(
                    onPressed: () => _selectEndDate(context), // Refer step 3
                    child: Text(
                      'Select end date',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    color: Colors.red[500],
                  ),
                ],
              ),
              RaisedButton(
                child: Text("Continue"),
                onPressed: () {
                  widget.job.startDate = selectedDate.toLocal();
                  widget.job.endDate = selectedEndDate.toLocal();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NewJobWagesView(job: widget.job)),
                  );
                },
              )
            ],
          ),
        ));
  }
}
