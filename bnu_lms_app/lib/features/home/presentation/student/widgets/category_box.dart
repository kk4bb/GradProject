import 'package:flutter/material.dart';

import '../../../../../shared/resources/colors_manager.dart';


class CategoryBox extends StatelessWidget {
  final String imagePath;
  final String title;
  final bool isLight;
  final bool isArabic;
  final VoidCallback? onTap;

  const CategoryBox({super.key,
    required this.imagePath,
    required this.title,
    required this.isLight,
    required this.isArabic,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
          borderRadius: BorderRadius.circular(18.0),
          boxShadow: isLight
              ? [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ]
              : null,
          border: !isLight
              ? Border.all(
            color: ColorsManager.darkBackground.withValues(alpha: 0.2),
            width: 1,
          )
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isLight
                    ? ColorsManager.blue.withValues(alpha: 0.1)
                    : ColorsManager.blue.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Image.asset(
                imagePath,
                width: 32.0,
                height: 32.0,
                color: isLight ? ColorsManager.blue : ColorsManager.lightBlue,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.category,
                    size: 32.0,
                    color: isLight ? ColorsManager.blue : ColorsManager.lightBlue,
                  );
                },
              ),
            ),
            SizedBox(height: 12.0),
            Text(
              title,
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                color: isLight ? ColorsManager.black : ColorsManager.white,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}