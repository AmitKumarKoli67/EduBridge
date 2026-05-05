import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/language_provider.dart';

class NoticeBoardScreen extends StatelessWidget {
  const NoticeBoardScreen({super.key});

  final List<Map<String, String>> notices = const [
    {
      'title': 'School Closed on 15th August',
      'description': 'School will remain closed on Independence Day.',
      'date': '10 Aug 2025',
      'category': 'holiday',
    },
    {
      'title': 'Parent-Teacher Meeting',
      'description': 'PTM scheduled for all classes on 20th August at 10 AM.',
      'date': '8 Aug 2025',
      'category': 'meeting',
    },
    {
      'title': 'Annual Sports Day',
      'description': 'Annual sports day will be held on 25th August.',
      'date': '5 Aug 2025',
      'category': 'event',
    },
    {
      'title': 'Fee Submission Reminder',
      'description':
          'Last date for fee submission is 31st August. Avoid late fine.',
      'date': '1 Aug 2025',
      'category': 'finance',
    },
    {
      'title': 'Exam Schedule Released',
      'description': 'Unit test schedule for September has been uploaded.',
      'date': '28 Jul 2025',
      'category': 'exam',
    },
  ];

  Color _categoryColor(String category) {
    switch (category) {
      case 'holiday':
        return Colors.orange;
      case 'meeting':
        return Colors.blue;
      case 'event':
        return Colors.green;
      case 'finance':
        return Colors.red;
      case 'exam':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(languageProvider.texts['notice_board'] ?? 'Notice Board'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: notices.length,
        itemBuilder: (context, index) {
          final notice = notices[index];
          final categoryKey = notice['category']!;
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color:
                              _categoryColor(categoryKey).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          languageProvider.texts[categoryKey] ??
                              categoryKey.toUpperCase(),
                          style: TextStyle(
                            color: _categoryColor(categoryKey),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Text(
                        notice['date']!,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    notice['title']!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    notice['description']!,
                    style:
                        const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}