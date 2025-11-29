import 'package:flutter/material.dart';
import 'package:play_bloc/models/audio_item.dart';

class Swiper extends StatefulWidget {
  final List<AudioItem> audioList;
  final int currentIndex;
  final ValueChanged<int> onpageChange;
  final Color color;

  const Swiper({
    super.key,
    required this.audioList,
    required this.currentIndex,
    required this.onpageChange,
    required this.color,
  });

  @override
  State<Swiper> createState() => _SwiperState();
}

class _SwiperState extends State<Swiper> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.currentIndex;
    _pageController = PageController(
      viewportFraction: 0.85,
      initialPage: widget.currentIndex,
    );
  }

  @override
  void didUpdateWidget(Swiper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentIndex != _currentPage) {
      _currentPage = widget.currentIndex;
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          widget.currentIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOutCubic,
        );
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final availableHeight = screenHeight * 0.35;

    return SizedBox(
      height: availableHeight.clamp(180.0, 220.0),
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.audioList.length,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
          widget.onpageChange(index);
        },
        itemBuilder: (context, index) {
          final item = widget.audioList[index];
          final isSelected = index == _currentPage;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOutCubic,
            margin: EdgeInsets.symmetric(
              horizontal: isSelected ? 8 : 16,
              vertical: isSelected ? 0 : 20,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: widget.color.withValues(alpha: 0.5),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                        spreadRadius: 2,
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
              image: DecorationImage(
                image: AssetImage(item.imagePath),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}
