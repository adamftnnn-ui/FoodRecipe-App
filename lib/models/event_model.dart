import 'package:flutter/material.dart';

class EventModel {
  final String title;
  final String subtitle;
  final String image;
  final int colorValue;

  const EventModel({
    required this.title,
    required this.subtitle,
    required this.image,
    required this.colorValue,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      title: (json['title'] as String?) ?? '',
      subtitle: (json['subtitle'] as String?) ?? '',
      image: (json['image'] as String?) ?? '',
      colorValue: json['colorValue'] is int
          ? json['colorValue'] as int
          : int.tryParse(json['colorValue']?.toString() ?? '') ?? 0xFFFFF8E1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'image': image,
      'colorValue': colorValue,
    };
  }

  Color get color => Color(colorValue);
}
