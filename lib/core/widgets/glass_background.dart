/**
 * 1) Общее назначение:
 *    Виджет-обертка, создающий мягкий фон с размытыми красными фигурами.
 * 2) С какими файлами связан:
 *    - lib/core/theme/app_colors.dart (цвета)
 *    - Используется как корневой фон на RegistrationPage, LoginPage, WelcomePage.
 * 3) Описание функций:
 *    - build(): Отрисовывает Stack с белым фоном и двумя полупрозрачными красными кругами.
 *      Если isReversed = true, перемещает основной красный круг в левый нижний угол (для LoginPage).
 */
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class GlassBackground extends StatelessWidget {
  final Widget child;
  final bool isReversed;

  const GlassBackground({
    Key? key,
    required this.child,
    this.isReversed = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background color
        Container(color: AppColors.white),
        
        // Chaotic static red blob (Temporarily hidden)
        /*
        Positioned(
          top: 100, // чуть повыше
          right: isReversed ? null : -20,
          left: isReversed ? -20 : null,
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()..scale(isReversed ? -1.0 : 1.0, 1.0, 1.0),
            child: SizedBox(
              width: 430,
              height: 560,
              child: CustomPaint(
                painter: RedBlobPainter(),
              ),
            ),
          ),
        ),
        */
        
        // The main content
        SafeArea(child: child),
      ],
    );
  }
}

/*
class RedBlobPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    // Path coordinates map originally roughly X:241..666, Y:321..882
    // We translate so it draws nicely inside the widget bounds
    canvas.translate(-240, -320);

    final path = Path()
      ..moveTo(628.5, 562.724)
      ..cubicTo(654.597, 602.999, 666.363, 654.363, 661.209, 705.515)
      ..cubicTo(656.055, 756.668, 634.404, 803.42, 601.018, 835.485)
      ..cubicTo(567.633, 867.551, 525.248, 882.304, 483.187, 876.499)
      ..cubicTo(441.127, 870.694, 402.836, 844.806, 376.739, 804.531)
      ..cubicTo(288.699, 668.658, 241.436, 454.719, 311.002, 387.903)
      ..cubicTo(380.567, 321.088, 550.817, 442.836, 628.5, 562.724)
      ..close();
    
    final paint = Paint()
      ..color = const Color(0xFFE30613)
      ..style = PaintingStyle.fill;
      
    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
*/
