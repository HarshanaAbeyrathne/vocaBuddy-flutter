import 'package:flutter/material.dart';

class DoctorHomeScreen extends StatelessWidget {
  const DoctorHomeScreen({super.key});

  void _go(BuildContext context, String route) {
    Navigator.pushNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CircleAvatar(
                      radius: 22,
                      backgroundColor: Color(0xFFFFF3E0),
                      child: Icon(Icons.person, color: Color(0xFFFF9800)),
                    ),
                    Container(
                      width: 34,
                      height: 34,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFF3E0),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.notifications_none_rounded,
                        color: Color(0xFF59316B),
                        size: 22,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                const Text(
                  "Good Afternoon,",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF3B1F47),
                  ),
                ),
                const Text(
                  "Doctor!",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF3B1F47),
                  ),
                ),

                const SizedBox(height: 28),

                // Assign Activities
                _card(
                  onTap: () => _go(context, '/assign-activities'),
                  bg: const Color(0xFFFFF3E8),
                  title: "Assign Activities",
                  subtitle: "Let's open up to the things that\nmatter the most",
                  action: "Assign Now  📅",
                  icon: Icons.person_outline,
                ),

                const SizedBox(height: 18),

                // View Reports
                _card(
                  onTap: () => _go(context, '/view-reports'),
                  bg: const Color(0xFF34A853),
                  title: "View Reports",
                  subtitle: "Get back chat access and\nsession credits",
                  action: "View Now",
                  icon: Icons.description_rounded,
                  dark: true,
                ),

                const SizedBox(height: 18),

                // Attempt Activity
                _card(
                  onTap: () => _go(context, '/attempt-session'),
                  bg: const Color(0xFFFFEED6),
                  title: "Attempt Activity",
                  subtitle:
                  "Complete today’s assigned\nactivities at your own pace",
                  action: "Start Now  ▶",
                  icon: Icons.play_arrow_rounded,
                ),

                const SizedBox(height: 18),

                // Manage Recordings
                _card(
                  onTap: () => _go(context, '/manage-recordings'),
                  bg: const Color(0xFFE3F2FD),
                  title: "Manage Voice Recordings",
                  subtitle:
                  "View and organize session\nvoice recordings",
                  action: "Open Folder  🎧",
                  icon: Icons.folder_rounded,
                  blue: true,
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 🔹 Card widget (unchanged structure, reusable)
  Widget _card({
    required VoidCallback onTap,
    required Color bg,
    required String title,
    required String subtitle,
    required String action,
    required IconData icon,
    bool dark = false,
    bool blue = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: dark
                          ? Colors.white
                          : blue
                          ? const Color(0xFF1A237E)
                          : const Color(0xFF5A4332),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.5,
                      color: dark
                          ? Colors.white
                          : blue
                          ? const Color(0xFF3949AB)
                          : const Color(0xFF8A6E5A),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    action,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: dark
                          ? Colors.white
                          : blue
                          ? const Color(0xFF1E88E5)
                          : const Color(0xFFFF6D00),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 74,
              height: 74,
              decoration: BoxDecoration(
                color: dark || blue
                    ? Colors.white.withOpacity(0.2)
                    : const Color(0xFFFFA726),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}