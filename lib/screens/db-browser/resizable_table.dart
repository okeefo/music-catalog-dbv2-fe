import 'package:fluent_ui/fluent_ui.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:logging/logging.dart';

class ResizableTable extends StatefulWidget {
  final List<ResizeColumn> headers;
  final List<List<String>> data;
  final TextStyle rowStyle;
  final TextStyle altRowStyle;
  final TextStyle headerStyle;
  final Map<int, ColumnAction> columnActions;
  final bool showAutoNumbering;
  final void Function(BuildContext context, Offset position, int columnIndex, int rowIndex, TapDownDetails d)? onRightClick;
  final ScrollController infiniteScrollController;
  final BoxDecoration columnDecoration;
  final BoxDecoration rowDecoration;
  final BoxDecoration altRowDecoration;
  final int altRowColumnIndex;
  final EdgeInsets cellPadding =  EdgeInsets.fromLTRB(8, 4.0, 0.0, 4.0);

  ResizableTable(
      {super.key,
      required this.headers,
      required this.data,
      required this.rowStyle,
      required this.altRowStyle,
      required this.headerStyle,
      required this.columnActions,
      this.showAutoNumbering = true,
      this.onRightClick,
      required this.infiniteScrollController,
      required this.columnDecoration,
      required this.rowDecoration,
      required this.altRowDecoration,
      required this.altRowColumnIndex,
      });

  @override
  ResizableTableState createState() => ResizableTableState();
}

class ResizableTableState extends State<ResizableTable> {
  late List<double> minColumnWidths;
  late List<double> columnWidths;
  late double autoNumberColumnWidth;
  final Logger _logger = Logger('DbBrowserPageState');

  @override
  void initState() {
    super.initState();
    minColumnWidths = List<double>.generate(widget.headers.length, (i) => _calculateMinColumnWidth(i));
    columnWidths = List<double>.generate(widget.headers.length, (i) => _calculateMaxColumnWidth(i));
    autoNumberColumnWidth = _calculateAutoNumberColumnWidth();
  }

