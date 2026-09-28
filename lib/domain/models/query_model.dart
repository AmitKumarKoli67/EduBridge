import 'package:cloud_firestore/cloud_firestore.dart';

class QueryModel {
  final String id;
  final String userId;
  final String userName;
  final String category; // 'Academic', 'Attendance', 'Fee', 'Behaviour', 'Other'
  final String question;
  final String status; // 'Pending' or 'Answered'
  final String reply;
  final DateTime? createdAt;
  final DateTime? answeredAt;

  QueryModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.category,
    required this.question,
    this.status = 'Pending',
    this.reply = '',
    this.createdAt,
    this.answeredAt,
  });

  factory QueryModel.fromMap(Map<String, dynamic> map, String id) {
    return QueryModel(
      id: id,
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      category: map['category'] ?? 'Academic',
      question: map['question'] ?? '',
      status: map['status'] ?? 'Pending',
      reply: map['reply'] ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
      answeredAt: (map['answeredAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'category': category,
      'question': question,
      'status': status,
      'reply': reply,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
      'answeredAt': answeredAt != null ? Timestamp.fromDate(answeredAt!) : null,
    };
  }
}
