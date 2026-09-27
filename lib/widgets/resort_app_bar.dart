import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/app_theme.dart';

class ResortAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final bool showBookNow;
  final VoidCallback? onBookNow;

  const ResortAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
    this.showBookNow = false,
    this.onBookNow,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64 + MediaQuery.of(context).padding.top,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: 20,
        right: 16,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceLow.withOpacity(0.85),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 24,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Logo
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl:
                  'https://lh3.googleusercontent.com/aida/AEtjO1VN0v8VTYBldPyDxM0th7kaWBgoyAVap4HRVYRjmBEcczxry-G6lFhkvkHosQGOQX8azBdZe1OqqBJjid73kP9iSb4kMWJz8Vpw2VuGkVMRR9eDguTkLl-8knUbGI1pdz1pc9lt6n4Ot4HKEMR3HYsAbjvdo0uTajK6g2njB6NSD6hY-YA8ejMaac_SoJIqnmhOhHtv_zdN8jwFGvky1YOzKsjNbxpTSxD02yrcatSmN8Ywz7AKmDkY2jb-',
              width: 32,
              height: 32,
              fit: BoxFit.cover,
              errorWidget: (_, __, ___) => Container(
                width: 32, height: 32,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF092E20), Color(0xFF0F4A34)],
                  ),
                ),
                child: const Center(
                  child: Text('A&D',
                      style: TextStyle(
                          color: Color(0xFFFFB95F),
                          fontSize: 8,
                          fontWeight: FontWeight.w700)),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Title column
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subtitle ?? 'A&D Thysia Resort',
                  style: AppText.labelSm.copyWith(
                    color: AppColors.secondary,
                    letterSpacing: 1.0,
                  ),
                ),
                Text(
                  title,
                  style: AppText.titleMd,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Actions
          if (showBookNow) ...[
            GestureDetector(
              onTap: onBookNow,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.secondary.withOpacity(0.25),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_month,
                        size: 16, color: Color(0xFF472A00)),
                    const SizedBox(width: 4),
                    Text('Book Now',
                        style: AppText.labelMd
                            .copyWith(color: const Color(0xFF472A00))),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          if (actions != null) ...actions!,
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary,
            ),
            child: const Icon(Icons.person,
                size: 18, color: AppColors.onPrimary),
          ),
        ],
      ),
    );
  }
}
