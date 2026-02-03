import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rafiq/core/constants/app_dimensions.dart';
import 'package:rafiq/features/home/presentation/widgets/home_body/animal_card.dart';
import 'package:rafiq/features/pets/data/models/pet_model.dart';

class PetsCarouselSection extends StatefulWidget {
  final List<PetModel> pets;
  final Function(int) onPageChanged;

  const PetsCarouselSection({
    super.key,
    required this.pets,
    required this.onPageChanged,
  });

  @override
  State<PetsCarouselSection> createState() => _PetsCarouselSectionState();
}

class _PetsCarouselSectionState extends State<PetsCarouselSection> {
  late PageController _controller;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 1.0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentIndex < widget.pets.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _prevPage() {
    if (_currentIndex > 0) {
      _controller.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  double _calculateDynamicHeight(int index) {
    final pet = widget.pets[index];
    double baseHeight = 270.h;

    if (pet.collar == null) {
      return baseHeight + 120.h;
    } else {
      double collarWidgetsHeight = 60.h;
      String tipText = pet.collar!.dailyTip;
      double textHeight = (tipText.length / 35) * 20.h;
      return baseHeight + collarWidgetsHeight + textHeight + 120.h;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool canGoBack = _currentIndex > 0;
    final bool canGoForward = _currentIndex < widget.pets.length - 1;
    final textDirection = Directionality.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      height: _calculateDynamicHeight(_currentIndex),
      width: double.infinity,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: widget.pets.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });

              widget.onPageChanged(index);
            },
            itemBuilder: (context, index) {
              return AnimalCard(
                pet: widget.pets[index],
                index: index,
                totalCount: widget.pets.length,
              );
            },
          ),

          Positioned.directional(
            textDirection: textDirection,
            end: 10.w,
            top: 180.h,
            child: _ArrowButton(
              icon: Icons.arrow_forward_ios_rounded,
              onTap: _nextPage,
              isEnabled: canGoForward,
            ),
          ),
          Positioned.directional(
            textDirection: textDirection,
            start: 10.w,
            top: 180.h,
            child: _ArrowButton(
              icon: Icons.arrow_back_ios_rounded,
              onTap: _prevPage,
              isEnabled: canGoBack,
            ),
          ),
        ],
      ),
    );
  }
}

class _ArrowButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isEnabled;

  const _ArrowButton({
    required this.icon,
    required this.onTap,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isEnabled ? 1.0 : 0.3,
      duration: const Duration(milliseconds: 200),
      child: Container(
        width: 40.w,
        height: 40.h,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: IconButton(
          padding: EdgeInsets.zero,
          icon: Icon(
            icon,
            size: AppDimensions.iconM,
            color: isEnabled
                ? Theme.of(context).colorScheme.primary
                : Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.5),
            textDirection: Directionality.of(context),
          ),
          onPressed: isEnabled ? onTap : null,
        ),
      ),
    );
  }
}
