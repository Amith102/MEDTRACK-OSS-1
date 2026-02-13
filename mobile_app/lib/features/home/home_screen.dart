import 'package:flutter/material.dart';
import 'package:mobile_app/routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static String route = '/';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<_NavItem> _navItems = [
    _NavItem(
      icon: Icons.home_rounded,
      label: 'Home',
      route: Routes.home,
    ),
    _NavItem(
      icon: Icons.people_rounded,
      label: 'Patients',
      route: Routes.patients,
    ),
    _NavItem(
      icon: Icons.medication_rounded,
      label: 'Medications',
      route: Routes.medications,
    ),
    _NavItem(
      icon: Icons.schedule_rounded,
      label: 'Schedules',
      route: Routes.schedules,
    ),
    _NavItem(
      icon: Icons.notifications_rounded,
      label: 'Reminders',
      route: Routes.reminders,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MedTrack'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0066CC), Color(0xFF00B4D8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: const Icon(
                            Icons.health_and_safety_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome to MedTrack',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Your medication companion',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'An open-source medication tracking system designed to help you manage medicines, schedules, and adherence in a simple and reliable way.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(230, 255, 255, 255),
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Quick Actions Grid
              const Text(
                'What you can do here:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _ActionCard(
                    icon: Icons.person_search_rounded,
                    title: 'Patient Profiles',
                    description: 'View and manage',
                    color: const Color(0xFF0066CC),
                    onTap: () {
                      Navigator.pushNamed(context, Routes.patients);
                    },
                  ),
                  _ActionCard(
                    icon: Icons.medication_rounded,
                    title: 'Medications',
                    description: 'Track prescribed',
                    color: const Color(0xFF00B4D8),
                    onTap: () {
                      Navigator.pushNamed(context, Routes.medications);
                    },
                  ),
                  _ActionCard(
                    icon: Icons.calendar_today_rounded,
                    title: 'Schedules',
                    description: 'Monitor timings',
                    color: const Color(0xFFFF6B6B),
                    onTap: () {
                      Navigator.pushNamed(context, Routes.schedules);
                    },
                  ),
                  _ActionCard(
                    icon: Icons.trending_up_rounded,
                    title: 'Adherence',
                    description: 'Review history',
                    color: const Color(0xFF4CAF50),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Adherence feature coming soon!')),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Features Section
              const Text(
                'Key Features',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              _FeatureItem(
                icon: Icons.notifications_active_rounded,
                title: 'Smart Reminders',
                description: 'Get timely medication reminders',
              ),
              const SizedBox(height: 12),
              _FeatureItem(
                icon: Icons.security_rounded,
                title: 'Secure & Reliable',
                description: 'Your data is protected with encryption',
              ),
              const SizedBox(height: 12),
              _FeatureItem(
                icon: Icons.cloud_sync_rounded,
                title: 'Cloud Sync',
                description: 'Seamlessly sync across devices',
              ),
              const SizedBox(height: 12),
              _FeatureItem(
                icon: Icons.family_restroom_rounded,
                title: 'Caregiver Support',
                description: 'Share updates with your caregivers',
              ),
              const SizedBox(height: 28),

              // Info Banner
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF0066CC).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: const Icon(
                        Icons.info_rounded,
                        color: Color(0xFF0066CC),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Connected to Backend',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'This app connects to MedTrack APIs',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Colors.blue.shade100),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(context, Routes.patients, (route) => route.isFirst);
                  },
                  icon: const Icon(Icons.people),
                  tooltip: 'View Patients',
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(context, Routes.medications, (route) => route.isFirst);
                  },
                  icon: const Icon(Icons.medication_liquid),
                  tooltip: 'View Medications',
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(context, Routes.schedules, (route) => route.isFirst);
                  },
                  icon: const Icon(Icons.schedule),
                  tooltip: 'View Schedules',
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(context, Routes.reminders, (route) => route.isFirst);
                  },
                  icon: const Icon(Icons.alarm),
                  tooltip: 'View Reminders',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  final String route;

  _NavItem({
    required this.icon,
    required this.label,
    required this.route,
  });
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                color.withOpacity(0.1),
                color.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(10),
                child: Icon(
                  icon,
                  color: color,
                  size: 28,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF0066CC).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(10),
            child: Icon(
              icon,
              color: const Color(0xFF0066CC),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
