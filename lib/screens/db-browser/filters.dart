
import 'package:fluent_ui/fluent_ui.dart';

class FilterList extends StatelessWidget {
  final List<String> filters;
  final Function(String) onFilterTap;
  final Function(String) onFilterDoubleTap;

  const FilterList({
    super.key,
    required this.filters,
    required this.onFilterTap,
    required this.onFilterDoubleTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: filters.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => onFilterTap(filters[index]),
          onDoubleTap: () => onFilterDoubleTap(filters[index]),
          child: ListTile(
            title: Text(filters[index]),
          ),
        );
      },
    );
  }
}