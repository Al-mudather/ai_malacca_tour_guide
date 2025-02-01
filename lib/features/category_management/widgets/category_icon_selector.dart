import 'package:flutter/material.dart';

class CategoryIcon {
  final String name;
  final IconData icon;
  final String code;

  const CategoryIcon({
    required this.name,
    required this.icon,
    required this.code,
  });
}

class CategoryIconSelector extends StatefulWidget {
  final String? initialValue;
  final ValueChanged<String> onChanged;

  const CategoryIconSelector({
    super.key,
    this.initialValue,
    required this.onChanged,
  });

  static const List<CategoryIcon> predefinedIcons = [
    CategoryIcon(
      name: 'General',
      icon: Icons.category,
      code: '0xe148', // Icons.category code
    ),
    CategoryIcon(
      name: 'Restaurant',
      icon: Icons.restaurant,
      code: '0xe532', // Icons.restaurant code
    ),
    CategoryIcon(
      name: 'Hotel',
      icon: Icons.hotel,
      code: '0xe331', // Icons.hotel code
    ),
    CategoryIcon(
      name: 'Tourism',
      icon: Icons.tour,
      code: '0xf05c', // Icons.tour code
    ),
    CategoryIcon(
      name: 'Museum',
      icon: Icons.museum,
      code: '0xf05c', // Icons.museum code
    ),
    CategoryIcon(
      name: 'Shopping',
      icon: Icons.shopping_bag,
      code: '0xe59a', // Icons.shopping_bag code
    ),
  ];

  @override
  State<CategoryIconSelector> createState() => _CategoryIconSelectorState();
}

class _CategoryIconSelectorState extends State<CategoryIconSelector> {
  late String selectedCode;

  @override
  void initState() {
    super.initState();
    selectedCode =
        widget.initialValue ?? CategoryIconSelector.predefinedIcons[0].code;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            'Select Category Icon',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Container(
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: CategoryIconSelector.predefinedIcons.map((iconData) {
                final isSelected = selectedCode == iconData.code;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        selectedCode = iconData.code;
                      });
                      widget.onChanged(iconData.code);
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 80,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Theme.of(context).primaryColor.withOpacity(0.1)
                            : Colors.transparent,
                        border: Border.all(
                          color: isSelected
                              ? Theme.of(context).primaryColor
                              : Colors.grey.shade300,
                          width: isSelected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            iconData.icon,
                            size: 32,
                            color: isSelected
                                ? Theme.of(context).primaryColor
                                : Colors.grey.shade600,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            iconData.name,
                            style: TextStyle(
                              fontSize: 12,
                              color: isSelected
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey.shade600,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
