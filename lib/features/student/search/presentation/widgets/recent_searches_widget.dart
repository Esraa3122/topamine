import 'package:flutter/material.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/style/fonts/font_family_helper.dart';
import 'package:test/features/student/search/presentation/widgets/search_for_data_icon.dart';

class RecentSearchesWidget extends StatelessWidget {
  const RecentSearchesWidget({
    required this.recentSearches,
    required this.onSearchTap,
    required this.onDeleteTap,
    super.key,
  });
  final List<String> recentSearches;
  final ValueChanged<String> onSearchTap;
  final ValueChanged<int> onDeleteTap;

  @override
  Widget build(BuildContext context) {
    if (recentSearches.isEmpty) {
      return const SearchForDataIcon();
    }

    return ListView.builder(
      itemCount: recentSearches.length,
      itemBuilder: (context, index) {
        final item = recentSearches[index];
        return ListTile(
          leading: Icon(Icons.history, color: context.color.textColor),
          title: TextApp(
            text: item,
            theme: TextStyle(color: context.color.textColor, fontFamily: FontFamilyHelper.cairoArabic,
                letterSpacing: 0.5),
          ),
          trailing: IconButton(
            icon: Icon(Icons.close, color: context.color.textColor),
            onPressed: () => onDeleteTap(index),
          ),
          onTap: () => onSearchTap(item),
        );
      },
    );
  }
}
