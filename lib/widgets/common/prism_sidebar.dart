import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

class PrismNavItem {
  final IconData icon;
  final String label;
  const PrismNavItem({required this.icon, required this.label});
}

/// PRISM's shared desktop sidebar, mirroring AdminShell's sidebar header
/// treatment (gradient "X" + wordmark). COPIED structure from
/// prism_appbloc's widgets/common/prism_sidebar.dart; PRISM AUTO passes its
/// own nav items (Upload, Library, Billing) and appends "AUTO" to the
/// lockup per Section 2.
class PrismSidebar extends StatelessWidget {
  final List<PrismNavItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final Widget? footer;

  const PrismSidebar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelect,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSpacing.sidebarWidth,
      color: AppColors.bgVoid,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
            child: Row(
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => AppColors.spectrumGradient.createShader(bounds),
                  child: Text('X ', style: AppTextStyles.pageTitle.copyWith(fontSize: 22, color: Colors.white)),
                ),
                Flexible(
                  child: RichText(
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(children: [
                      TextSpan(text: 'PRISM', style: AppTextStyles.pageTitle.copyWith(fontSize: 18)),
                      TextSpan(text: ' AUTO', style: AppTextStyles.pageTitle.copyWith(fontSize: 18, color: AppColors.textSilver)),
                    ]),
                  ),
                ),
              ],
            ),
          ),
          for (int i = 0; i < items.length; i++)
            _NavRow(item: items[i], selected: i == selectedIndex, onTap: () => onSelect(i)),
          const Spacer(),
          if (footer != null) Padding(padding: const EdgeInsets.all(16), child: footer),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _NavRow extends StatelessWidget {
  final PrismNavItem item;
  final bool selected;
  final VoidCallback onTap;

  const _NavRow({required this.item, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final Color color = selected ? AppColors.cyan : AppColors.textSilver;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          decoration: BoxDecoration(
            border: Border(left: BorderSide(color: selected ? AppColors.cyan : Colors.transparent, width: 2)),
            color: selected ? AppColors.bgSurface : Colors.transparent,
          ),
          child: Row(
            children: [
              Icon(item.icon, size: 18, color: color),
              const SizedBox(width: 12),
              Text(item.label, style: AppTextStyles.navItem.copyWith(color: color)),
            ],
          ),
        ),
      ),
    );
  }
}

/// PRISM's shared bottom nav for mobile widths, mirroring the
/// LayoutBuilder + AppSpacing.mobileBreakpoint switch used in AdminShell.
class PrismBottomNav extends StatelessWidget {
  final List<PrismNavItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const PrismBottomNav({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bgVoid,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for (int i = 0; i < items.length; i++)
            InkWell(
              onTap: () => onSelect(i),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(items[i].icon, size: 20, color: i == selectedIndex ? AppColors.cyan : AppColors.textDim),
                  const SizedBox(height: 4),
                  Text(
                    items[i].label,
                    style: AppTextStyles.dataLabel.copyWith(
                      color: i == selectedIndex ? AppColors.cyan : AppColors.textDim,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
