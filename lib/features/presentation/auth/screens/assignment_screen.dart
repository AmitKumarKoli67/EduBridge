import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/language_provider.dart';
import 'assignment_detail_screen.dart';

class AssignmentScreen extends StatefulWidget {
  const AssignmentScreen({super.key});

  @override
  _AssignmentScreenState createState() => _AssignmentScreenState();
}

class _AssignmentScreenState extends State<AssignmentScreen> {
  String selectedSubject = 'all';
  String selectedSort = 'due_date';
  String searchQuery = '';

  final List<Map<String, String>> assignments = [
    {
      'subject': 'Mathematics',
      'title': 'Math Homework - Algebra Worksheet',
      'dueDate': '2024-07-15',
      'status': 'Submitted',
      'assignedDate': '2024-07-10',
      'description':
          'Solve the algebra worksheet covering linear equations and quadratic expressions.',
      'attachedFile': 'Algebra_Worksheet.pdf',
      'submissionDate': '2024-07-14',
      'feedback': 'Good attempt! Work on quadratic equations.',
      'resubmission': 'No',
    },
    {
      'subject': 'Science',
      'title': 'Physics Lab Report',
      'dueDate': '2024-07-20',
      'status': 'Not Submitted',
      'assignedDate': '2024-07-12',
      'description': 'Write a lab report on Newton’s second law of motion.',
      'attachedFile': '',
      'submissionDate': '',
      'feedback': '',
      'resubmission': '',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    List<Map<String, String>> filteredAssignments =
        assignments.where((assignment) {
      bool matchesSubject = selectedSubject == 'all' ||
          assignment['subject']!.toLowerCase() == selectedSubject;
      bool matchesSearch = searchQuery.isEmpty ||
          assignment['title']!
              .toLowerCase()
              .contains(searchQuery.toLowerCase());
      return matchesSubject && matchesSearch;
    }).toList();

    filteredAssignments.sort((a, b) {
      if (selectedSort == 'due_date') {
        return a['dueDate']!.compareTo(b['dueDate']!);
      } else if (selectedSort == 'status') {
        return a['status']!.compareTo(b['status']!);
      }
      return 0;
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(languageProvider.texts['assignments'] ?? 'Assignments'),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Column(
        children: [
          _buildSearchBar(languageProvider),
          _buildFilters(languageProvider),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(
                      label:
                          Text(languageProvider.texts['subject'] ?? 'Subject')),
                  DataColumn(
                      label: Text(languageProvider.texts['title'] ?? 'Title')),
                  DataColumn(
                      label: Text(
                          languageProvider.texts['due_date'] ?? 'Due Date')),
                  DataColumn(
                      label:
                          Text(languageProvider.texts['status'] ?? 'Status')),
                  DataColumn(
                      label:
                          Text(languageProvider.texts['action'] ?? 'Action')),
                ],
                rows: filteredAssignments
                    .map((assignment) =>
                        _buildDataRow(assignment, context, languageProvider))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(LanguageProvider languageProvider) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onChanged: (value) {
          setState(() {
            searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: languageProvider.texts['search_assignments'] ??
              'Search Assignments by name',
          prefixIcon: const Icon(Icons.search),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildFilters(LanguageProvider languageProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          DropdownButton<String>(
            value: selectedSubject,
            onChanged: (value) {
              setState(() {
                selectedSubject = value!;
              });
            },
            items: [
              DropdownMenuItem(
                value: 'all',
                child: Text(languageProvider.texts['all'] ?? 'All'),
              ),
              DropdownMenuItem(
                value: 'mathematics',
                child: Text(
                    languageProvider.texts['mathematics'] ?? 'Mathematics'),
              ),
              DropdownMenuItem(
                value: 'science',
                child: Text(languageProvider.texts['science'] ?? 'Science'),
              ),
            ],
          ),
          const SizedBox(width: 10),
          DropdownButton<String>(
            value: selectedSort,
            onChanged: (value) {
              setState(() {
                selectedSort = value!;
              });
            },
            items: [
              DropdownMenuItem(
                value: 'due_date',
                child: Text(languageProvider.texts['due_date'] ?? 'Due Date'),
              ),
              DropdownMenuItem(
                value: 'status',
                child: Text(languageProvider.texts['status'] ?? 'Status'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  DataRow _buildDataRow(Map<String, String> assignment, BuildContext context,
      LanguageProvider languageProvider) {
    return DataRow(cells: [
      DataCell(Text(assignment['subject']!)),
      DataCell(Text(assignment['title']!)),
      DataCell(Text(assignment['dueDate']!)),
      DataCell(Text(
        assignment['status'] == 'Submitted'
            ? (languageProvider.texts['submitted'] ?? '✅ Submitted')
            : (languageProvider.texts['not_submitted'] ?? '❌ Not Submitted'),
      )),
      DataCell(
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    AssignmentDetailScreen(assignment: assignment),
              ),
            );
          },
          child: Text(languageProvider.texts['view_details'] ?? 'View Details'),
        ),
      ),
    ]);
  }
}
