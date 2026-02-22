import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/profile_provider.dart';
import '../../models/audit_log_entry.dart';

class ActivityFeedScreen extends StatelessWidget {
  const ActivityFeedScreen({Key? key}) : super(key: key);
  static const String route = '/activity_feed';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Caregiver Handoff Log'),
        elevation: 0,
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) {
          final activeProfile = profileProvider.activeProfile;

          if (activeProfile == null) {
            return const Center(child: Text("Select a profile to view activity."));
          }

          final feed = activeProfile.activityFeed.reversed.toList(); // Newest first

          if (feed.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history_toggle_off, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    "No Activity Yet",
                    style: TextStyle(fontSize: 18, color: Colors.grey[600], fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Medications administered by caregivers\nwill appear here.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: feed.length,
            itemBuilder: (context, index) {
              final log = feed[index];
              final isToday = log.timestamp.day == DateTime.now().day && 
                              log.timestamp.month == DateTime.now().month && 
                              log.timestamp.year == DateTime.now().year;

              final timeStr = "${log.timestamp.hour}:${log.timestamp.minute.toString().padLeft(2, '0')}";
              final dateStr = isToday ? "Today" : "${log.timestamp.month}/${log.timestamp.day}";

              return _buildTimelineItem(
                context: context,
                log: log,
                time: "$dateStr at $timeStr",
                isFirst: index == 0,
                isLast: index == feed.length - 1,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildTimelineItem({
    required BuildContext context,
    required AuditLogEntry log,
    required String time,
    required bool isFirst,
    required bool isLast,
  }) {
    IconData icon;
    Color color;

    switch (log.type) {
      case 'medication':
        icon = Icons.medication;
        color = Colors.green;
        break;
      case 'symptom':
        icon = Icons.sick;
        color = Colors.redAccent;
        break;
      default:
        icon = Icons.event_note;
        color = Colors.blue;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline graphic
        Column(
          children: [
            Container(
              width: 2,
              height: 20,
              color: isFirst ? Colors.transparent : Colors.grey[300],
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 2),
              ),
              child: Icon(icon, size: 16, color: color),
            ),
            Container(
              width: 2,
              height: isLast ? 0 : 50, // Line length to next item
              color: isLast ? Colors.transparent : Colors.grey[300],
            ),
          ],
        ),
        const SizedBox(width: 16),
        // Content Card
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 8),
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey[200]!),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      log.action,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.person, size: 14, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Text(
                          "By: ${log.caregiverName}",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[700],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
