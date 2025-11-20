import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocabuddy/pages/ActivityStart/activity_start_screen.dart';

// ===================================================================
// 1. CONSTANTS, THEMES, AND DATA MODELS
//    (STRICTLY using the new monochromatic orange/gray colors)
// ===================================================================

// --- Colors & Themes ---
// New Color Palette: 0xFFFF9500, 0xFFFFAD33, 0xFF718096, 0xFFFFE8CC
const Color _kPrimaryTheme = Color(0xFF718096); // Slate Gray (Was Deep Purple)
const Color _kAccentColor = Color(0xFFFF9500); // Main Action Orange
const Color _kSecondaryHighlight = Color(0xFFFFAD33); // Secondary Orange (Was Green)
const Color _kBackgroundColor = Colors.white; // Requested: White Background
const Color _kCardColor = Colors.white; // Requested: White Card Base
const Color _kShadowColor = Color(0xFF718096); // Using Slate Gray for shadows (Was Light Gray)
const Color _kTextColorDark = Color(0xFF718096); // Slate Gray for Main Text (Was Dark Navy)
const Color _kTextColorMuted = Color(0xFF718096); // Slate Gray for Muted Text (Was Muted Gray)

// --- Data Models ---

/// Model for an activity item in the 'Today's Plan' section.
class _SessionActivity {
  final String title;
  final String description;
  final bool isPrimary;
  _SessionActivity(this.title, this.description, {this.isPrimary = false});
}

/// Model to hold core dashboard statistics.
class _ActivityData {
  final String childName;
  final int totalSessions;
  final int avgAccuracy;

  _ActivityData({
    required this.childName,
    required this.totalSessions,
    required this.avgAccuracy,
  });

  static _ActivityData dummy = _ActivityData(
    childName: 'චමල්',
    totalSessions: 24,
    avgAccuracy: 81,
  );
}

// ===================================================================
// 2. MAIN STATEFUL WIDGET
// ===================================================================

class ActivitySummaryScreen extends StatefulWidget {
  const ActivitySummaryScreen({Key? key}) : super(key: key);

  @override
  State<ActivitySummaryScreen> createState() => _ActivitySummaryScreenState();
}

class _ActivitySummaryScreenState extends State<ActivitySummaryScreen> {
  bool _isPreviousExpanded = true;
  bool _isTodayExpanded = true;

  final _ActivityData _data = _ActivityData.dummy;

  final List<_SessionActivity> _todayActivities = [
    _SessionActivity(
      'ප්‍රධාන වචන පුහුණු කිරීම',
      '“ක, ග, ත, ද, ප, බ” වැනි සරල ශබ්ද මත අවධානය යොමු කර පැහැදිලි උච්චාරණය 5–8 වාරයකින් පුහුණු කරන්න.',
      isPrimary: true,
    ),
    _SessionActivity(
      'දෘශ්‍ය පද හඳුනාගැනීම',
      'රූප/අයිකන 3–5 පෙන්වා, බබා කියන වචන සටහන් කර නිවැරදි බව සටහන් කරන්න.',
    ),
    _SessionActivity(
      'නැවත බලන්න වචන',
      'පසුගිය සැසි වල වැරදි වූ වචනවලින් 5ක් තෝරා අද යළි පුහුණු කරන්න.',
    ),
    _SessionActivity(
      'කෙටි වාක්‍ය භාවිතය',
      'සරල වාක්‍ය 2–3ක් හරහා සම්බන්ධ වචන හා නාද සංගතය පරීක්ෂා කරන්න.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Apply Poppins globally for the whole screen
    final textTheme = GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme);

    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: textTheme,
        scaffoldBackgroundColor: _kBackgroundColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: _kBackgroundColor,
          elevation: 0,
        ),
      ),
      child: Scaffold(
        backgroundColor: _kBackgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _TopBar(),
                const SizedBox(height: 32),
                _HeaderTitle(childName: _data.childName),
                const SizedBox(height: 30),
                _StatsOverview(data: _data),
                const SizedBox(height: 30),

                // Previous Summary Card
                _CollapsibleCard(
                  isExpanded: _isPreviousExpanded,
                  onToggle: () => setState(() => _isPreviousExpanded = !_isPreviousExpanded),
                  themeColor: _kPrimaryTheme, // Slate Gray
                  icon: Icons.history_edu_rounded,
                  title: 'පසුගිය ක්‍රියාකාරකම් සාරාංශය',
                  subtitle: 'පසුගිය සැසි වල ප්‍රගතිය හා වෘත්තීය සටහන් බලන්න.',
                  child: const _PreviousSummaryContent(),
                ),
                const SizedBox(height: 18),

                // Today's Plan Card
                _CollapsibleCard(
                  isExpanded: _isTodayExpanded,
                  onToggle: () => setState(() => _isTodayExpanded = !_isTodayExpanded),
                  themeColor: _kSecondaryHighlight, // Orange Highlight
                  icon: Icons.lightbulb_outline_rounded,
                  title: 'අද කළ යුතු නිර්දේශිත ක්‍රියාකාරකම්',
                  subtitle: 'අද සෙෂන් සඳහා වෘත්තීය පුහුණු නිර්දේශ.',
                  child: _TodayPlanContent(activities: _todayActivities),
                ),
                const SizedBox(height: 40),

                _PrimaryButton(
                  label: 'ආරම්භ කරන්න',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AntLearningActivity()),
                    );
                  },
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ===================================================================
// 3. WIDGET COMPONENTS
// ===================================================================

