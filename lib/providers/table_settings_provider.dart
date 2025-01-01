import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logging/logging.dart';

class TableSettingsProvider with ChangeNotifier {
  final Logger _logger = Logger('TableSettingsProvider');
  List<double> _columnWidths = [];

  List<double> get columnWidths => _columnWidths;

  Future<void> loadColumnWidths(int defaultSize) async {
    _columnWidths = List.filled(defaultSize, 0.0);

    final prefs = await SharedPreferences.getInstance();

    final columnWidthsString = prefs.getStringList('columnWidths') ?? [];

    _columnWidths = columnWidthsString.map((width) => double.tryParse(width) ?? 0.0).toList();

    _logger.info('Loaded column widths: $_columnWidths');
    notifyListeners();
  }

  Future<void> saveColumnWidths(List<double> columnWidths) async {
    final prefs = await SharedPreferences.getInstance();
    final columnWidthsString = columnWidths.map((width) => width.toString()).toList();
    await prefs.setStringList('columnWidths', columnWidthsString);
    _columnWidths = columnWidths;
//    _logger.info('Saved column widths: $_columnWidths');
    notifyListeners();
  }

  void updateColumnWidth(int index, double width) {
   // _logger.info('Updating column width: index: $index, width: $width');
    if (index >= 0) {
      if (index >= _columnWidths.length) {
        _columnWidths.length = index + 1; // Ensure the list is long enough
      }
      _columnWidths[index] = width;
//_logger.info('Updated column width: index: $index, width: $width');
      saveColumnWidths(_columnWidths);
    }
  }
}
