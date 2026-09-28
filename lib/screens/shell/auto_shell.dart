import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/common/prism_sidebar.dart';
import '../upload/upload_screen.dart';
import '../library/library_screen.dart';
import '../billing/plans_billing_screen.dart';

/// AutoShell mirrors AdminShell's exact structure: sidebar on desktop,
/// bottom nav on mobile, switching at AppSpacing.mobileBreakpoint via
/// LayoutBuilder. Nav items are PRISM AUTO's own: Upload, Library, Billing.
/// Library is home base for returning users (Screen 7).
class AutoShell extends StatefulWidget {
  const AutoShell({super.key});

  @override
  State<AutoShell> createState() => _AutoShellState();
}

class _AutoShellState extends State<AutoShell> {
  int _selectedIndex = 1;

  static const _items = [
    PrismNavItem(icon: Icons.upload_file_outlined, label: 'Upload'),
    PrismNavItem(icon: Icons.video_library_outlined, label: 'Library'),
    PrismNavItem(icon: Icons.credit_card_outlined, label: 'Billing'),
  ];

  static const _screens = <Widget>[
    UploadScreen(),
    LibraryScreen(),
    PlansBillingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < AppSpacing.mobileBreakpoint;

        if (isMobile) {
          return Scaffold(
            backgroundColor: AppColors.bgPrimary,
            body: SafeArea(
              child: IndexedStack(index: _selectedIndex, children: _screens),
            ),
            bottomNavigationBar: PrismBottomNav(
              items: _items,
              selectedIndex: _selectedIndex,
              onSelect: (i) => setState(() => _selectedIndex = i),
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.bgPrimary,
          body: Row(
            children: [
              PrismSidebar(
                items: _items,
                selectedIndex: _selectedIndex,
                onSelect: (i) => setState(() => _selectedIndex = i),
                footer: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(color: AppColors.cyan, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 8),
                    Text('READY', style: AppTextStyles.dataLabel),
                  ],
                ),
              ),
              Expanded(
                child: IndexedStack(index: _selectedIndex, children: _screens),
              ),
            ],
          ),
        );
      },
    );
  }
}
