import 'package:cloud_firestore/cloud_firestore.dart';

class Data {
  final DocumentReference reference;
  String name;
  int vote;

  Data.data(this.reference,
      [this.name,
        this.vote]) {
    // Set these rather than using the default value because Firebase returns
    // null if the value is not specified.
    this.name ??= 'Frank';
    this.vote ??= 7;
  }

  factory Data.from(DocumentSnapshot document) => Data.data(
      document.reference,
      //document.data['name'],
      //document.data['vote']
      );

  void save() {
    reference.set(toMap());
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'vote': vote,
    };
  }
}