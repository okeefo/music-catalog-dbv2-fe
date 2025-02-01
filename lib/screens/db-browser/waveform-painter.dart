import 'package:flutter/material.dart';

class WaveformPainter extends CustomPainter {
  final List<double> waveformData;
  final double playbackProgress;

  WaveformPainter({
    required this.waveformData,
    required this.playbackProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paintBase = Paint()
      ..color = const Color(0xFFFF8200) // orange
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    final paintProgress = Paint()
      ..color = const Color(0xFF0000FF) // blue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final midY = size.height / 2;
    final step = waveformData.length / size.width;

    for (double x = 0; x < size.width; x++) {
      final index = (x * step).clamp(0, waveformData.length - 1).toInt();
      // Normalize your amplitude 0..1
      final amplitudeNormalized = (waveformData[index] / 100.0).clamp(0.0, 1.0);
      final amplitude = amplitudeNormalized * (size.height / 2);

      // Now draw one vertical line from top of wave to bottom of wave
      // at this x-coordinate. This gives a symmetric “centered” view.
      canvas.drawLine(
        Offset(x, midY - amplitude),
        Offset(x, midY + amplitude),
        paintBase,
      );
    }

    // Draw the "played" portion in blue
    final playedWidth = size.width * playbackProgress;
    final pathProgress = Path()..moveTo(0, midY);
    for (double x = 0; x < playedWidth; x++) {
      final index = (x * step).clamp(0, waveformData.length - 1).toInt();
      final amplitude = waveformData[index] * (size.height / 2);
      pathProgress.lineTo(x, midY - amplitude);
    }
    canvas.drawPath(pathProgress, paintProgress);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class WaveformPainter2 extends CustomPainter {
  final List<double> waveformData;
  final double playbackProgress;
  final Color baseColor;
  final Color progressColor;

  WaveformPainter2({
    required this.waveformData,
    required this.playbackProgress,
    this.baseColor = Colors.orange,
    this.progressColor = Colors.blue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paintBase = Paint()
      ..color = baseColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final paintProgress = Paint()
      ..color = progressColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    if (waveformData.isEmpty) return;

    final middleY = size.height / 2;
    final step = waveformData.length / size.width;

    // Draw full waveform in baseColor
    final pathBase = Path();
    pathBase.moveTo(0, middleY);
    for (double x = 0; x < size.width; x++) {
      final dataIndex = (x * step).clamp(0, waveformData.length - 1).toInt();
      final amplitude = waveformData[dataIndex] * (size.height / 2);
      pathBase.lineTo(x, middleY - amplitude);
    }
    canvas.drawPath(pathBase, paintBase);

    // Draw progress portion in progressColor
    final progressWidth = size.width * playbackProgress;
    final pathProgress = Path();
    pathProgress.moveTo(0, middleY);
    for (double x = 0; x < progressWidth; x++) {
      final dataIndex = (x * step).clamp(0, waveformData.length - 1).toInt();
      final amplitude = waveformData[dataIndex] * (size.height / 2);
      pathProgress.lineTo(x, middleY - amplitude);
    }
    canvas.drawPath(pathProgress, paintProgress);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class WaveformWidget extends StatelessWidget {
  final List<double> waveformData;
  final double playbackProgress;

  const WaveformWidget({
    Key? key,
    required this.waveformData,
    required this.playbackProgress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 100),
      painter: WaveformPainter(
        waveformData: waveformData,
        playbackProgress: playbackProgress,
      ),
    );
  }
}
