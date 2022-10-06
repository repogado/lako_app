// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class NotificationData {
  final String title;
  final String subTitle;

  NotificationData(
    this.title,
    this.subTitle,
  );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'subTitle': subTitle,
    };
  }

  factory NotificationData.fromMap(Map<String, dynamic> map) {
    return NotificationData(
      map['title'] as String,
      map['subTitle'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationData.fromJson(String source) =>
      NotificationData.fromMap(json.decode(source) as Map<String, dynamic>);
}
