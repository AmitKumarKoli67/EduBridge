import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/language_provider.dart';

class TeachersScreen extends StatefulWidget {
  const TeachersScreen({super.key});

  @override
  State<TeachersScreen> createState() => _TeachersScreenState();
}

class _TeachersScreenState extends State<TeachersScreen> {
  String _searchQuery = '';

  final List<Map<String, String>> teachers = const [
    {
      'name': 'Mr. Rajesh Kumar',
      'subject': 'Mathematics',
      'email': 'rajesh.k@school.com',
      'experience': '12 Years',
      'qualification': 'M.Sc Mathematics',
      'avatar': 'RK',
      'color': '1565C0',
    },
    {
      'name': 'Ms. Priya Sharma',
      'subject': 'Science',
      'email': 'priya.s@school.com',
      'experience': '8 Years',
      'qualification': 'M.Sc Physics',
      'avatar': 'PS',
      'color': '2E7D32',
    },
    {
      'name': 'Mr. Amit Singh',
      'subject': 'History',
      'email': 'amit.s@school.com',
      'experience': '15 Years',
      'qualification': 'M.A History',
      'avatar': 'AS',
      'color': '6A1B9A',
    },
    {
      'name': 'Ms. Sneha Kapoor',
      'subject': 'English',
      'email': 'sneha.k@school.com',
      'experience': '6 Years',
      'qualification': 'M.A English Literature',
      'avatar': 'SK',
      'color': 'C62828',
    },
    {
      'name': 'Mr. Vikram Patel',
      'subject': 'Computer Science',
      'email': 'vikram.p@school.com',
      'experience': '9 Years',
      'qualification': 'B.Tech Computer Science',
      'avatar': 'VP',
      'color': 'EF6C00',
    },
  ];

  List<Map<String, String>> get _filtered => teachers
      .where((t) =>
          t['name']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          t['subject']!.toLowerCase().contains(_searchQuery.toLowerCase()))
      .toList();

  Color _hexColor(String hex) =>
      Color(int.parse('FF$hex', radix: 16));

  void _showTeacherDetail(
      BuildContext context, Map<String, String> teacher) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: _hexColor(teacher['color']!),
              child: Text(
                teacher['avatar']!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              teacher['name']!,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              teacher['subject']!,
              style: TextStyle(
                color: _hexColor(teacher['color']!),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            _detailRow(Icons.school, teacher['qualification']!),
            _detailRow(Icons.work, '${teacher['experience']} Experience'),
            _detailRow(Icons.email, teacher['email']!),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.chat_bubble_outline),
                label: const Text('Send Message'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(languageProvider.texts['teachers'] ?? 'Teachers'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [

          // ── Search Bar ────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: 'Search by name or subject...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // ── Teacher Count ─────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  '${_filtered.length} Teachers Found',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // ── Teacher Cards ─────────────────────────────
          Expanded(
            child: _filtered.isEmpty
                ? const Center(child: Text('No teachers found'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filtered.length,
                    itemBuilder: (context, index) {
                      final teacher = _filtered[index];
                      final color = _hexColor(teacher['color']!);
                      return GestureDetector(
                        onTap: () =>
                            _showTeacherDetail(context, teacher),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
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

                              // Avatar
                              CircleAvatar(
                                radius: 28,
                                backgroundColor: color,
                                child: Text(
                                  teacher['avatar']!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),

                              // Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      teacher['name']!,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: color.withOpacity(0.12),
                                        borderRadius:
                                            BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        teacher['subject']!,
                                        style: TextStyle(
                                          color: color,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${teacher['experience']} • ${teacher['qualification']}',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Arrow
                              const Icon(Icons.chevron_right,
                                  color: Colors.grey),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}