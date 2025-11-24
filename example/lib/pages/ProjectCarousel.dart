import 'package:example/pages/ImageSlideWidget.dart';
import 'package:flutter/material.dart';

class ImageCarousel extends StatefulWidget {
  final List<String> images;
  final double indicatorSize;
  final double indicatorSpacing;
  final Color activeIndicatorColor;
  final Color inactiveIndicatorColor;
  final EdgeInsetsGeometry? padding;

  const ImageCarousel({
    Key? key,
    required this.images,
    this.indicatorSize = 10.0,
    this.indicatorSpacing = 8.0,
    this.activeIndicatorColor = Colors.white,
    this.inactiveIndicatorColor = Colors.white54,
    this.padding,
  }) : super(key: key);

  @override
  _ImageCarouselState createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  late final PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _animateToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildIndicators() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.images.length, (i) {
        final bool active = i == _currentIndex;
        return GestureDetector(
          onTap: () => _animateToPage(i),
          child: Container(
            margin: EdgeInsets.symmetric(vertical: widget.indicatorSpacing / 2),
            width: widget.indicatorSize,
            height: widget.indicatorSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: active ? Colors.black : Colors.grey[300],
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final double containerSize = (width * 0.95).clamp(380, 580);

        return SizedBox(
          width: containerSize,
          height: containerSize,
          child: Padding(
            padding: widget.padding ?? EdgeInsets.zero,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget.images.length > 1 ?
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: _buildIndicators(),
                ) : SizedBox(),

                // Carousel window
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 1.2,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: PageView.builder(
                        controller: _pageController,
                        scrollDirection: Axis.vertical,
                        itemCount: widget.images.length,
                        physics: const ClampingScrollPhysics(),
                        onPageChanged: (index) {
                          setState(() => _currentIndex = index);
                        },
                        itemBuilder: (context, index) {
                          return ImageSlideWidget(
                            imagePath: widget.images[index],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
