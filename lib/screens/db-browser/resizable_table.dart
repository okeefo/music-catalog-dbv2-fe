import 'package:flutter/material.dart' as material;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:front_end/screens/db-browser/track_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ResizableTable extends StatefulWidget {
  final List<TrackColumn> headers;
  final List<List<String>> data;
  final material.TextStyle rowStyle;
  final material.TextStyle headerStyle;

  const ResizableTable({
    super.key,
    required this.headers,
    required this.data,
    required this.rowStyle,
    required this.headerStyle,
  });

  @override
  ResizableTableState createState() => ResizableTableState();
}

class ResizableTableState extends State<ResizableTable> {
  late List<double> columnWidths;

  @override
  void initState() {
    super.initState();
    columnWidths = List<double>.filled(widget.headers.length, 0.0);
    columnWidths = _calculateColumnWidths();
  }

  @override
  void didUpdateWidget(covariant ResizableTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data) {
      setState(() {
        columnWidths = _calculateColumnWidths();
      });
    }
  }

  List<double> _calculateColumnWidths() {
    final textPainter = material.TextPainter(
      textDirection: material.TextDirection.ltr,
    );

    List<double> widths = List<double>.filled(widget.headers.length, 0.0);

    for (int i = 0; i < widget.headers.length; i++) {
      if (!widget.headers[i].isVisible) {
        widths[i] = 0.0;
        continue;
      }
      // Measure header width
      textPainter.text = material.TextSpan(text: widget.headers[i].name, style: widget.headerStyle);
      textPainter.layout();
      widths[i] = textPainter.width + 20.0; // 8.0 padding on each side

      // Measure each cell in the column
      for (var row in widget.data) {
        textPainter.text = material.TextSpan(text: row[i], style: widget.rowStyle);
        textPainter.layout();
        if (textPainter.width + 16.0 > widths[i]) {
          widths[i] = textPainter.width + 16.0; // 8.0 padding on each side
        }
      }
    }

    return widths;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Row(
              children: List.generate(widget.headers.length, (index) {
                if (!widget.headers[index].isVisible) {
                  return Container(); // Skip rendering the header if not visible
                }
                return _buildResizableColumn(index, widget.headers[index].name);
              }),
            ),
            ...widget.data.map((row) {
              return Row(
                children: List.generate(row.length, (index) {
                  if (!widget.headers[index].isVisible) {
                    return Container(); // Skip rendering the cell if the column is not visible
                  }
                  return _buildCell(index, row[index], row);
                }).toList(),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildResizableColumn(int index, String header) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        setState(() {
          columnWidths[index] += details.delta.dx;
        });
      },
      child: Container(
        width: columnWidths[index],
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(child: Text(header, style: widget.headerStyle)),
            Container(
              width: 2.0,
              height: 10.0,
              color: material.Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCell(int index, String text, List<String> row) {
    if (widget.headers[index] == TrackColumns.discogsId) {
      final url = row[TrackColumns.discogsUrl.index]; // Get the URL from the corresponding column
      return Tooltip(
        message: url,
        child: GestureDetector(
          onDoubleTap: () async {
            final uri = Uri.parse(url);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri);
            }
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Container(
              width: columnWidths[index],
              padding: const EdgeInsets.all(8.0),
              child: Text(
                text,
                style: widget.rowStyle.copyWith(
                  color: material.Colors.blue,
                  decoration: material.TextDecoration.underline,
                ),
              ),
            ),
          ),
        ),
      );
    }

    if (widget.headers[index] == TrackColumns.title) {
      final url = row[TrackColumns.fileLocation.index]; // Get the URL from the corresponding column
      return Tooltip(
        message: url,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Container(
            width: columnWidths[index],
            padding: const EdgeInsets.all(8.0),
            child: Text(
              text,
              style: widget.rowStyle.copyWith(
                color: material.Colors.blue,
                decoration: material.TextDecoration.underline,
              ),
            ),
          ),
        ),
      );
    }
    return Container(
      width: columnWidths[index],
      padding: const EdgeInsets.all(8.0),
      child: Text(text, style: widget.rowStyle),
    );
  }
}
