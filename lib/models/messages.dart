// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Messages {
  final String message;
  final String senderId;

  Messages(this.message, this.senderId);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'senderId': senderId,
    };
  }

  factory Messages.fromMap(Map<String, dynamic> map) {
    return Messages(
      map['message'] as String,
      map['senderId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Messages.fromJson(String source) => Messages.fromMap(json.decode(source) as Map<String, dynamic>);
}
