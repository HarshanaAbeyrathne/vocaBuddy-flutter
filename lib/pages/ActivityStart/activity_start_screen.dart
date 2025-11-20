import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocabuddy/pages/ActivityStart/activity_start_screen.dart';
import 'package:vocabuddy/pages/doctor_home_screen.dart';


// ===================================================================
// 1. CONSTANTS, THEMES, AND DATA MODELS
// ===================================================================

// --- Colors & Themes ---
const Color _kPrimaryTheme = Color(0xFF718096); // Slate Gray
const Color _kAccentColor = Color(0xFFFF9500); // Main Action Orange
const Color _kSecondaryHighlight = Color(0xFFFFAD33); // Secondary Orange
const Color _kBackgroundColor = Color(0xFFE3F2FD); // Soft Blue Background for kids
const Color _kCardColor = Colors.white; // White Card Base
const Color _kShadowColor = Color(0xFF718096); // Slate Gray for shadows
const Color _kTextColorDark = Color(0xFF718096); // Slate Gray for Main Text
const Color _kTextColorMuted = Color(0xFF718096); // Slate Gray for Muted Text
const Color _kSuccessColor = Color(0xFF4ADE80); // Green for audio button
const Color _kMicColor = Color(0xFF2C7A7B); // Teal for mic button

// ===================================================================
// 2. MAIN STATEFUL WIDGET
// ===================================================================

class AntLearningActivity extends StatefulWidget {
  const AntLearningActivity({Key? key}) : super(key: key);

  @override
  State<AntLearningActivity> createState() => _AntLearningActivityState();
}

