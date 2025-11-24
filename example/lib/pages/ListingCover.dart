import 'package:flutter/material.dart';

class ListingCover extends StatefulWidget {
  final double width;
  final double height;
  final String? imageUrl;
  final VoidCallback onUploadPressed;
  const ListingCover({
    super.key,
    required this.width,
    required this.height,
    required this.imageUrl,
    required this.onUploadPressed,
  });

  @override
  State<ListingCover> createState() => _ListingCoverState();
}

class _ListingCoverState extends State<ListingCover> {
  double width = 0;
  double height = 0;

  @override
  void initState() {
    super.initState();
    width = widget.width;
    height = widget.height;
  }

  @override
  Widget build(BuildContext context) {
    double formWidth;
    double formHeight;
    EdgeInsets padding;

    if (width < 600) {
      formWidth = width * 0.9; // mobile
      formHeight = height * 0.9;
      padding = const EdgeInsets.all(16);
    } else if (width < 1100) {
      formWidth = width * 0.7; // tablet
      formHeight = height * 0.9;
      padding = const EdgeInsets.all(24);
    } else {
      formWidth = width * 0.6; // desktop
      formHeight = height * 0.4;
      padding = const EdgeInsets.all(10);
    }

    Widget _buildUploadButton() {
      return Material(
        color: Colors.white, // Background color
        shape: const CircleBorder(), // Makes hover/ripple circular
        child: InkWell(
          customBorder:
              const CircleBorder(), // Ensures splash follows the circle
          onTap: widget.onUploadPressed,
          child: SizedBox(
            width: formHeight,
            height: formWidth,
            child: const Center(
              child: Icon(Icons.upload, color: Colors.black, size: 32),
            ),
          ),
        ),
      );
    }

    Widget _buildImage() {
      return Image.network(
        widget.imageUrl!,
        fit: BoxFit.fitHeight,
        errorBuilder: (_, __, ___) =>
            const Center(child: Icon(Icons.error, color: Colors.red)),
        loadingBuilder: (context, child, event) {
          if (event == null) return child;
          return const Center(child: CircularProgressIndicator());
        },
      );
    }

    return Container(
      width: formWidth,
      height: formHeight,
      // color: Colors.red.withOpacity(0.2),
      decoration: BoxDecoration(
        color: Colors.white, // needed for shadow visibility
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 20,
            spreadRadius: 2,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: widget.imageUrl == null || widget.imageUrl == ""
          ? _buildUploadButton()
          : _buildImage(),
    );
  }
}
