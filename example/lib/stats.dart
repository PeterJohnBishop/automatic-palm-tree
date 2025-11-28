import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        var isWide = width > height;
        return Scaffold(
          backgroundColor: Colors.white,
          body: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: isWide ? 600 : 300,
                height: height,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Why buy with me?',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Working with me means having a dedicated advocate who understands both the Denver market and the personal significance of purchasing a home. I take a highly personalized approach—listening closely to your goals, educating you through every step, and using deep market insight to identify the best opportunities before they hit the radar. My clients value my clear communication, negotiation skills, and ability to simplify complex decisions so they feel confident from start to finish. Whether you’re a first-time buyer or building an investment portfolio, I’m committed to making the process smooth, strategic, and genuinely enjoyable.',
                      ),
                      const SizedBox(height: 36),
                      Text("Ready to find your dream home?"),
                      const SizedBox(height: 36),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AltHoverIconButton(
                            icon: Icons.phone,
                            label: '+1 720 272 5223',
                            onPressed: () {
                              _launchURL('tel:+17202725223');
                            },
                          ),
                          const SizedBox(width: 20),
                          AltHoverIconButton(
                            icon: Icons.email,
                            label: 'peterjbishop.denver@gmail.com',
                            onPressed: () {
                              _launchURL(
                                'mailto:peterjbishop.denver@gmail.com',
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class AltHoverIconButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const AltHoverIconButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  State<AltHoverIconButton> createState() => _AltHoverIconButtonState();
}

class _AltHoverIconButtonState extends State<AltHoverIconButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: _isHovered ? Colors.black : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                color: _isHovered ? Colors.white : Colors.black,
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                child: _isHovered
                    ? Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          widget.label,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