class _AntLearningActivityState extends State<AntLearningActivity>
    with TickerProviderStateMixin {
  bool _showCorrectFeedback = false;
  bool _showTryAgainFeedback = false;
  late AnimationController _bounceController;
  late AnimationController _pulseController;
  late AnimationController _antController;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _antController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _pulseController.dispose();
    _antController.dispose();
    super.dispose();
  }

  void _handleAudioTap() {
    setState(() {
      _showCorrectFeedback = false;
      _showTryAgainFeedback = false;
    });
    // TODO: Implement audio playback
    print("🔊 Playing audio: ANT");
  }

  void _handleMicTap() {
    // Simulate random feedback for demo
    final isCorrect = DateTime.now().millisecond % 2 == 0;

    setState(() {
      _showCorrectFeedback = isCorrect;
      _showTryAgainFeedback = !isCorrect;
    });

    if (isCorrect) {
      _bounceController.forward(from: 0);
    }

    // Auto-hide feedback after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showCorrectFeedback = false;
          _showTryAgainFeedback = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme);

    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: textTheme,
        scaffoldBackgroundColor: _kBackgroundColor,
      ),
      child: Scaffold(
        backgroundColor: _kBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              // Playful Header
              _buildPlayfulHeader(),

              // Main Content
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),

                        // Animated Ant Card
                        _buildAntCard(),
                        const SizedBox(height: 24),

                        // Word Label with fun styling
                        _buildWordLabel(),
                        const SizedBox(height: 32),

                        // Action Buttons Row
                        _buildActionButtons(),
                        const SizedBox(height: 32),

                        // Feedback Messages
                        _buildFeedbackSection(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlayfulHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: _kCardColor,
        boxShadow: [
          BoxShadow(
            color: _kShadowColor.withOpacity(0.15),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _PlayfulIconButton(
            icon: Icons.arrow_back_rounded,
            color: _kAccentColor,
            backgroundColor: const Color(0xFFFFE8CC), //back icon
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AntLearningActivity()),
              );
            },
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFE8CC), //lets play baby
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.stars_rounded, color: _kAccentColor, size: 18),
                const SizedBox(width: 6),
                Text(
                  'Let"s Start Baby !',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: _kTextColorDark,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          _PlayfulIconButton(
            icon: Icons.home_rounded,
            color: _kSecondaryHighlight,
            backgroundColor: const Color(0xFFFFE8CC), //home icon
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DoctorHomeScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAntCard() {
    return AnimatedBuilder(
      animation: _antController,
      builder: (context, child) {
        final float = Tween<double>(begin: -5, end: 5)
            .transform(Curves.easeInOut.transform(_antController.value));
        return Transform.translate(
          offset: Offset(0, float),
          child: child,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _kCardColor,
              const Color(0xFFFFF8F0), //box shadow color (ant photo)
            ],
          ),
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: _kShadowColor.withOpacity(0.2),
              offset: const Offset(0, 10),
              blurRadius: 30,
            ),
            BoxShadow(
              color: _kAccentColor.withOpacity(0.1),
              offset: const Offset(0, -2),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          children: [
            // Decorative stars
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStar(16, _kSecondaryHighlight),
                _buildStar(12, _kAccentColor),
                _buildStar(14, _kSuccessColor),
              ],
            ),
            const SizedBox(height: 12),

            // Ant Illustration Container
            _buildAntIllustration(),
            const SizedBox(height: 12),

            // Decorative dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                    (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: index == 1
                        ? _kAccentColor
                        : _kShadowColor.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStar(double size, Color color) {
    return Icon(
      Icons.star_rounded,
      size: size,
      color: color.withOpacity(0.6),
    );
  }

  Widget _buildAntIllustration() {
    return Container(
      width: 180,
      height: 180,
      decoration: BoxDecoration(
        color: Colors.amber,
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFFFFE8CC), // round shadow color
          width: 4,
        ),
        boxShadow: [
          BoxShadow(
            color: _kAccentColor.withOpacity(0.2),
            offset: const Offset(0, 6),
            blurRadius: 20,
          ),
        ],
      ),
      child: ClipOval(
        child: Container(
          color: const Color(0xFFE3F2FD),
          child: Center(
            child: Image.asset(
              'assets/images/ant.png',
              width: 140,
              height: 140,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return _buildAntPlaceholder();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAntPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Container(
        //   padding: const EdgeInsets.all(20),
        //   decoration: BoxDecoration(
        //     color: const Color(0xFFFFE8CC),
        //     shape: BoxShape.circle,
        //   ),
        //   child: const Icon(
        //     Icons.bug_report_rounded,
        //     size: 60,
        //     color: Color(0xFFFF6B6B),
        //   ),
        // ),
        const SizedBox(height: 8),
        Text(
          '🐜',
          style: TextStyle(fontSize: 40),
        ),
      ],
    );
  }

  Widget _buildWordLabel() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _kAccentColor.withOpacity(0.2),
            _kSecondaryHighlight.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: _kAccentColor.withOpacity(0.3),
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: _kAccentColor.withOpacity(0.2),
            offset: const Offset(0, 4),
            blurRadius: 15,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '',
            style: TextStyle(fontSize: 28),
          ),
          const SizedBox(width: 12),
          Text(
            'ANT',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontSize: 52,
              fontWeight: FontWeight.w900,
              color: _kTextColorDark,
              letterSpacing: 6,
              shadows: [
                Shadow(
                  color: _kAccentColor.withOpacity(0.3),
                  offset: const Offset(2, 2),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '',
            style: TextStyle(fontSize: 28),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Audio Button
        _buildPlayfulActionButton(
          icon: Icons.volume_up_rounded,
          color: _kSuccessColor,
          label: 'Listen',
          emoji: '',
          onTap: _handleAudioTap,
          controller: _pulseController,
        ),
        const SizedBox(width: 24),

        // Microphone Button
        _buildPlayfulActionButton(
          icon: Icons.mic_rounded,
          color: _kMicColor,
          label: 'Speak',
          emoji: '',
          onTap: _handleMicTap,
          controller: _pulseController,
        ),
      ],
    );
  }

  Widget _buildPlayfulActionButton({
    required IconData icon,
    required Color color,
    required String label,
    required String emoji,
    required VoidCallback onTap,
    required AnimationController controller,
  }) {
    return Column(
      children: [
        AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            final scale = 1.0 + (controller.value * 0.05);
            return Transform.scale(
              scale: scale,
              child: child,
            );
          },
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(40),
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    color,
                    color.withOpacity(0.8),
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.5),
                    offset: const Offset(0, 8),
                    blurRadius: 20,
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.5),
                    offset: const Offset(-2, -2),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Icon(
                icon,
                color: Colors.white, // Speaker and Mic icon color
                size: 36,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(emoji, style: TextStyle(fontSize: 14)),
              const SizedBox(width: 4),
              Text(
                label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: color.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeedbackSection() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (child, animation) {
        return ScaleTransition(
          scale: animation,
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      child: _showCorrectFeedback
          ? _buildCorrectFeedback()
          : _showTryAgainFeedback
          ? _buildTryAgainFeedback()
          : const SizedBox(height: 120, key: ValueKey('empty')),
    );
  }

  Widget _buildCorrectFeedback() {
    return AnimatedBuilder(
      key: const ValueKey('correct'),
      animation: _bounceController,
      builder: (context, child) {
        final bounceValue =
        Curves.elasticOut.transform(_bounceController.value);
        return Transform.scale(
          scale: 0.8 + (bounceValue * 0.2),
          child: child,
        );
      },
      child: _PlayfulFeedbackCard(
        backgroundColor: const Color(0xFFE8F5E9),
        borderColor: _kSuccessColor,
        avatarColor: const Color(0xFFC8E6C9),
        avatarEmoji: '🎉',
        title: "It's Correct",
        subtitle: "Kiddo!",
        accentColor: _kSuccessColor,
      ),
    );
  }

  Widget _buildTryAgainFeedback() {
    return _PlayfulFeedbackCard(
      key: const ValueKey('tryagain'),
      backgroundColor: const Color(0xFFFFF3E0),
      borderColor: _kAccentColor,
      avatarColor: const Color(0xFFFFE8CC),
      avatarEmoji: '💪',
      title: "Try Again",
      subtitle: "Baby!",
      accentColor: _kAccentColor,
    );
  }
}

// ===================================================================
// 3. PLAYFUL WIDGET COMPONENTS
// ===================================================================

class _PlayfulIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color backgroundColor;
  final VoidCallback onTap;

  const _PlayfulIconButton({
    required this.icon,
    required this.color,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              offset: const Offset(0, 4),
              blurRadius: 8,
            ),
          ],
        ),
        child: Icon(
          icon,
          color: color,
          size: 24,
        ),
      ),
    );
  }
}

