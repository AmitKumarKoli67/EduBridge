import 'package:flutter/material.dart';

class AssignmentDetailScreen extends StatefulWidget {
  final Map<String, String> assignment;

  const AssignmentDetailScreen({super.key, required this.assignment});

  @override
  State<AssignmentDetailScreen> createState() => _AssignmentDetailScreenState();
}

class _AssignmentDetailScreenState extends State<AssignmentDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Assignment Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Assignment Overview 📝',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Title: ${widget.assignment['title']}'),
            Text('Subject: ${widget.assignment['subject']}'),
            Text('Assigned Date: ${widget.assignment['assignedDate']}'),
            Text('Due Date: ${widget.assignment['dueDate']}'),
            Text(
                'Status: ${widget.assignment['status'] == 'Submitted' ? '✅ Submitted' : '❌ Not Submitted'}'),
            const SizedBox(height: 16),
            const Text('Assignment Description 📄',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(widget.assignment['description']!),
            const SizedBox(height: 16),
            const Text('Attached Files 📎',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            widget.assignment['attachedFile']!.isNotEmpty
                ? TextButton(
                    onPressed: () {},
                    child: Text(
                        '[Download: ${widget.assignment['attachedFile']}]'),
                  )
                : const Text('No files attached'),
            const SizedBox(height: 16),
            if (widget.assignment['submissionDate']!.isNotEmpty) ...[
              const Text('Submission Details 📤',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text('Submission Date: ${widget.assignment['submissionDate']}'),
              const SizedBox(height: 16),
            ],
            if (widget.assignment['feedback']!.isNotEmpty) ...[
              const Text("Teacher’s Feedback & Grade 🎯",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text('Feedback: ${widget.assignment['feedback']}'),
              Text(
                  'Re-submission Required? ${widget.assignment['resubmission']}'),
            ],
          ],
        ),
      ),
    );
  }
}
