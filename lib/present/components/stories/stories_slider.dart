import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '../../theme/app_colors.dart';
import 'dart:async';

class StoriesSlider extends StatefulWidget {
  const StoriesSlider({super.key});

  @override
  State<StoriesSlider> createState() => _StoriesSliderState();
}

class _StoriesSliderState extends State<StoriesSlider> {
  final List<StoryData> _stories = [
    StoryData(
      id: '1',
      title: 'Новые квесты',
      subtitle: 'Откройте новые заклинания и способности',
      avatar:
          'https://images.unsplash.com/photo-1518709268805-4e9042af2176?w=150',
      color: const Color(0xFF5B2333),
      items: [
        StoryItem(
          type: StoryItemType.image,
          content:
              'https://images.unsplash.com/photo-1518709268805-4e9042af2176?w=800&h=600&fit=crop',
          text: 'Новые заклинания ждут вас!',
          duration: 3,
        ),
        StoryItem(
          type: StoryItemType.text,
          content: 'Изучите древние руны и получите новые способности',
          text: 'Магия открывает новые возможности',
          duration: 4,
        ),
        StoryItem(
          type: StoryItemType.image,
          content:
              'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=',
          text: 'Каждый квест уникален',
          duration: 3,
        ),
      ],
    ),
    StoryData(
      id: '2',
      title: 'Турнир героев',
      subtitle: 'Сразитесь с другими игроками',
      avatar:
          'https://images.unsplash.com/photo-1542751371-adc38448a05e?w=150&h=150&fit=crop&crop=face',
      color: const Color(0xFF234E52),
      items: [
        StoryItem(
          type: StoryItemType.image,
          content:
              'https://images.unsplash.com/photo-1542751371-adc38448a05e?w=800&h=600&fit=crop',
          text: 'Докажите свою силу!',
          duration: 3,
        ),
        StoryItem(
          type: StoryItemType.text,
          content: 'Сразитесь с лучшими игроками и получите уникальные награды',
          text: 'Только сильнейшие выживут',
          duration: 4,
        ),
        StoryItem(
          type: StoryItemType.image,
          content:
              'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800&h=600&fit=crop',
          text: 'Слава ждет победителей',
          duration: 3,
        ),
      ],
    ),
    StoryData(
      id: '3',
      title: 'Новые расы',
      subtitle: 'Добавлены новые расы персонажей',
      avatar:
          'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=150&h=150&fit=crop&crop=face',
      color: const Color(0xFF4B3869),
      items: [
        StoryItem(
          type: StoryItemType.image,
          content:
              'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=800&h=600&fit=crop',
          text: 'Откройте новые расы!',
          duration: 3,
        ),
        StoryItem(
          type: StoryItemType.text,
          content: 'Эльфы, гномы, орки и многие другие ждут вас',
          text: 'Каждая раса уникальна',
          duration: 4,
        ),
        StoryItem(
          type: StoryItemType.image,
          content:
              'https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?w=800&h=600&fit=crop',
          text: 'Создайте уникального героя',
          duration: 3,
        ),
      ],
    ),
    StoryData(
      id: '4',
      title: 'Гильдии',
      subtitle: 'Создавайте и присоединяйтесь к гильдиям',
      avatar:
          'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=150&h=150&fit=crop&crop=face',
      color: const Color(0xFF7C5E3C),
      items: [
        StoryItem(
          type: StoryItemType.image,
          content:
              'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800&h=600&fit=crop',
          text: 'Присоединяйтесь к гильдии!',
          duration: 3,
        ),
        StoryItem(
          type: StoryItemType.text,
          content: 'Создавайте альянсы и сражайтесь вместе',
          text: 'Вместе мы сильнее',
          duration: 4,
        ),
        StoryItem(
          type: StoryItemType.image,
          content:
              'https://images.unsplash.com/photo-1518709268805-4e9042af2176?w=800&h=600&fit=crop',
          text: 'Гильдии открывают новые возможности',
          duration: 3,
        ),
      ],
    ),
    StoryData(
      id: '5',
      title: 'Ежедневные награды',
      subtitle: 'Получайте награды каждый день',
      avatar:
          'https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?w=150&h=150&fit=crop&crop=face',
      color: const Color(0xFF223A5E),
      items: [
        StoryItem(
          type: StoryItemType.image,
          content:
              'https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?w=800&h=600&fit=crop',
          text: 'Ежедневные награды!',
          duration: 3,
        ),
        StoryItem(
          type: StoryItemType.text,
          content: 'Заходите каждый день и получайте уникальные предметы',
          text: 'Награды ждут вас',
          duration: 4,
        ),
        StoryItem(
          type: StoryItemType.image,
          content:
              'https://images.unsplash.com/photo-1542751371-adc38448a05e?w=800&h=600&fit=crop',
          text: 'Специальные события каждый день',
          duration: 3,
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Новое в PATHFINDER',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        Container(
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _stories.length,
            itemBuilder: (context, index) {
              final story = _stories[index];
              return GestureDetector(
                onTap: () => _showStoryView(context, story),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: Column(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [story.color, story.color.withOpacity(0.7)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(3),
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: ClipOval(
                              child: Image.network(
                                story.avatar,
                                fit: BoxFit.cover,
                                loadingBuilder: (
                                  context,
                                  child,
                                  loadingProgress,
                                ) {
                                  if (loadingProgress == null) return child;
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: story.color.withOpacity(0.3),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        value:
                                            loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                : null,
                                        color: story.color,
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: story.color.withOpacity(0.3),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.person,
                                      size: 30,
                                      color: story.color,
                                    ),
                                  );
                                },
                              ),
                            ),
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
      ],
    );
  }

  void _showStoryView(BuildContext context, StoryData story) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder:
            (context, animation, secondaryAnimation) =>
                _StoryView(story: story),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }
}

class _StoryView extends StatefulWidget {
  final StoryData story;

  const _StoryView({required this.story});

  @override
  State<_StoryView> createState() => _StoryViewState();
}

class _StoryViewState extends State<_StoryView> {
  int _currentItemIndex = 0;
  late Timer _timer;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startTimer() {
    final currentItem = widget.story.items[_currentItemIndex];
    _timer = Timer(Duration(seconds: currentItem.duration), () {
      if (_currentItemIndex < widget.story.items.length - 1) {
        setState(() {
          _currentItemIndex++;
        });
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        _startTimer();
      } else {
        Navigator.of(context).pop();
      }
    });
  }

  void _onTap() {
    _timer.cancel();
    if (_currentItemIndex < widget.story.items.length - 1) {
      setState(() {
        _currentItemIndex++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _startTimer();
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Story content
          PageView.builder(
            controller: _pageController,
            itemCount: widget.story.items.length,
            onPageChanged: (index) {
              _timer.cancel();
              setState(() {
                _currentItemIndex = index;
              });
              _startTimer();
            },
            itemBuilder: (context, index) {
              final item = widget.story.items[index];
              return GestureDetector(
                onTap: _onTap,
                child: _StoryItemView(item: item),
              );
            },
          ),

          // Progress bars
          Positioned(
            top: 50,
            left: 16,
            right: 16,
            child: Row(
              children: List.generate(widget.story.items.length, (index) {
                return Expanded(
                  child: Container(
                    height: 3,
                    margin: EdgeInsets.only(
                      right: index < widget.story.items.length - 1 ? 4 : 0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: AnimatedContainer(
                      duration: Duration(
                        milliseconds: index == _currentItemIndex ? 100 : 300,
                      ),
                      decoration: BoxDecoration(
                        color:
                            index <= _currentItemIndex
                                ? Colors.white
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),

          // Close button
          Positioned(
            top: 50,
            right: 16,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StoryItemView extends StatelessWidget {
  final StoryItem item;

  const _StoryItemView({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black.withOpacity(0.8),
            Colors.black.withOpacity(0.4),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: [
          // Background image or content
          if (item.type == StoryItemType.image)
            Positioned.fill(
              child: Image.network(
                item.content,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.black,
                    child: Center(
                      child: CircularProgressIndicator(
                        value:
                            loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.black,
                    child: Center(
                      child: Icon(
                        Icons.image,
                        size: 100,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  );
                },
              ),
            ),

          // Text content
          Positioned(
            bottom: 100,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item.type == StoryItemType.text)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      item.content,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        height: 1.4,
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                Text(
                  item.text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black54,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StoryData {
  final String id;
  final String title;
  final String subtitle;
  final String avatar;
  final Color color;
  final List<StoryItem> items;

  StoryData({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.avatar,
    required this.color,
    required this.items,
  });
}

class StoryItem {
  final StoryItemType type;
  final String content;
  final String text;
  final int duration;

  StoryItem({
    required this.type,
    required this.content,
    required this.text,
    required this.duration,
  });
}

enum StoryItemType { image, text }
