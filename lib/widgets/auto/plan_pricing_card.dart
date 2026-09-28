import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/plan_model.dart';
import '../common/prism_button.dart';
import '../common/prism_card.dart';

/// Pricing tier card for Plans & Billing (Screen 8). The Creator tier is
/// visually elevated (cyan border + "MOST POPULAR" tag) per the pricing
/// psychology in Section 4 — the single highest-leverage layout choice
/// on this screen.
class PlanPricingCard extends StatelessWidget {
  final PlanModel plan;
  final VoidCallback onUpgrade;

  const PlanPricingCard({super.key, required this.plan, required this.onUpgrade});

  @override
  Widget build(BuildContext context) {
    return PrismCard(
      borderColor: plan.isPopular ? AppColors.cyan : AppColors.border1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (plan.isPopular)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                color: AppColors.bgSurface,
                child: Text('MOST POPULAR', style: AppTextStyles.dataLabel.copyWith(color: AppColors.cyan)),
              ),
            ),
          Text(plan.name, style: AppTextStyles.sectionHead),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('\$${plan.priceMonthly}', style: AppTextStyles.statMedium),
              const SizedBox(width: 4),
              Padding(padding: const EdgeInsets.only(bottom: 4), child: Text('/mo', style: AppTextStyles.bodyS)),
            ],
          ),
          const SizedBox(height: 20),
          _feature('${plan.sourceMinutes} min / mo source'),
          _feature(plan.clipsPerUpload == -1 ? 'Unlimited clips per upload' : 'Up to ${plan.clipsPerUpload} clips per upload'),
          _feature('Captions: ${plan.captionStyles}'),
          _feature('Color grading: ${plan.colorGrading}'),
          _feature('Post copy: ${plan.postCopy}'),
          _feature('Export: ${plan.exportQuality}'),
          _feature('${plan.seats} seat${plan.seats > 1 ? 's' : ''}'),
          const SizedBox(height: 20),
          plan.isCurrent
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PrismButton(label: 'Manage', onPressed: onUpgrade, variant: PrismButtonVariant.ghost, fullWidth: true),
                    const SizedBox(height: 8),
                    Text('YOUR CURRENT PLAN', style: AppTextStyles.dataLabel.copyWith(color: AppColors.mint)),
                  ],
                )
              : PrismButton(label: 'Upgrade', onPressed: onUpgrade, fullWidth: true),
        ],
      ),
    );
  }

  Widget _feature(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.check, size: 14, color: AppColors.mint),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: AppTextStyles.bodyS)),
        ],
      ),
    );
  }
}
