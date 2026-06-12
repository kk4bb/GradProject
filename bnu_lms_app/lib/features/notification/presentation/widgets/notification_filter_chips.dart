import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../shared/providers/theme_provider.dart';
import '../../../../shared/resources/colors_manager.dart';

class NotificationFilterChips extends StatelessWidget {
  final List<String> filters;
  final String selectedFilter;
  final Function(String) onFilterChanged;

  const NotificationFilterChips({
    super.key,
    required this.filters,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkTheme();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: filters.map((filter) {
          final isSelected = filter == selectedFilter;
          return Padding(
            padding: EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onFilterChanged(filter),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? ColorsManager.blue
                      : (isDarkMode ? ColorsManager.darkBackground : ColorsManager.white),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected 
                        ? Colors.transparent 
                        : (isDarkMode ? ColorsManager.darkSurface : const Color(0xFFE2E8F0)),
                  ),
                ),
                child: Text(
                  filter,
                  style: TextStyle(
                    color: isSelected 
                        ? ColorsManager.white
                        : (isDarkMode ? ColorsManager.darkTextPrimary : ColorsManager.grayDark),
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
