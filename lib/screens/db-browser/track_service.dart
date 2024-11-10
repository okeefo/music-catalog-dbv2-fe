import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'track_model.dart';
import '../../services/db_service.dart';

class TrackService {
  static Future<List<Track>> fetchTracks(int offset, int limit) async {

    final dbService = DbService();
    final response = await dbService.getTracks(offset, limit);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((track) => Track.fromJson(track)).toList();
    } else {
      throw Exception('Failed to load tracks');
    }
  }

  static Future<void> scanForMusic(BuildContext context, List<String> statusUpdates, WebSocketChannel? channel) async {
    String? directoryPath = await FilePicker.platform.getDirectoryPath();
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    if (directoryPath != null) {
      if (channel == null) {
        channel = WebSocketChannel.connect(Uri.parse('ws://localhost:8080/ws'));

        channel.stream.listen((message) {
          final decodedMessage = jsonDecode(message);
          final code = decodedMessage['code'];
          final msg = decodedMessage['message'];

          if (code == 'UPDATE') {
            statusUpdates.add(msg);
          } else if (code == 'INFO') {
            statusUpdates.add(msg.replaceAll('\n', ' - '));
            showDialog(
              context: context,
              builder: (context) => ContentDialog(
                title: Row(
                  children: [
                    Icon(FluentIcons.info, color: themeProvider.iconColour, size: themeProvider.iconSizeLarge),
                    const SizedBox(width: 8),
                    const Text('Scan Completed'),
                  ],
                ),
                content: Text(msg),
                actions: [
                  Button(
                    child: const Text('OK'),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            );
          } else if (code == 'ERROR') {
            statusUpdates.add(msg.replaceAll('\n', ' - '));
            showDialog(
              context: context,
              builder: (context) => ContentDialog(
                title: Row(
                  children: [
                    Icon(FluentIcons.error, color: themeProvider.iconColour, size: themeProvider.iconSizeLarge),
                    const SizedBox(width: 8),
                    const Text('Error'),
                  ],
                ),
                content: Text(msg),
                actions: [
                  Button(
                    child: const Text('OK'),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            );
          }
        });
      }

      final dbService = DbService();
      final response = await dbService.scanForMusic(directoryPath);

      if (response.statusCode != 200) {
        showDialog(
          context: context,
          builder: (context) => ContentDialog(
            title: Row(
              children: [
                Icon(FluentIcons.error, color: themeProvider.iconColour, size: themeProvider.iconSizeLarge),
                const SizedBox(width: 8),
                const Text('Error'),
              ],
            ),
            content: Text('Failed to initiate scan: ${response.body}'),
            actions: [
              Button(
                child: const Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      }
    }
  }
}