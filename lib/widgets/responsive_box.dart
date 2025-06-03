import 'package:flutter/material.dart';

enum ResponsiveBoxSize { sm, md, lg, xl, infinite }

class ResponsiveBox extends StatelessWidget {
  const ResponsiveBox({
    required this.child,
    this.size,
    this.alignment = Alignment.topCenter,
    super.key,
  });

  final Widget child;
  final ResponsiveBoxSize? size;
  final Alignment alignment;

  double _getWidth() {
    switch (size) {
      case ResponsiveBoxSize.sm:
        return 640;
      case ResponsiveBoxSize.md:
        return 768;
      case ResponsiveBoxSize.lg:
        return 1024;
      case ResponsiveBoxSize.xl:
        return 1280;
      default:
        return double.infinity;
    }
  }

  double _widthContainer(double width) {
    if (width >= 640 && width < 768) {
      return 640;
    } else if (width >= 768 && width < 1024) {
      return 768;
    } else if (width >= 1024 && width < 1280) {
      return 1024;
    } else if (width >= 1280 && width < 1536) {
      return 1280;
    } else if (width >= 1536) {
      return 1536;
    }

    return double.infinity;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;

    return SizedBox(
      width: double.infinity,
      child: Align(
        alignment: alignment,
        child: SizedBox(
          width: size != null ? _getWidth() : _widthContainer(width),
          child: child,
        ),
      ),
    );
  }
}
