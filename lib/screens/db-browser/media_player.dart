import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/providers/theme_provider.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

class MediaPlayer extends StatelessWidget {
  static final Logger _logger = Logger('MediaPlayer');
  static final spacer = const SizedBox(width: 2);
  const MediaPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 600), // Set a maximum width constraint
      child: SizedBox(
        height: 120.0, // Reduced height to better fit the layout
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipOval(
                  child: Container(
                    width: 94.0, // Reduced width to better fit the layout
                    height: 94.0,
                    color: Colors.white,
                    child: Center(
                      child: Image.asset(
                        'assets/vinyl-100.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),

                //spacer,
                _buildMedialButtons()
              ],
            ),
            spacer,
            Expanded(
              child: Container(
                height: double.infinity,
                color: themeProvider.greyBackground,
                child: Center(
                  child: Text(
                    'No Track Selected / Loaded',
                    style: TextStyle(color: themeProvider.fontColour, fontSize: themeProvider.fontSizeLarge), // Ensure color is not null
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row _buildMedialButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(FluentIcons.play),
          onPressed: () {
            _logger.info("Play button pressed");
          },
        ),
        IconButton(
          icon: Icon(FluentIcons.pause),
          onPressed: () {
            _logger.info("Pause button pressed");
          },
        ),
        IconButton(
          icon: Icon(FluentIcons.stop),
          onPressed: () {
            _logger.info("Stop button pressed");
          },
        ),
      ],
    );
  }
}