/// Creates a decorative icon with a subtle neumorphic effect.
class _StyledIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color shadowColor;

  const _StyledIcon({
    required this.icon,
    required this.color,
    this.shadowColor = const Color(0xFF718096), // Use Slate Gray
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: _kCardColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: shadowColor.withOpacity(0.3), // Darker shadow based on Gray
            offset: const Offset(4, 4),
            blurRadius: 10,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.5),
            offset: const Offset(-4, -4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Icon(icon, size: 26, color: color),
    );
  }
}

/// The top row with profile and notifications.
class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _StyledIcon(
          icon: Icons.person_outline_rounded,
          color: _kPrimaryTheme, // Slate Gray
        ),
        _StyledIcon(
          icon: Icons.notifications_none_rounded,
          color: _kTextColorMuted, // Slate Gray
        ),
      ],
    );
  }
}

/// The main greeting and description block.
class _HeaderTitle extends StatelessWidget {
  final String childName;
  const _HeaderTitle({required this.childName});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Child Activity Summary',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: _kTextColorDark, // Slate Gray
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '$childName ගේ කථන පුහුණු ප්‍රගතිය මෙහිදී නිරීක්ෂණය කළ හැක.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: _kTextColorMuted.withOpacity(0.8), // Muted Slate Gray
            height: 1.5,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

/// A highly visual circular progress indicator for accuracy.
class _RadialProgressIndicator extends StatelessWidget {
  final int value; // 0-100
  final double size;
  final Color color;

