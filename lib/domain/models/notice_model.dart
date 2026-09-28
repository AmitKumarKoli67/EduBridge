import 'package:cloud_firestore/cloud_firestore.dart';

class NoticeModel {
  final String id;
  final String title;
  final String description;
  final String date;
  final String category; // 'holiday', 'meeting', 'event', 'finance', 'exam'
  final String? author;
  final DateTime? createdAt;

  NoticeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.category,
    this.author,
    this.createdAt,
  });

  factory NoticeModel.fromMap(Map<String, dynamic> map, String id) {
    return NoticeModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      date: map['date'] ?? '',
      category: map['category'] ?? 'event',
      author: map['author'],
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'date': date,
      'category': category,
      'author': author,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
    };
  }
}
