import 'package:flutter/material.dart';

const c1 = 0xFFFDFFFC, c3 = 0xFF374B4A;

// More Menu to display various options like Color, Sort, Share...
class appBarPopMenu extends StatelessWidget {
  final popupMenuButtonItems = const {
    1: {'name': 'Color', 'icon': Icons.color_lens},
    2: {'name': 'Sort by A-Z', 'icon': Icons.sort_by_alpha},
    3: {'name': 'Sort by Z-A', 'icon': Icons.sort_by_alpha},
    4: {'name': 'Share', 'icon': Icons.share},
    5: {'name': 'Delete', 'icon': Icons.delete},
  };
  final parentContext;
  final void Function(BuildContext, String) onSelectPopupmenuItem;

  appBarPopMenu({
    required this.parentContext,
    required this.onSelectPopupmenuItem,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: const Icon(
        Icons.more_vert,
        color: Color(c1),
      ),
      color: const Color(c1),
      itemBuilder: (context) {
        var list = popupMenuButtonItems.entries.map((entry) {
          return PopupMenuItem(
            value: entry.key,
            child: Container(
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width * 0.3,
              ),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Icon(
                      (entry.value['icon'] ?? '') as IconData?,
                      color: const Color(c3),
                    ),
                  ),
                  Text(
                    (entry.value['name'] ?? '') as String,
                    style: const TextStyle(
                      color: Color(c3),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList();
        return list;
      },
      onSelected: (value) {
        onSelectPopupmenuItem(parentContext,
            (popupMenuButtonItems[value]!['name'] ?? '') as String);
      },
    );
  }
}
