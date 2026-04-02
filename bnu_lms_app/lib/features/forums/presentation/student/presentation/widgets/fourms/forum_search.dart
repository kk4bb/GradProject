import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../l10n/app_localizations.dart';
import '../../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../../shared/resources/colors_manager.dart';



class ForumSearch extends StatelessWidget {
  final TextEditingController searchController;
  final VoidCallback onSearch;

  const ForumSearch(
      this.searchController,
      this.onSearch, {
        super.key,
      });

  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context)!;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: TextField(
        controller: searchController,
        onChanged: (value) => onSearch(),
        style: TextStyle(
          color: isLight ? ColorsManager.black : ColorsManager.darkTextPrimary,
          fontSize: 15,
        ),
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: isLight ? ColorsManager.grayMedium.withValues(alpha: 0.3) : ColorsManager.darkTextSecondary.withValues(alpha: 0.3),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: ColorsManager.blue,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: isLight ? ColorsManager.lightBackground : ColorsManager.darkSurface,
          hintText: localization.searchForums,
          hintStyle: TextStyle(
            color: isLight ? ColorsManager.grayMedium : ColorsManager.darkTextSecondary,
            fontSize: 15,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: isLight ? ColorsManager.grayMedium : ColorsManager.darkTextSecondary,
            size: 22,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }
}