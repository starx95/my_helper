class CUser {
  String phone, address;

  CUser(this.address, this.phone);

  Map<String, dynamic> toJson() => {
    'phone': phone,
    'address': address
  };
}