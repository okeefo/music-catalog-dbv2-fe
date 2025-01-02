import 'package:fluent_ui/fluent_ui.dart';

class MediaPlayer extends StatelessWidget {
  const MediaPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 600), // Set a maximum width constraint
      child: Container(
        height: 100.0, // Reduced height to better fit the layout
        child: Row(
          children: [
            Container(
              width: 100.0, // Reduced width to better fit the layout
              height: double.infinity,
              color: Colors.grey,
              child: Center(
                child: Text(
                  'Artwork',
                  style: TextStyle(color: Colors.black), // Ensure color is not null
                ),
              ),
            ),
            const SizedBox(width: 16),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(FluentIcons.play),
                  onPressed: () {
                    print("Play button pressed");
                  },
                ),
                IconButton(
                  icon: Icon(FluentIcons.pause),
                  onPressed: () {
                    print("Pause button pressed");
                  },
                ),
                IconButton(
                  icon: Icon(FluentIcons.stop),
                  onPressed: () {
                    print("Stop button pressed");
                  },
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Container(
                height: double.infinity,
                color: Colors.grey, // Ensure color is not null
                child: Center(
                  child: Text(
                    'Waveform',
                    style: TextStyle(color: Colors.black), // Ensure color is not null
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}