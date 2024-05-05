import 'package:flutter/material.dart';

class ThermometerWidget extends StatefulWidget {
  final double temperature;

  const ThermometerWidget({Key? key, required this.temperature}) : super(key: key);

  @override
  _ThermometerWidgetState createState() => _ThermometerWidgetState();
}

class _ThermometerWidgetState extends State<ThermometerWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.9, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut)
    )..addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(50, 200), // Configurable thermometer size
      painter: ThermometerPainter(widget.temperature / 100, _animation.value),
    );
  }
}

class ThermometerPainter extends CustomPainter {
  final double level;
  final double waveEffect;

  ThermometerPainter(this.level, this.waveEffect);

  @override
  void paint(Canvas canvas, Size size) {
    List<Color> gradientColors = [
      Colors.green,
      Colors.yellow,
      Colors.orange,
      Colors.red,
      Colors.deepPurple
    ];

    final stops = List.generate(gradientColors.length, (index) => index / (gradientColors.length - 1));

    final Gradient gradient = LinearGradient(
      colors: gradientColors,
      stops: stops,
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
    );

    var liquidPaint = Paint()
      ..shader = gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    canvas.drawRect(Rect.fromLTWH(0, size.height - level * size.height * waveEffect, size.width, level * size.height * waveEffect), liquidPaint);

    var containerPaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    var containerPath = Path()
      ..moveTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..lineTo(0, 0)
      ..close();
    canvas.drawPath(containerPath, containerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
