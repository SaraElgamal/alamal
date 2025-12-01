import 'package:flutter/material.dart';

class RoundedLineTabIndicator extends Decoration {
  final Color color;
  final double radius;
  final double thickness;

  const RoundedLineTabIndicator({
    required this.color,
    this.radius = 3,
    this.thickness = 4,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _RoundedLinePainter(this, onChanged);
  }
}

class _RoundedLinePainter extends BoxPainter {
  final RoundedLineTabIndicator decoration;

  _RoundedLinePainter(this.decoration, VoidCallback? onChanged)
      : super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration config) {
    final Paint paint = Paint()
      ..color = decoration.color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final double width = config.size!.width;
    final double height = config.size!.height;

    // Draw rounded line at bottom
    final Rect rect = Offset(
      offset.dx,
      offset.dy + height - decoration.thickness,
    ) &
        Size(width, decoration.thickness);

    final RRect rrect = RRect.fromRectAndRadius(
      rect,
      Radius.circular(decoration.radius),
    );

    canvas.drawRRect(rrect, paint);
  }
}
