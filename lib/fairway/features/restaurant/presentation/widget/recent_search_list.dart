import 'package:fairway/export.dart';
import 'package:fairway/fairway/features/restaurant/presentation/widget/recent_search_tile.dart';

class RecentSearchList extends StatelessWidget {
  const RecentSearchList({
    required this.queries,
    required this.onTap,
    super.key,
  });

  final List<String> queries;
  final void Function(String query) onTap;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8, // Horizontal spacing between tiles
      runSpacing: 8, // Vertical spacing between rows
      children: queries.map((query) {
        return RecentSearchTile(
          query: query,
          onTap: () => onTap(query),
        );
      }).toList(),
    );
  }
}
