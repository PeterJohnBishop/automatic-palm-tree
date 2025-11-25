import 'package:example/components/imageSizer.dart';
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
  late double width;
  late double height;

  bool? _isWide; 
  @override
  void initState() {
    super.initState();
    width = widget.width;
    height = widget.height;

    _loadOrientation(); 
  }

  @override
  void didUpdateWidget(covariant ListingCover oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If imageUrl changes, recompute orientation
    if (oldWidget.imageUrl != widget.imageUrl) {
      _isWide = null; // reset
      _loadOrientation();
    }
  }

  void _loadOrientation() async {
    if (widget.imageUrl == null || widget.imageUrl!.isEmpty) return;
    final size = await getImageSize(widget.imageUrl!);
    setState(() {
      _isWide = size.width > size.height;
    });
  }

  @override
  Widget build(BuildContext context) {
    double formWidth;
    double formHeight;

    if (width < 600) {
      formWidth = width * 0.9;
      formHeight = height * 0.9;
    } else if (width < 1100) {
      formWidth = width * 0.7;
      formHeight = height * 0.9;
    } else {
      formWidth = width * 0.6;
      formHeight = height * 0.4;
    }

    // Upload button
    Widget _buildUploadButton() {
      return Material(
        color: Colors.white,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: widget.onUploadPressed,
          child: const SizedBox(
            width: 80,
            height: 80,
            child: Center(child: Icon(Icons.upload, size: 32)),
          ),
        ),
      );
    }

    Widget _buildImage() {
      if (_isWide == null) {
        return const Center(child: CircularProgressIndicator());
      }

      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.network(
          widget.imageUrl!,
          fit: _isWide! ? BoxFit.fitWidth : BoxFit.fitHeight,
          errorBuilder: (_, __, ___) =>
              const Center(child: Icon(Icons.error, color: Colors.red)),
        ),
      );
    }

    return Container(
      width: formWidth,
      height: formHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 20,
            spreadRadius: 2,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: widget.imageUrl == null || widget.imageUrl!.isEmpty
          ? _buildUploadButton()
          : _buildImage(),
    );
  }
}

