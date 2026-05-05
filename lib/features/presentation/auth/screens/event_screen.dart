import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/language_provider.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  final List<Map<String, dynamic>> events = const [
    {
      'title': 'Science Fair 2025',
      'date': '20 Sep 2025',
      'day': '20',
      'month': 'SEP',
      'location': 'School Auditorium',
      'description': 'Showcasing the best science projects from all grades.',
      'category': 'Academic',
      'color': '1565C0',
      'icon': Icons.science,
    },
    {
      'title': 'Annual Day Rehearsals',
      'date': '15 Sep 2025',
      'day': '15',
      'month': 'SEP',
      'location': 'Playground',
      'description':
          'Mandatory rehearsals for students participating in cultural events.',
      'category': 'Cultural',
      'color': '6A1B9A',
      'icon': Icons.celebration,
    },
    {
      'title': 'Career Counseling Workshop',
      'date': '10 Sep 2025',
      'day': '10',
      'month': 'SEP',
      'location': 'Conference Hall',
      'description':
          'Expert session for high school students on career paths.',
      'category': 'Workshop',
      'color': '2E7D32',
      'icon': Icons.work,
    },
    {
      'title': 'Parent-Teacher Meeting',
      'date': '5 Sep 2025',
      'day': '05',
      'month': 'SEP',
      'location': 'Classrooms',
      'description':
          'Quarterly PTM to discuss student progress with parents.',
      'category': 'Meeting',
      'color': 'EF6C00',
      'icon': Icons.people,
    },
  ];

  Color _hexColor(String hex) =>
      Color(int.parse('FF$hex', radix: 16));

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(languageProvider.texts['events'] ?? 'Events'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Upcoming Banner ───────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Text('📅',
                      style: TextStyle(fontSize: 48)),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Upcoming Events',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${events.length} events this month',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'All Events',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // ── Event Cards ───────────────────────────────
            ...events.map((event) {
              final color = _hexColor(event['color'] as String);
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [

                    // ── Date Block ──────────────────────
                    Container(
                      width: 70,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            event['day'] as String,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            event['month'] as String,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ── Event Info ──────────────────────
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            // Category tag
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                event['category'] as String,
                                style: TextStyle(
                                  color: color,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),

                            // Title
                            Text(
                              event['title'] as String,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 4),

                            // Location
                            Row(
                              children: [
                                const Icon(Icons.location_on,
                                    size: 13, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(
                                  event['location'] as String,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),

                            // Description
                            Text(
                              event['description'] as String,
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}