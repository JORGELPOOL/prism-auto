import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/processing/processing_bloc.dart';
import '../../blocs/processing/processing_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/common/prism_sidebar.dart';
import '../processing/processing_screen.dart';
import '../upload/upload_screen.dart';
import '../library/library_screen.dart';
import '../billing/plans_billing_screen.dart';

/// AutoShell mirrors AdminShell's exact structure: sidebar on desktop,
/// bottom nav on mobile, switching at AppSpacing.mobileBreakpoint via
/// LayoutBuilder. Nav items are PRISM AUTO's own: Upload, Library, Billing.
///
/// Also hosts the "safe to navigate away" persistent indicator the spec
/// calls for on Screen 2: a Cyan dot + "PROCESSING" while the app-level
/// ProcessingBloc has an upload in flight, tappable to jump back to that
/// screen; otherwise a plain "READY" dot.
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

  Widget _statusChip(BuildContext context) {
    return BlocBuilder<ProcessingBloc, ProcessingState>(
      builder: (context, state) {
        if (state is ProcessingInProgress) {
          return InkWell(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => ProcessingScreen(uploadId: state.uploadId),
            )),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppColors.cyan, shape: BoxShape.circle)),
                const SizedBox(width: 8),
                Text('PROCESSING', style: AppTextStyles.dataLabel.copyWith(color: AppColors.cyan)),
              ],
            ),
          );
        }
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppColors.mint, shape: BoxShape.circle)),
            const SizedBox(width: 8),
            Text('READY', style: AppTextStyles.dataLabel),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < AppSpacing.mobileBreakpoint;

        if (isMobile) {
          return Scaffold(
            backgroundColor: AppColors.bgPrimary,
            body: SafeArea(
              child: Column(
                children: [
                  BlocBuilder<ProcessingBloc, ProcessingState>(
                    builder: (context, state) {
                      if (state is! ProcessingInProgress) return const SizedBox.shrink();
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        color: AppColors.bgSurface,
                        child: _statusChip(context),
                      );
                    },
                  ),
                  Expanded(child: IndexedStack(index: _selectedIndex, children: _screens)),
                ],
              ),
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
                footer: _statusChip(context),
              ),
              Expanded(child: IndexedStack(index: _selectedIndex, children: _screens)),
            ],
          ),
        );
      },
    );
  }
}
