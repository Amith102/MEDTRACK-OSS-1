import 'package:flutter/material.dart';
import 'package:mobile_app/features/home/home_screen.dart';
import 'package:mobile_app/features/medications/medications_screen.dart';
import 'package:mobile_app/features/reminders/reminders_screen.dart';
import 'package:mobile_app/features/schedules/schedules_screen.dart';
import 'package:provider/provider.dart';
import '../../services/profile_provider.dart';
import '../../models/dependent.dart';
import '../../routes.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  static const String route = '/main';

  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    PatientsScreen(),
    MedicationsScreen(),
    SchedulesScreen(),
    RemindersScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Allow children to switch tabs if needed (e.g., from Home dashboard)
  void switchTab(int index) {
    if (index >= 0 && index < _screens.length) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();
    final activeProfile = profileProvider.activeProfile;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const CircleAvatar(
              radius: 16,
              child: Icon(Icons.person, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DropdownButtonHideUnderline(
                child: DropdownButton<Dependent>(
                  value: activeProfile,
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.black87),
                  onChanged: (Dependent? newValue) {
                    if (newValue != null) {
                      profileProvider.setActiveProfile(newValue.id);
                    }
                  },
                  items: profileProvider.profiles.map<DropdownMenuItem<Dependent>>((Dependent profile) {
                    return DropdownMenuItem<Dependent>(
                      value: profile,
                      child: Text(
                        '${profile.name} (${profile.relation})',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_2_rounded, size: 28),
            color: Colors.red[700],
            tooltip: 'Emergency Passport',
            onPressed: () {
              Navigator.pushNamed(context, Routes.emergencyPassport);
            },
          ),
          const SizedBox(width: 8),
        ],
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.black12,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onItemTapped,
          backgroundColor: Colors.white,
          elevation: 0,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.people_outlined),
              selectedIcon: Icon(Icons.people_rounded),
              label: 'Patients',
            ),
            NavigationDestination(
              icon: Icon(Icons.medication_outlined),
              selectedIcon: Icon(Icons.medication_rounded),
              label: 'Meds',
            ),
            NavigationDestination(
              icon: Icon(Icons.calendar_today_outlined),
              selectedIcon: Icon(Icons.calendar_today_rounded),
              label: 'Schedule',
            ),
            NavigationDestination(
              icon: Icon(Icons.notifications_outlined),
              selectedIcon: Icon(Icons.notifications_rounded),
              label: 'Reminders',
            ),
          ],
        ),
      ),
    );
  }
}
