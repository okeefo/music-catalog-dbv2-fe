import 'package:flutter/material.dart' as material;
import 'package:fluent_ui/fluent_ui.dart';

class ResizableTable extends StatefulWidget {
  final List<String> headers;
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
      // Measure header width
      textPainter.text = material.TextSpan(text: widget.headers[i], style: widget.headerStyle);
      textPainter.layout();
      widths[i] = textPainter.width + 40.0; // 8.0 padding on each side

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
                return _buildResizableColumn(index, widget.headers[index]);
              }),
            ),
            ...widget.data.map((row) {
              return Row(
                children: List.generate(row.length, (index) {
                  return Container(
                    width: columnWidths[index],
                    padding: const EdgeInsets.all(8.0),
                    child: Text(row[index], style: widget.rowStyle),
                  );
                }).toList(),
              );
            }),
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
            const Icon(material.Icons.drag_handle),
          ],
        ),
      ),
    );
  }
}