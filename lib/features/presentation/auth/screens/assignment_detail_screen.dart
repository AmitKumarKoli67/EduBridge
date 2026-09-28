import 'package:flutter/material.dart';
import '../../../../domain/models/assignment_model.dart';

class AssignmentDetailScreen extends StatefulWidget {
  final AssignmentModel assignment;

  const AssignmentDetailScreen({super.key, required this.assignment});

  @override
  State<AssignmentDetailScreen> createState() => _AssignmentDetailScreenState();
}

class _AssignmentDetailScreenState extends State<AssignmentDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final assignment = widget.assignment;

    return Scaffold(
      appBar: AppBar(title: const Text('Assignment Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Assignment Overview 📝',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Title: ${assignment.title}',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('Subject: ${assignment.subject}'),
                    const SizedBox(height: 4),
                    Text('Assigned Date: ${assignment.assignedDate}'),
                    const SizedBox(height: 4),
                    Text('Due Date: ${assignment.dueDate}'),
                    const SizedBox(height: 4),
                    Text(
                      'Status: ${assignment.status == 'Submitted' ? '✅ Submitted' : '❌ Not Submitted'}',
                      style: TextStyle(
                        color: assignment.status == 'Submitted'
                            ? Colors.green
                            : Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Assignment Description 📄',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              assignment.description.isNotEmpty
                  ? assignment.description
                  : 'No description provided.',
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 16),
            if (assignment.feedback != null &&
                assignment.feedback!.isNotEmpty) ...[
              const Text(
                'Teacher’s Feedback & Grade 🎯',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('Feedback: ${assignment.feedback!}'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
