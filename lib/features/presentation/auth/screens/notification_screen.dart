import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/language_provider.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  final List<Map<String, dynamic>> notifications = const [
    {
      'title': 'New Assignment Added',
      'body': 'Mathematics assignment due on 25 Sep 2025.',
      'time': '2 mins ago',
      'icon': Icons.assignment,
      'color': '1565C0',
      'read': false,
    },
    {
      'title': 'Attendance Alert',
      'body': 'Your child was absent today. Please check.',
      'time': '1 hour ago',
      'icon': Icons.warning_amber,
      'color': 'C62828',
      'read': false,
    },
    {
      'title': 'Result Published',
      'body': 'Unit Test 2 results are now available.',
      'time': '3 hours ago',
      'icon': Icons.assessment,
      'color': '2E7D32',
      'read': true,
    },
    {
      'title': 'New Notice',
      'body': 'School will remain closed on 15th August.',
      'time': 'Yesterday',
      'icon': Icons.notifications,
      'color': 'EF6C00',
      'read': true,
    },
    {
      'title': 'Event Reminder',
      'body': 'Science Fair 2025 is scheduled for 20 Sep.',
      'time': '2 days ago',
      'icon': Icons.event,
      'color': '6A1B9A',
      'read': true,
    },
  ];

  Color _hexColor(String hex) =>
      Color(int.parse('FF$hex', radix: 16));

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final unread = notifications.where((n) => n['read'] == false).length;

    return Scaffold(
      appBar: AppBar(
        title: Text(languageProvider.texts['notifications'] ?? 'Notifications'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        actions: [
          if (unread > 0)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$unread New',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      backgroundColor: Colors.grey[100],
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notif = notifications[index];
          final color = _hexColor(notif['color'] as String);
          final isUnread = notif['read'] == false;

          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: isUnread ? Colors.white : Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: isUnread
                  ? Border.all(color: color.withOpacity(0.3))
                  : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isUnread ? 0.08 : 0.04),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 8),
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  notif['icon'] as IconData,
                  color: color,
                  size: 22,
                ),
              ),
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      notif['title'] as String,
                      style: TextStyle(
                        fontWeight: isUnread
                            ? FontWeight.bold
                            : FontWeight.normal,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  if (isUnread)
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    notif['body'] as String,
                    style: const TextStyle(
                        fontSize: 13, color: Colors.black54),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notif['time'] as String,
                    style: TextStyle(
                        fontSize: 11, color: Colors.grey[400]),
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