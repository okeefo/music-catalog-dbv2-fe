import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class WaveformPainter extends CustomPainter {
  final List<double> waveformData;
  final double playbackProgress;
  static final Logger _logger = Logger('WaveformPainter');
  final Paint progressBarPainter;
  final Paint waveformPainter;
  final Paint progressPainter;

  WaveformPainter({
    required this.waveformData,
    required this.playbackProgress,
    required Color progressBarColor,
    required Color waveformColor,
    required Color progressColor,
  })  : progressBarPainter = Paint()
          ..color = progressBarColor
          ..strokeWidth = 1,
        waveformPainter = Paint()
          ..color = waveformColor
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke,
        progressPainter = Paint()
          ..color = progressColor
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final midY = size.height / 2;
    final step = waveformData.length / size.width;

    // Draw the full waveform in orange
    paintWaveform(waveformData, step, midY, size.height, size.width, canvas, waveformPainter);

   // _logger.info('WaveformPainter: paint() - playbackProgress: $playbackProgress step: $step');

    // Draw the "played" portion in blue
    final playedWidth = size.width * playbackProgress;
    paintWaveform(waveformData, step, midY, size.height, playedWidth, canvas, progressPainter);

    // Draw a vertical line at the current playback position
    final progressX = playedWidth.clamp(0, size.width);
    canvas.drawLine(Offset(progressX.toDouble(), 0), Offset(progressX.toDouble(), size.height), progressBarPainter);

    // _logger.info('WaveformPainter: paint() - progressX: $progressX, playedWidth: $playedWidth. playbackProgress: $playbackProgress');
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  void paintWaveform(List<double> waveformData, double step, double midY, double maxHeight, double widthToDraw, Canvas? canvas, Paint painter) {
    for (double x = 0; x < widthToDraw; x++) {
      final index = (x * step).clamp(0, waveformData.length - 1).toInt();
      //final index = x.toInt();

      // Normalize the amplitude 0..1
      final amplitudeNormalized = (waveformData[index] / 100.0).clamp(0.0, 1.0);
      final amplitude = amplitudeNormalized * (maxHeight / 2);

      // Draw one vertical line from top of the wave to bottom of the wave
      // at this x-coordinate. This gives a symmetric “centred” view.
      canvas?.drawLine(
        Offset(x, midY - amplitude),
        Offset(x, midY + amplitude),
        painter,
      );
    }
  }
}
