import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class Emprestimo {
  final String emprestimoId;
  final String description;
  String valor;
  final String date;
  final String datePagamento;
  final String emprestarUserId;
  final String recebeUserId;
  String stausPagamento;

  Emprestimo({
    this.emprestimoId,
    this.description,
    this.valor,
    this.date,
    this.datePagamento,
    this.emprestarUserId,
    this.recebeUserId,
    this.stausPagamento,
  });

  factory Emprestimo.fromDocument(DocumentSnapshot document) {
    return Emprestimo.fromMap(document.data);
  }

  factory Emprestimo.fromJson(String str) =>
      Emprestimo.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Emprestimo.fromMap(Map<String, dynamic> json) => Emprestimo(
        emprestimoId: json["emprestimoId"] == null ? null : json["emprestimoId"],
        description: json["description"] == null ? null : json["description"],
        valor: json["valor"] == null ? null : json["valor"],
        date: json["date"] == null ? null : json["date"],
        datePagamento: json["datePagamento"] == null ? null : json["datePagamento"],
        emprestarUserId:json["emprestarUserId"] == null ? null : json["emprestarUserId"],
        recebeUserId:json["recebeUserId"] == null ? null : json["recebeUserId"],
        stausPagamento: json["stausPagamento"] == null ? null : json["stausPagamento"]
      );

  Map<String, dynamic> toMap() => {
    "emprestimoId": emprestimoId == null ? null : emprestimoId, 
        "description": description == null ? null : description, 
        "valor": valor == null ? null : valor,
        "date": date == null ? null : date,
         "datePagamento": datePagamento == null ? null : datePagamento,
        "emprestarUserId": emprestarUserId == null ? null : emprestarUserId,
         "recebeUserId": recebeUserId == null ? null : recebeUserId,
         "stausPagamento": stausPagamento == null ? null : stausPagamento,
      };
}