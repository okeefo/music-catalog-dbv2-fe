import 'package:flutter/material.dart' as material;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:url_launcher/url_launcher.dart';

class ResizableTable extends StatefulWidget {
  final List<ResizeColumn> headers;
  final List<List<String>> data;
  final material.TextStyle rowStyle;
  final material.TextStyle headerStyle;
  final Map<int, ColumnAction> columnActions;
  final bool showAutoNumbering;

  const ResizableTable({
    super.key,
    required this.headers,
    required this.data,
    required this.rowStyle,
    required this.headerStyle,
    required this.columnActions,
    this.showAutoNumbering = true,
  });

  @override
  ResizableTableState createState() => ResizableTableState();
}

class ResizableTableState extends State<ResizableTable> {
  late List<double> columnWidths;

  @override
  void initState() {
    super.initState();
    columnWidths = List<double>.filled(widget.headers.length + (widget.showAutoNumbering ? 1 : 0), 0.0);
    columnWidths = _calculateColumnWidths();
  }

  @override
  void didUpdateWidget(covariant ResizableTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data || oldWidget.showAutoNumbering != widget.showAutoNumbering) {
      setState(() {
        columnWidths = _calculateColumnWidths();
      });
    }
  }

  List<double> _calculateColumnWidths() {
    final textPainter = material.TextPainter(
      textDirection: material.TextDirection.ltr,
    );

    List<double> widths = List<double>.filled(widget.headers.length + (widget.showAutoNumbering ? 1 : 0), 0.0);

    if (widget.showAutoNumbering) {
      // Measure auto-numbering column width
      textPainter.text = material.TextSpan(text: '#', style: widget.headerStyle);
      textPainter.layout();
      widths[0] = (textPainter.width + 25.0).ceilToDouble(); // 8.0 padding on each side
    }

    for (int i = 0; i < widget.headers.length; i++) {
      if (!widget.headers[i].isVisible) {
        widths[i + (widget.showAutoNumbering ? 1 : 0)] = 0.0;
        continue;
      }
      // Measure header width
      textPainter.text = material.TextSpan(text: widget.headers[i].name, style: widget.headerStyle);
      textPainter.layout();
      widths[i + (widget.showAutoNumbering ? 1 : 0)] = (textPainter.width + 25.0).ceilToDouble(); // 8.0 padding on each side

      // Measure each cell in the column
      for (var row in widget.data) {
        textPainter.text = material.TextSpan(text: row[i], style: widget.rowStyle);
        textPainter.layout();
        if (textPainter.width + 25.0 > widths[i + (widget.showAutoNumbering ? 1 : 0)]) {
          widths[i + (widget.showAutoNumbering ? 1 : 0)] = (textPainter.width + 25.0).ceilToDouble(); // 8.0 padding on each side
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
              children: List.generate(widget.headers.length + (widget.showAutoNumbering ? 1 : 0), (index) {
                if (widget.showAutoNumbering && index == 0) {
                  return _buildAutoNumberingHeader();
                }
                if (!widget.headers[index - (widget.showAutoNumbering ? 1 : 0)].isVisible) {
                  return Container(); // Skip rendering the header if not visible
                }
                return _buildResizableColumn(index - (widget.showAutoNumbering ? 1 : 0), widget.headers[index - (widget.showAutoNumbering ? 1 : 0)].name);
              }),
            ),
            ...widget.data.asMap().entries.map((entry) {
              int rowIndex = entry.key;
              List<String> row = entry.value;
              return Row(
                children: List.generate(row.length + (widget.showAutoNumbering ? 1 : 0), (index) {
                  if (widget.showAutoNumbering && index == 0) {
                    return _buildAutoNumberingCell(rowIndex);
                  }
                  if (!widget.headers[index - (widget.showAutoNumbering ? 1 : 0)].isVisible) {
                    return Container(); // Skip rendering the cell if the column is not visible
                  }
                  return _buildCell(index - (widget.showAutoNumbering ? 1 : 0), row[index - (widget.showAutoNumbering ? 1 : 0)], row);
                }).toList(),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildAutoNumberingHeader() {
    return Container(
      width: columnWidths[0],
      padding: const EdgeInsets.all(8.0),
      child: SelectableText(
        '#',
        style: widget.headerStyle,
      ),
    );
  }

  Widget _buildAutoNumberingCell(int rowIndex) {
    return Container(
      width: columnWidths[0],
      padding: const EdgeInsets.all(8.0),
      child: SelectableText(
        (rowIndex + 1).toString(),
        style: widget.rowStyle,
      ),
    );
  }

  Widget _buildResizableColumn(int index, String header) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        setState(() {
          columnWidths[index + (widget.showAutoNumbering ? 1 : 0)] += details.delta.dx;
        });
      },
      child: Container(
        width: columnWidths[index + (widget.showAutoNumbering ? 1 : 0)],
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(child: SelectableText(header, style: widget.headerStyle)),
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
    final action = widget.columnActions[index];

    if (action == null) {
      return _buildTextCell(index, text);
    }

    switch (action.type) {
      case ColumnActionType.displayAsUrl:
      case ColumnActionType.displayAsFileUrl:
        final url = row[action.urlColumnIndex!];
        return _buildUrlCell(index, text, url, action.type == ColumnActionType.displayAsUrl);
      default:
        return _buildTextCell(index, text);
    }
  }

  Widget _buildTextCell(int index, String text) {
    return Container(
      width: columnWidths[index + (widget.showAutoNumbering ? 1 : 0)],
      padding: const EdgeInsets.all(8.0),
      child: SelectableText(
        text,
        style: widget.rowStyle,
      ),
    );
  }

  Widget _buildUrlCell(int index, String text, String url, bool isWebUrl) {
    return Tooltip(
      message: url,
      child: GestureDetector(
        onDoubleTap: isWebUrl
            ? () async {
                final uri = Uri.parse(url);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri);
                }
              }
            : null,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Container(
            width: columnWidths[index + (widget.showAutoNumbering ? 1 : 0)],
            padding: const EdgeInsets.all(8.0),
            child: SelectableText(
              text,
              style: widget.rowStyle.copyWith(
                decoration: material.TextDecoration.underline,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ResizeColumn {
  final String name;
  final int index;
  final bool isVisible;

  ResizeColumn({
    required this.name,
    required this.index,
    required this.isVisible,
  });

  ResizeColumn copyWith({
    String? displayName,
    int? index,
    bool? isVisible,
  }) {
    return ResizeColumn(
      name: displayName ?? this.name,
      index: index ?? this.index,
      isVisible: isVisible ?? this.isVisible,
    );
  }
}

enum ColumnActionType {
  displayAsUrl,
  displayAsFileUrl,
}

class ColumnAction {
  final ColumnActionType type;
  final int? urlColumnIndex;

  ColumnAction({
    required this.type,
    this.urlColumnIndex,
  });
}