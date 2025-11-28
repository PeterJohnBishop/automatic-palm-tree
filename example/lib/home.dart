import 'package:example/components/HoverIconButton.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late VideoPlayerController _controller;

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint('Could not launch $url');
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset("/homeVid.mp4")
      ..initialize().then((_) {
        _controller.setLooping(true);
        _controller.setVolume(0); // mute (good for backgrounds)
        _controller.play();
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        var isWide = width > height;
        return Scaffold(
          body: Stack(
            children: [
              // VIDEO BACKGROUND
              Positioned.fill(
                child: _controller.value.isInitialized
                    ? FittedBox(
                        fit: isWide ? BoxFit.cover : BoxFit.fitHeight,
                        child: SizedBox(
                          width: _controller.value.size.width,
                          height: _controller.value.size.height,
                          child: VideoPlayer(_controller),
                        ),
                      )
                    : Container(color: Colors.black),
              ),

              // DARK OVERLAY
              Positioned.fill(
                child: Container(color: Colors.black.withValues(alpha: 0.4)),
              ),

              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "PETER JOHN BISHOP",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Local Small Business Website Design | Real Estate",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        HoverIconButton(
                          icon: Icons.phone,
                          label: '+1 720 272 5223',
                          onPressed: () {
                            _launchURL('tel:+17202725223');
                          },
                        ),
                        const SizedBox(width: 20),
                        HoverIconButton(
                          icon: Icons.email,
                          label: 'peterjbishop.denver@gmail.com',
                          onPressed: () {
                            _launchURL('mailto:peterjbishop.denver@gmail.com');
                          },
                        ),
                      ],
                    ),
                    Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: 1800, // or any width you prefer
                        ),
                        child: SizedBox(
                          height: 300,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.all(24),
                            itemCount: quotes.length,
                            itemBuilder: (context, index) {
                              final q = quotes[index];
                              return Padding(
                                padding: EdgeInsets.all(16),
                                child: SizedBox(
                                  width: 300,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        q["quote"],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Text(
                                          "- ${q["from"]}",
                                          style: TextStyle(
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

const List<Map<String, dynamic>> quotes = [
  {
    "from": "Digital Property Weekly",
    "quote":
        "Peter Bishop’s real estate websites don’t just showcase homes—they elevate them into immersive digital experiences that sell themselves.",
  },
  {
    "from": "Modern Realtor Magazine",
    "quote":
        "Bishop has mastered the art of blending clean design with high-performance functionality. Few designers understand agents’ needs like he does.",
  },
  {
    "from": "PropTech Innovators Journal",
    "quote":
        "Every site Peter Bishop builds feels like the future of real estate—fast, intuitive, and crafted with remarkable attention to detail.",
  },
  {
    "from": "The Real Estate Designer Review",
    "quote":
        "Bishop’s work redefines what a real estate presence should be. His interfaces are elegant, his systems seamless, and his results unmatched.",
  },
  {
    "from": "MarketVision Web Trends Report",
    "quote":
        "Peter Bishop sets a new standard for real estate web design. His sites convert, impress, and consistently outperform industry averages.",
  },
];
