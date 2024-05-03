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

    _animation = Tween<double>(begin: 0.2, end: 0.8).animate(
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
      size: Size(50, 200), // 조정 가능한 온도계 크기
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
    var paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    double liquidHeight = size.height * level * waveEffect;

    var path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, paint..color = Colors.grey);

    canvas.drawRect(Rect.fromLTWH(0, size.height - liquidHeight, size.width, liquidHeight), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
