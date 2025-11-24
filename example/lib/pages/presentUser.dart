import 'package:example/pages/UserDocumentService.dart';
import 'package:example/pages/HoverIconButton.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PresentUser extends StatefulWidget {
  final UserDocument userDocument;
  final double size;
  const PresentUser({
    super.key,
    required this.userDocument,
    required this.size,
  });

  @override
  State<PresentUser> createState() => _PresentUserState();
}

class _PresentUserState extends State<PresentUser> {
  late UserDocument user;
  late double size;

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
    user = widget.userDocument;
    size = widget.size;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.start,
        //   children: [
        //     SizedBox(width: 8),
        //     HoverIconButton(
        //       icon: Icons.phone,
        //       label: user.phone,
        //       onPressed: () {
        //         _launchURL('tel:+1${user.phone}');
        //       },
        //     ),
        //     SizedBox(width: 8),
        //     HoverIconButton(
        //       icon: Icons.email,
        //       label: user.email,
        //       onPressed: () {
        //         _launchURL('mailto:+1${user.email}');
        //       },
        //     ),
        //   ],
        // ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
                        Padding(
              padding: EdgeInsets.all(8),
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: user.image != ""
                    ? Image.network(
                        user.image,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Center(
                          child: Icon(Icons.error, color: Colors.red),
                        ),
                        loadingBuilder: (context, child, event) {
                          if (event == null) return child;
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      )
                    : const Center(
                        child: Icon(
                          Icons.person,
                          color: Colors.black,
                          size: 32,
                        ),
                      ),
              ),
            ),
            SizedBox(width: 8),
            Text(user.name, style: TextStyle(fontSize: 22)),
          ],
        ),
      ],
    );
  }
}
