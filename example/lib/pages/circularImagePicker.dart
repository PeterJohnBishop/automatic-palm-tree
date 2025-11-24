import 'package:flutter/material.dart';

class CircularImagePicker extends StatelessWidget {
  final String? imageUrl;
  final VoidCallback onUploadPressed;
  final double size;

  const CircularImagePicker({
    super.key,
    required this.imageUrl,
    required this.onUploadPressed,
    this.size = 240,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: imageUrl == null || imageUrl == ""
          ? _buildUploadButton()
          : _buildImage(),
    );
  }

  Widget _buildUploadButton() {
  return Material(
    color: Colors.white, // Background color
    shape: const CircleBorder(), // Makes hover/ripple circular
    child: InkWell(
      customBorder: const CircleBorder(), // Ensures splash follows the circle
      onTap: onUploadPressed,
      child: SizedBox(
        width: size,
        height: size,
        child: const Center(
          child: Icon(Icons.upload, color: Colors.black, size: 32),
        ),
      ),
    ),
  );
}


  Widget _buildImage() {
    return Image.network(
      imageUrl!,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => const Center(
        child: Icon(Icons.error, color: Colors.red),
      ),
      loadingBuilder: (context, child, event) {
        if (event == null) return child;
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
