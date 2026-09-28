import 'package:cloud_firestore/cloud_firestore.dart';

class AssignmentModel {
  final String id;
  final String title;
  final String subject;
  final String description;
  final String dueDate;
  final String assignedDate;
  final String status; // 'Submitted' or 'Not Submitted'
  final String? attachedFile;
  final String? feedback;
  final String? teacherId;

  AssignmentModel({
    required this.id,
    required this.title,
    required this.subject,
    required this.description,
    required this.dueDate,
    required this.assignedDate,
    this.status = 'Not Submitted',
    this.attachedFile,
    this.feedback,
    this.teacherId,
  });

  factory AssignmentModel.fromMap(Map<String, dynamic> map, String id) {
    return AssignmentModel(
      id: id,
      title: map['title'] ?? '',
      subject: map['subject'] ?? '',
      description: map['description'] ?? '',
      dueDate: map['dueDate'] ?? '',
      assignedDate: map['assignedDate'] ?? '',
      status: map['status'] ?? 'Not Submitted',
      attachedFile: map['attachedFile'],
      feedback: map['feedback'],
      teacherId: map['teacherId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subject': subject,
      'description': description,
      'dueDate': dueDate,
      'assignedDate': assignedDate,
      'status': status,
      'attachedFile': attachedFile,
      'feedback': feedback,
      'teacherId': teacherId,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
