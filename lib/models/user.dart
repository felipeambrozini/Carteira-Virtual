import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String userId;
  String name;
  String date;
  String email;
  String cpf;
  String phone;
  String saldo;
 

  User({
    this.userId,
    this.name,
    this.date,
    this.email,
    this.cpf,
    this.phone,
    this.saldo,
    
  });

   String getInitials() {
    if (name != null)
      return name.toUpperCase()[0];
    else
      return '?';
  }

  factory User.fromDocument(DocumentSnapshot document) {
    return User.fromMap(document.data);
  }

  factory User.fromJson(String str) => User.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory User.fromMap(Map<String, dynamic> json) => User(
        userId: json["userID"] == null ? null : json["userID"],
        name: json["name"] == null ? null : json["name"],
        date: json["date"] == null ? null : json["date"],
        email: json["email"] == null ? null : json["email"],
        cpf:  json["cpf"] == null ? null : json["cpf"],
        phone: json["phone"] == null ? null : json["phone"],
        saldo: json["saldo"] == null ? null : json["saldo"],
      );

  Map<String, dynamic> toMap() => {
        "userID": userId == null ? null : userId,
        "name": name == null ? null : name,
        "date": date == null ? null : date,
        "email": email == null ? null : email,
        "cpf":  cpf == null ? null : cpf,
        "phone": phone == null ? null : phone,
        "saldo": saldo == null ? null : saldo,
      };
}