  const _RadialProgressIndicator({
    required this.value,
    this.size = 120,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _kCardColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: _kShadowColor.withOpacity(0.3), // Slate Gray Shadow
            offset: const Offset(5, 5),
            blurRadius: 15,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.8),
            offset: const Offset(-5, -5),
            blurRadius: 15,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: value / 100),
              duration: const Duration(milliseconds: 1000),
              builder: (context, progress, child) {
                return CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 8,
                  backgroundColor: color.withOpacity(0.15),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                );
              },
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$value%',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: color,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'සාමාන්‍ය',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: _kTextColorMuted, // Slate Gray
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// The card showing key stats (Radial + Counter).
class _StatsOverview extends StatelessWidget {
  final _ActivityData data;
  const _StatsOverview({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _kCardColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: _kShadowColor.withOpacity(0.3), // Slate Gray Shadow
            offset: const Offset(0, 10),
            blurRadius: 30,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Radial Progress (Main Focus)
          _RadialProgressIndicator(
            value: data.avgAccuracy,
            color: _kPrimaryTheme, // Slate Gray
            size: 130,
          ),
          const SizedBox(width: 20),

          // Total Sessions Counter
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'මුළු සැසි',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: _kTextColorMuted, // Slate Gray
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${data.totalSessions}',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                    color: _kAccentColor, // Action Orange
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'ප්‍රගතිය දිනෙන් දින ඉහළ යයි!',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: _kSecondaryHighlight, // Secondary Orange
                    fontWeight: FontWeight.bold,
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

/// Reusable and animated Collapsible Card for sections.
class _CollapsibleCard extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onToggle;
  final Color themeColor;
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget child;

  const _CollapsibleCard({
    required this.isExpanded,
    required this.onToggle,
    required this.themeColor,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = Color(0xFFFFE8CC); // Lightest Orange/Cream
    final shadowColor = _kPrimaryTheme.withOpacity(0.2);

    return Container(
      decoration: BoxDecoration(
        color: _kCardColor,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: _kShadowColor.withOpacity(0.3), // Slate Gray Shadow
            offset: const Offset(0, 5),
            blurRadius: 15,
          ),
        ],
      ),
      child: Column(
        children: [
          // Header (Always visible)
          InkWell(
            borderRadius: BorderRadius.circular(26),
            onTap: onToggle,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: isExpanded
                    ? const BorderRadius.vertical(top: Radius.circular(26))
                    : BorderRadius.circular(26),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _kCardColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: themeColor.withOpacity(0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Icon(icon, size: 22, color: themeColor),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: _kTextColorDark, // Slate Gray
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: _kTextColorMuted.withOpacity(0.8), // Muted Slate Gray
                            height: 1.4,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Animated arrow icon
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: themeColor,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Content (Animated expansion)
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: Container(
              constraints: isExpanded
                  ? null
                  : const BoxConstraints(maxHeight: 0.0),
              width: double.infinity,
              padding: EdgeInsets.only(
                  left: 20, right: 20, top: 18, bottom: isExpanded ? 24 : 0),
              decoration: BoxDecoration(
                color: _kCardColor,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(26),
                ),
              ),
              child: isExpanded
                  ? child
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget for a Key-Value pair row.
class _KVRow extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _KVRow(this.label, this.value, {required this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: _kTextColorMuted.withOpacity(0.8), // Muted Slate Gray
                fontSize: 12,
              ),
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}

/// Content for the Previous Summary Card.
class _PreviousSummaryContent extends StatelessWidget {
  const _PreviousSummaryContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _KVRow('අවසාන සැසියේ වචන සංඛ්‍යාව', '28', valueColor: _kAccentColor),
        _KVRow('නිවැරදි උච්චාරණ අනුපාතය', '82%', valueColor: _kAccentColor),
        _KVRow('නැවත පුහුණු කළ යුතු වචන', '5', valueColor: _kAccentColor),
        const SizedBox(height: 16),
        Text(
          'වෘත්තීය සටහන (Therapist Note)',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: _kTextColorDark, // Slate Gray
          ),
        ),
        const Divider(height: 16, thickness: 1, color: _kShadowColor), // Slate Gray Divider
        Text(
          '“ර”, “ස”, “ශ” සම්බන්ධ නාද සඳහා තවදුරටත් මෘදු මගපෙන්වීම් අවශ්‍යයි. '
              'සෙනෙහසින් යුත් පුහුණු පරිසරයක් තුළ පියවරෙන් පියවර ඉදිරියට යන්න.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontSize: 12,
            color: _kTextColorMuted.withOpacity(0.8), // Muted Slate Gray
            height: 1.6,
          ),
        ),
      ],
    );
  }
}

/// Widget for a single To-Do Item.
class _TodoItem extends StatelessWidget {
  final _SessionActivity activity;

  const _TodoItem({required this.activity});

  @override
  Widget build(BuildContext context) {
    // FIX: Define local variables within the build method scope
    // Swapping Green (kSecondaryColor) for Secondary Orange (kSecondaryHighlight)
    // Swapping Shadow Color for Slate Gray
    final borderColor = activity.isPrimary ? _kSecondaryHighlight : _kShadowColor;
    final iconColor = activity.isPrimary ? _kSecondaryHighlight : _kTextColorMuted.withOpacity(0.5);
    final bg = activity.isPrimary ? const Color(0xFFFFE8CC).withOpacity(0.8) : Colors.transparent;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: activity.isPrimary ? 1.5 : 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            activity.isPrimary
                ? Icons.star_rounded // Using star for primary importance
                : Icons.radio_button_unchecked_rounded,
            size: 20,
            color: iconColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: _kTextColorDark, // Slate Gray
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  activity.description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 11,
                    color: _kTextColorMuted.withOpacity(0.8), // Muted Slate Gray
                    height: 1.5,
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

/// Content for the Today's Plan Card.
class _TodayPlanContent extends StatelessWidget {
  final List<_SessionActivity> activities;
  const _TodayPlanContent({required this.activities});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: activities.map((activity) => _TodoItem(activity: activity)).toList(),
    );
  }
}

/// Primary Call-to-Action button with elevation.
class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _PrimaryButton({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Ink(
        decoration: BoxDecoration(
          color: _kAccentColor, // Action Orange
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: _kAccentColor.withOpacity(0.5),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 10),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}