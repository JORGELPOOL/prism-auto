import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/mock/auto_mock_data.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/plan_model.dart';
import '../../repositories/auto_repository.dart';
import '../../widgets/auto/plan_pricing_card.dart';

/// SCREEN 8: Plans & Billing. Applies the pricing psychology from
/// Section 4 directly in layout: Creator elevated + "MOST POPULAR",
/// full comparison table behind a disclosure, usage bar repeated here.
class PlansBillingScreen extends StatefulWidget {
  const PlansBillingScreen({super.key});

  @override
  State<PlansBillingScreen> createState() => _PlansBillingScreenState();
}

class _PlansBillingScreenState extends State<PlansBillingScreen> {
  bool _compareOpen = false;

  @override
  Widget build(BuildContext context) {
    final repo = context.read<AutoRepository>();
    final plans = AutoMockData.plans;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.cardPaddingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Plans & Billing', style: AppTextStyles.pageTitle),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.bgSurface,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('MINUTES USED THIS MONTH', style: AppTextStyles.dataLabel),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: repo.minutesUsed() / repo.minutesLimit(),
                  color: AppColors.cyan,
                  backgroundColor: AppColors.bgVoid,
                  minHeight: 6,
                ),
                const SizedBox(height: 8),
                Text('${repo.minutesUsed()} / ${repo.minutesLimit()} min', style: AppTextStyles.dataTag),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sectionGapSmall),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > AppSpacing.mobileBreakpoint;
              if (isWide) {
                return IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (final plan in plans)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: PlanPricingCard(plan: plan, onUpgrade: () {}),
                          ),
                        ),
                    ],
                  ),
                );
              }
              return Column(
                children: [
                  for (final plan in plans)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: PlanPricingCard(plan: plan, onUpgrade: () {}),
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: AppSpacing.sectionGapSmall),
          InkWell(
            onTap: () => setState(() => _compareOpen = !_compareOpen),
            child: Row(
              children: [
                Icon(_compareOpen ? Icons.expand_less : Icons.expand_more, color: AppColors.textSilver),
                const SizedBox(width: 8),
                Text('COMPARE ALL FEATURES', style: AppTextStyles.dataLabel),
              ],
            ),
          ),
          if (_compareOpen) ...[
            const SizedBox(height: 16),
            _comparisonTable(plans),
          ],
        ],
      ),
    );
  }

  Widget _comparisonTable(List<PlanModel> plans) {
    final rows = <List<String>>[
      ['Price', for (final p in plans) '\$${p.priceMonthly}/mo'],
      ['Source minutes / mo', for (final p in plans) '${p.sourceMinutes} min'],
      ['Clips per upload', for (final p in plans) p.clipsPerUpload == -1 ? 'Unlimited' : 'Up to ${p.clipsPerUpload}'],
      ['Auto captions', for (final p in plans) p.captionStyles],
      ['Color grading', for (final p in plans) p.colorGrading],
      ['Post copy', for (final p in plans) p.postCopy],
      ['Export', for (final p in plans) p.exportQuality],
      ['Seats', for (final p in plans) '${p.seats}'],
    ];
    return Table(
      border: TableBorder.all(color: AppColors.border1),
      children: [
        for (final row in rows)
          TableRow(
            children: [
              for (final cell in row) Padding(padding: const EdgeInsets.all(10), child: Text(cell, style: AppTextStyles.bodyS)),
            ],
          ),
      ],
    );
  }
}
