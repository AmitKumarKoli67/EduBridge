import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/language_provider.dart';
import '../../../../domain/models/assignment_model.dart';
import '../../../../services/assignment_service.dart';
import 'assignment_detail_screen.dart';

class AssignmentScreen extends StatefulWidget {
  const AssignmentScreen({super.key});

  @override
  State<AssignmentScreen> createState() => _AssignmentScreenState();
}

class _AssignmentScreenState extends State<AssignmentScreen> {
  final AssignmentService _assignmentService = AssignmentService();
  String selectedSubject = 'all';
  String selectedSort = 'due_date';
  String searchQuery = '';

  void _showAddAssignmentDialog(
      BuildContext context, AuthProvider authProvider) {
    final titleController = TextEditingController();
    final subjectController = TextEditingController();
    final descController = TextEditingController();
    final dueDateController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Create New Assignment'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: subjectController,
                decoration: const InputDecoration(
                  labelText: 'Subject (e.g. Mathematics)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: dueDateController,
                decoration: InputDecoration(
                  labelText: 'Due Date',
                  hintText: 'YYYY-MM-DD',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate:
                            DateTime.now().add(const Duration(days: 3)),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) {
                        dueDateController.text =
                            DateFormat('yyyy-MM-dd').format(picked);
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: descController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description / Instructions',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final title = titleController.text.trim();
              final subject = subjectController.text.trim();
              final desc = descController.text.trim();
              final dueDate = dueDateController.text.trim();
              if (title.isEmpty || subject.isEmpty || dueDate.isEmpty) return;

              final assignment = AssignmentModel(
                id: '',
                title: title,
                subject: subject,
                description: desc,
                dueDate: dueDate,
                assignedDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
                teacherId: authProvider.user?.uid,
              );

              await _assignmentService.addAssignment(assignment);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Publish'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final isTeacher = (authProvider.role ?? '').toLowerCase() == 'teacher';

    return Scaffold(
      appBar: AppBar(
        title: Text(languageProvider.texts['assignments'] ?? 'Assignments'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      floatingActionButton: isTeacher
          ? FloatingActionButton.extended(
              onPressed: () => _showAddAssignmentDialog(context, authProvider),
              icon: const Icon(Icons.add),
              label: const Text('New Assignment'),
            )
          : null,
      body: StreamBuilder<List<AssignmentModel>>(
        stream: _assignmentService.getAssignments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error loading assignments: ${snapshot.error}'),
            );
          }

          final allAssignments = snapshot.data ?? [];

          List<AssignmentModel> filteredAssignments =
              allAssignments.where((assignment) {
            bool matchesSubject = selectedSubject == 'all' ||
                assignment.subject.toLowerCase() ==
                    selectedSubject.toLowerCase();
            bool matchesSearch = searchQuery.isEmpty ||
                assignment.title
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) ||
                assignment.subject
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase());
            return matchesSubject && matchesSearch;
          }).toList();

          filteredAssignments.sort((a, b) {
            if (selectedSort == 'due_date') {
              return a.dueDate.compareTo(b.dueDate);
            } else if (selectedSort == 'status') {
              return a.status.compareTo(b.status);
            }
            return 0;
          });

          return Column(
            children: [
              _buildSearchBar(languageProvider),
              _buildFilters(languageProvider, allAssignments),
              Expanded(
                child: filteredAssignments.isEmpty
                    ? Center(
                        child: Text(
                          'No assignments found',
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 16),
                        ),
                      )
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SingleChildScrollView(
                          child: DataTable(
                            columns: [
                              DataColumn(
                                  label: Text(
                                      languageProvider.texts['subject'] ??
                                          'Subject')),
                              DataColumn(
                                  label: Text(
                                      languageProvider.texts['title'] ??
                                          'Title')),
                              DataColumn(
                                  label: Text(
                                      languageProvider.texts['due_date'] ??
                                          'Due Date')),
                              DataColumn(
                                  label: Text(
                                      languageProvider.texts['status'] ??
                                          'Status')),
                              DataColumn(
                                  label: Text(
                                      languageProvider.texts['action'] ??
                                          'Action')),
                            ],
                            rows: filteredAssignments
                                .map((assignment) => _buildDataRow(
                                    assignment, context, languageProvider))
                                .toList(),
                          ),
                        ),
                      ),
              ),
            ],
          );
        },
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
              'Search Assignments by name or subject',
          prefixIcon: const Icon(Icons.search),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildFilters(
      LanguageProvider languageProvider, List<AssignmentModel> assignments) {
    final subjects = {'all', ...assignments.map((a) => a.subject.toLowerCase())};

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          DropdownButton<String>(
            value: subjects.contains(selectedSubject) ? selectedSubject : 'all',
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  selectedSubject = value;
                });
              }
            },
            items: subjects.map((subj) {
              return DropdownMenuItem(
                value: subj,
                child: Text(subj == 'all'
                    ? (languageProvider.texts['all'] ?? 'All')
                    : subj.toUpperCase()),
              );
            }).toList(),
          ),
          const SizedBox(width: 10),
          DropdownButton<String>(
            value: selectedSort,
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  selectedSort = value;
                });
              }
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

  DataRow _buildDataRow(AssignmentModel assignment, BuildContext context,
      LanguageProvider languageProvider) {
    return DataRow(cells: [
      DataCell(Text(assignment.subject)),
      DataCell(Text(assignment.title)),
      DataCell(Text(assignment.dueDate)),
      DataCell(Text(
        assignment.status == 'Submitted'
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