class _PlayfulFeedbackCard extends StatelessWidget {
  final Color backgroundColor;
  final Color borderColor;
  final Color avatarColor;
  final String avatarEmoji;
  final String title;
  final String subtitle;
  final Color accentColor;

  const _PlayfulFeedbackCard({
    Key? key,
    required this.backgroundColor,
    required this.borderColor,
    required this.avatarColor,
    required this.avatarEmoji,
    required this.title,
    required this.subtitle,
    required this.accentColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: borderColor.withOpacity(0.4),
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: borderColor.withOpacity(0.3),
            offset: const Offset(0, 8),
            blurRadius: 24,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.8),
            offset: const Offset(-2, -2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          // Playful Avatar
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  avatarColor,
                  avatarColor.withOpacity(0.7),
                ],
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: borderColor.withOpacity(0.3),
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: borderColor.withOpacity(0.3),
                  offset: const Offset(0, 4),
                  blurRadius: 12,
                ),
              ],
            ),
            child: Center(
              child: Text(
                avatarEmoji,
                style: TextStyle(fontSize: 36),
              ),
            ),
          ),
          const SizedBox(width: 20),

          // Text Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: _kTextColorDark,
                    height: 1.1,
                  ),
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: accentColor,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),

          // Star decoration
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: borderColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.star_rounded,
              color: accentColor,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}

// ===================================================================
// MAIN APP (For Testing)
// ===================================================================
