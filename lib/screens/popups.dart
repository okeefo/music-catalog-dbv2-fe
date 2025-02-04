import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'package:front_end/providers/theme_provider.dart';

void showInfoDialog(BuildContext context, String message, String title) {
  final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

  showDialog(
    context: context,
    builder: (context) => ContentDialog(
      title: Row(
        children: [
          Icon(FluentIcons.info, color: themeProvider.iconColour, size: themeProvider.iconSizeLarge),
          const SizedBox(width: 8),
          Text("Info: $title"),
        ],
      ),
      content: Text(message),
      actions: [
        Button(
          child: const Text('OK'),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    ),
  );
}

Future<bool?> showConfirmDialog(BuildContext context, String message, String title) {
  final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

  return showDialog<bool>(
    context: context,
    builder: (context) => ContentDialog(
      title: Row(
        children: [
          Icon(FluentIcons.info, color: themeProvider.iconColour, size: themeProvider.iconSizeLarge),
          const SizedBox(width: 8),
          Text("Info: $title"),
        ],
      ),
      content: Text(message),
      actions: [
        Button(
          child: const Text('Yes'),
          onPressed: () => Navigator.pop(context, true),
        ),
        Button(
          child: const Text('No'),
          onPressed: () => Navigator.pop(context, false),
        ),
      ],
    ),
  );
}

void showErrorDialog(BuildContext context, String message, String title) {
  final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

  showDialog(
    context: context,
    builder: (context) => ContentDialog(
      constraints: const BoxConstraints(maxWidth: 500),
      title: Row(
        children: [
          Icon(FluentIcons.error, color: themeProvider.iconColour, size: themeProvider.iconSizeLarge),
          const SizedBox(width:8),
          Text("Error: $title"),
        ],
      ),
      content: Text(message),
      actions: [
        Button(
          child: const Text('OK'),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    ),
  );
}