  @override
  void didUpdateWidget(covariant ResizableTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data.isEmpty && widget.data.isNotEmpty) {
      setState(() {
        columnWidths = List<double>.generate(widget.headers.length, (i) => _calculateMaxColumnWidth(i));
      });
    }
  }

  void _resizeColumn(int index) {
    setState(() {
      columnWidths[index] = _calculateMaxColumnWidth(index);
    });
  }

  double _calculateAutoNumberColumnWidth() {
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    // auto number column width  is fixed width of f 99999 records (5 digits)
    if (widget.showAutoNumbering) {
      // Measure auto-numbering column width
      textPainter.text = TextSpan(text: '9999', style: widget.headerStyle);
      textPainter.layout();
      return (textPainter.width + 25.0).ceilToDouble(); // 8.0 padding on each side
    }
    return 0.0;
  }

  double _calculateMinColumnWidth(int index) {
    if (!widget.headers[index].isVisible) {
      return 2.0;
    }
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    // Measure header width
    textPainter.text = TextSpan(text: widget.headers[index].name, style: widget.headerStyle);
    textPainter.layout();
    double width = (textPainter.width + 30.0).ceilToDouble(); // extra padding to include the icon for dragging
    return width;
  }

  double _calculateMaxColumnWidth(int index) {
    if (!widget.headers[index].isVisible) {
      return 2.0;
    }

    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    double width = minColumnWidths[index]; // extra padding to include the icon for dragging

    // Measure each cell in the column
    for (var row in widget.data) {
      textPainter.text = TextSpan(text: row[index], style: widget.rowStyle);
      textPainter.layout();
      if (textPainter.width + 25.0 > width) {
        width = (textPainter.width + 25.0).ceilToDouble();
      }
    }
    return width;
  }

  TextStyle _determineRowStyle(int rowIndex, TextStyle currentStyle) {
    if (rowIndex == 0) {
      return currentStyle;
    }

    final currentGroupValue = widget.data[rowIndex][widget.altRowColumnIndex];
    final previousGroupValue = widget.data[rowIndex - 1][widget.altRowColumnIndex];

    if (currentGroupValue != previousGroupValue) {
      return currentStyle == widget.rowStyle ? widget.altRowStyle : widget.rowStyle;
    }

    return currentStyle;
  }

  @override
  Widget build(BuildContext context) {
    bool showAutoNumbering = widget.showAutoNumbering;
    TextStyle rowStyle = widget.rowStyle;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate the total width of the columns
        double totalColumnsWidth = columnWidths.fold(0.0, (sum, width) => sum + width);
        if (showAutoNumbering) {
          totalColumnsWidth += autoNumberColumnWidth; // Add width for auto-numbering column if applicable
        }
        double calculatedWidth = totalColumnsWidth > constraints.maxWidth ? totalColumnsWidth : constraints.maxWidth;

        _logger.info('Constraints Max Width: ${constraints.maxWidth}');
        _logger.info('Total Columns Width: $totalColumnsWidth');
        _logger.info('Calculated Width: $calculatedWidth');

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            height: MediaQuery.of(context).size.height - 200,
            width: calculatedWidth,
            child: Column(
              children: [
                // Header Row
                Row(
                  children: List.generate(widget.headers.length + 1, (colIndex) {
                    // Existing code for building header cells
                    if (colIndex == 0) {
                      return showAutoNumbering ? _buildAutoNumberingHeader() : Container();
                    } else if (!widget.headers[colIndex - 1].isVisible) {
                      return Container();
                    }
                    return _buildResizableColumnHeader(colIndex - 1, widget.headers[colIndex - 1].name);
                  }),
                ),
                // Scrollable Data Rows
                Expanded(
                  child: ListView.builder(
                    controller: widget.infiniteScrollController,
                    itemCount: widget.data.length,
                    itemBuilder: (context, index) {
                      int rowIndex = index;
                      rowStyle = _determineRowStyle(rowIndex, rowStyle);
                      List<String> row = widget.data[rowIndex];
                      return Row(
                        children: List.generate(row.length + 1, (colIndex) {
                          if (colIndex == 0) {
                            return showAutoNumbering ? _buildAutoNumberingCell(rowIndex, rowStyle) : Container();
                          } else if (!widget.headers[colIndex - 1].isVisible) {
                            return Container();
                          }
                          return _buildCell(colIndex - 1, row[colIndex - 1], row, rowIndex, rowStyle);
                        }),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAutoNumberingHeader() {
    return Container(
      width: autoNumberColumnWidth,
      padding: const EdgeInsets.all(8.0),
      decoration: widget.columnDecoration,
      child: SelectableText(
        '#',
        textAlign: TextAlign.right,
        style: widget.headerStyle,
      ),
    );
  }

  Widget _buildAutoNumberingCell(int rowIndex, TextStyle rowStyle) {
    return Container(
      width: autoNumberColumnWidth,
      padding: widget.cellPadding,
      decoration: rowStyle == widget.rowStyle ? widget.rowDecoration : widget.altRowDecoration,
      child: SelectableText(
        (rowIndex + 1).toString(),
        textAlign: TextAlign.right,
        style: rowStyle,
      ),
    );
  }

  Widget _buildResizableColumnHeader(int index, String header) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        setState(() {
          if (columnWidths[index] + details.delta.dx < minColumnWidths[index]) {
            return;
          }
          columnWidths[index] += details.delta.dx;
        });
      },
      onDoubleTap: () {
        setState(() {
          _resizeColumn(index);
        });
      },
      child: Container(
        width: columnWidths[index],
        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 4.0, 8.0),
        decoration: widget.columnDecoration,
        child: Row(
          children: [
            Expanded(child: SelectableText(header, style: widget.headerStyle)),
            MouseRegion(
              cursor: SystemMouseCursors.resizeColumn,
              child: Container(
                width: 10.0,
                color: Colors.transparent,
                child: Icon(
                  FluentIcons.gripper_bar_vertical,
                  size: widget.headerStyle.fontSize,
                  color: widget.headerStyle.color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCell(int colIndex, String text, List<String> row, int rowIndex, TextStyle rowStyle) {
    final action = widget.columnActions[colIndex];

    if (action == null) {
      return _buildTextCell(colIndex, text, rowIndex, rowStyle);
    }

    switch (action.type) {
      case ColumnActionType.displayAsUrl:
      case ColumnActionType.displayAsFileUrl:
        final url = row[action.urlColumnIndex!];
        return _buildUrlCell(colIndex, text, url, action.type == ColumnActionType.displayAsUrl, rowIndex, rowStyle);
      default:
        return _buildTextCell(colIndex, text, rowIndex, rowStyle);
    }
  }

  Widget _buildTextCell(int index, String text, int rowIndex, TextStyle rowStyle) {
    return GestureDetector(
      onSecondaryTapDown: (details) {
        if (widget.onRightClick != null) {
          widget.onRightClick!(context, details.globalPosition, index, rowIndex, details);
        }
      },
      child: Tooltip(
        message: text,
        child: Container(
          width: columnWidths[index],
          padding: widget.cellPadding, 
          decoration: rowStyle == widget.rowStyle ? widget.rowDecoration : widget.altRowDecoration,
          child: Text(
            text,
            style: rowStyle,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
          ),
        ),
      ),
    );
  }

  Widget _buildUrlCell(int index, String text, String url, bool isWebUrl, int rowIndex, TextStyle rowStyle) {
    return GestureDetector(
      onSecondaryTapDown: (details) {
        if (widget.onRightClick != null) {
          widget.onRightClick!(context, details.globalPosition, index, rowIndex, details);
        }
      },
      child: Tooltip(
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
              width: columnWidths[index],
              padding:  widget.cellPadding, 
              decoration: rowStyle == widget.rowStyle ? widget.rowDecoration : widget.altRowDecoration,
              child: Text(
                text,
                style: rowStyle.copyWith(
                  decoration: TextDecoration.underline,
                ),
                overflow: TextOverflow.ellipsis,
                softWrap: false,
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
      name: displayName ?? name,
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
