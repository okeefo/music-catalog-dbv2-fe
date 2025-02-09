import 'dart:typed_data';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/providers/theme_provider.dart';
import 'package:front_end/screens/db-browser/media_player_provider.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:front_end/screens/db-browser/waveform-painter.dart';

class MediaPlayer extends StatelessWidget {
  static final Logger _logger = Logger('MediaPlayer');
  static final spacer = const SizedBox(width: 16);
  static final AssetImage defaultArtwork = AssetImage('assets/vinyl-100.png');

  @override
  Widget build(BuildContext context) {
    final mediaPlayerProvider = Provider.of<MediaPlayerProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 600),
      child: SizedBox(
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildArtwork(context, mediaPlayerProvider),
                _buildMediaButtons(mediaPlayerProvider),
              ],
            ),
            spacer,
            Expanded(
              child: Column(
                children: [
                  // Player status area
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Row(
                      children: [
                        // Show duration if we have a track
                        if (mediaPlayerProvider.currentTrack != null)
                          Text(
                            formatPlayPosition(mediaPlayerProvider.position.inMilliseconds),
                            style: TextStyle(
                              color: themeProvider.fontColour,
                              fontSize: themeProvider.fontSizeReg,
                            ),
                          ),
                        // Center the status details
                        Expanded(
                          child: Center(
                            child: Text(
                              mediaPlayerProvider.currentTrack == null
                                  ? "No track info"
                                  : mediaPlayerProvider.playerStatus == PlayerStatus.Paused
                                      ? "** Paused **  : ${mediaPlayerProvider.currentTrack!.title}"
                                      : mediaPlayerProvider.currentTrack!.title,
                              style: TextStyle(
                                color: themeProvider.fontColour,
                                fontSize: themeProvider.fontSizeReg,
                              ),
                            ),
                          ),
                        ),
                        if (mediaPlayerProvider.currentTrack != null)
                          Text(
                            formatPlayPosition(mediaPlayerProvider.duration.inMilliseconds),
                            style: TextStyle(
                              color: themeProvider.fontColour,
                              fontSize: themeProvider.fontSizeReg,
                            ),
                          )
                      ],
                    ),
                  ),

                  // Waveform area
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
                    height: 100.0,
                    child: mediaPlayerProvider.waveformData == null
                        ? Center(
                            child: Text(
                              'No Track Selected / Loaded',
                              style: TextStyle(
                                color: themeProvider.fontColour,
                                fontSize: themeProvider.fontSizeLarge,
                              ),
                            ),
                          )
                        : CustomPaint(
                            size: Size(double.infinity, 60),
                            painter: WaveformPainter(
                              waveformData: mediaPlayerProvider.waveformData!,
                              playbackProgress: mediaPlayerProvider.playbackProgress,
                              waveformColor: themeProvider.waveformColour,
                              progressColor: themeProvider.waveformProgressColour,
                              progressBarColor: themeProvider.waveformProgressBarColour,
                            ),
                          ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Slider(
                      style: SliderThemeData(
                        useThumbBall: true,
                        thumbRadius: WidgetStateProperty.all(12.00),
                        activeColor: WidgetStateProperty.all(const Color.fromARGB(255, 67, 52, 235)),
                        inactiveColor: WidgetStateProperty.all(const Color.fromARGB(255, 105, 156, 12)),
                        thumbBallInnerFactor: WidgetStateProperty.fromMap({WidgetState.pressed: 0.8, WidgetState.hovered: 0.65}),
                      ),
                      value: mediaPlayerProvider.position.inMilliseconds.toDouble() / 1000,
                      autofocus: false,
                      min: 0,
                      max: mediaPlayerProvider.duration.inMilliseconds.toDouble() / 1000,
                      onChangeStart: (value) {
                        mediaPlayerProvider.setInteractingWithSlider(true);
                      },
                      onChanged: (value) {
                        mediaPlayerProvider.updatePosition(value);
                      },
                      onChangeEnd: (value) {
                        mediaPlayerProvider.setInteractingWithSlider(false);
                        mediaPlayerProvider.seekTo(Duration(seconds: value.toInt()));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArtwork(BuildContext context, MediaPlayerProvider mediaPlayerProvider) {
    if (mediaPlayerProvider.currentArtwork == null) {
      return _buildDefaultArtwork();
    } else {
      return GestureDetector(
        onDoubleTap: () {
          _showFullSizeArtwork(context, mediaPlayerProvider.currentArtwork!);
        },
        child: Container(
          width: 94.0,
          height: 94.0,
          color: Colors.white,
          child: Center(
            child: Image.memory(
              mediaPlayerProvider.currentArtwork!,
              fit: BoxFit.fill,
              errorBuilder: (context, error, stackTrace) {
                _logger.severe('Error displaying artwork: $error$stackTrace');
                return _buildDefaultArtwork();
              },
            ),
          ),
        ),
      );
    }
  }

  Widget _buildDefaultArtwork() {
    return ClipOval(
      child: Container(
        width: 94.0, // Reduced width to better fit the layout
        height: 94.0,
        color: Colors.white,
        child: Center(
          child: Image(
            image: defaultArtwork,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }

  void _showFullSizeArtwork(BuildContext context, Uint8List artwork) {
    // Show the dialog with the calculated dimensions
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ContentDialog(
          title: Text('Artwork'),
          constraints: BoxConstraints(maxWidth: 600, maxHeight: 900),
          content: Image.memory(
            artwork,
            fit: BoxFit.fill,
          ),
          actions: [
            Button(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Row _buildMediaButtons(MediaPlayerProvider mediaPlayerProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _createButton(FluentIcons.play, mediaPlayerProvider.play, mediaPlayerProvider.playerStatus == PlayerStatus.Paused ? 'Resume' : 'Play'),
        _createButton(
          mediaPlayerProvider.playerStatus == PlayerStatus.Paused ? FluentIcons.play_resume : FluentIcons.pause,
          mediaPlayerProvider.pause,
          mediaPlayerProvider.playerStatus == PlayerStatus.Paused ? 'Resume' : 'Pause',
        ),
        _createButton(FluentIcons.stop, mediaPlayerProvider.stop, 'Stop'),
      ],
    );
  }

  Widget _createButton(IconData icon, Function() action, String tooltip) {
    return Tooltip(
      message: tooltip,
      style: TooltipThemeData(
        padding: EdgeInsets.fromLTRB(3, 0, 3, 2),
        height: 2,
        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
      ),
      child: IconButton(
        icon: Icon(icon),
        onPressed: action,
      ),
    );
  }
}

String formatPlayPosition(int milliseconds) {
  int hours = milliseconds ~/ 3600000;
  int minutes = (milliseconds % 3600000) ~/ 60000;
  int seconds = (milliseconds % 60000) ~/ 1000;
  int millis = (milliseconds % 1000) ~/ 100;

  if (hours > 0) {
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}.${millis.toString().padLeft(1, '0')}';
  } else {
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}.${millis.toString().padLeft(1, '0')}';
  }
}
