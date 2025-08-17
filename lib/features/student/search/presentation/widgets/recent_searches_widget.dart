import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/style/images/app_images.dart';

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
      return Center(
        child: SizedBox(
          width: 130,
          height: 130,
          child: SvgPicture.asset(
            AppImages.search,
            color: Colors.grey.withOpacity(0.5),
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: recentSearches.length,
      itemBuilder: (context, index) {
        final item = recentSearches[index];
        return ListTile(
          leading: Icon(Icons.history, color: context.color.textColor),
          title: Text(item, style: TextStyle(color: context.color.textColor),),
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
