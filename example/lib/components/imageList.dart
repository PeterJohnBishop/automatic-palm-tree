import 'package:example/components/imageSizer.dart';
import 'package:flutter/material.dart';

class ImageListView extends StatefulWidget {
  final List<String> imageUrls;
  final Function(int index) onTrash; // callback to parent

  const ImageListView({
    super.key,
    required this.imageUrls,
    required this.onTrash,
  });

  @override
  State<ImageListView> createState() => _ImageListViewState();
}

class _ImageListViewState extends State<ImageListView> {
  final Map<String, bool> _orientationCache = {};

  final Map<int, bool> _hovered = {};

  @override
  void initState() {
    super.initState();
    _preloadOrientations();
  }

  void _preloadOrientations() async {
    for (final url in widget.imageUrls) {
      if (!_orientationCache.containsKey(url)) {
        final size = await getImageSize(url);
        _orientationCache[url] = size.width > size.height;
        if (mounted) setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: widget.imageUrls.length,
        itemBuilder: (context, index) {
          final url = widget.imageUrls[index];
          final isWide = _orientationCache[url];

          return MouseRegion(
            onEnter: (_) => setState(() => _hovered[index] = true),
            onExit: (_) => setState(() => _hovered[index] = false),
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: isWide == null
                        ? const SizedBox(
                            height: 200,
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : Image.network(
                            url,
                            fit: isWide ? BoxFit.fitWidth : BoxFit.fitHeight,
                            height: isWide ? 200 : 300,
                            width: double.infinity,
                            errorBuilder: (_, __, ___) {
                              return Container(
                                height: 200,
                                color: Colors.grey[300],
                                child: const Center(
                                  child: Icon(Icons.broken_image, size: 50),
                                ),
                              );
                            },
                          ),
                  ),
                ),

                if (_hovered[index] == true)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: GestureDetector(
                      onTap: () => widget.onTrash(index),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha:0.6),
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(8),
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}