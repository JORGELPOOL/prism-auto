import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../repositories/auto_repository.dart';

class ProgressStepList extends StatelessWidget {
  final List<ProcessingStepName> completedSteps;
  final ProcessingStepName currentStep;

  const ProgressStepList({super.key, required this.completedSteps, required this.currentStep});

  String _label(ProcessingStepName step) {
    switch (step) {
      case ProcessingStepName.transcribing:
        return 'TRANSCRIBING AUDIO';
      case ProcessingStepName.findingMoments:
        return 'FINDING KEY MOMENTS';
      case ProcessingStepName.cuttingClips:
        return 'CUTTING CLIPS';
      case ProcessingStepName.writingPosts:
        return 'WRITING CAPTIONS & POSTS';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final step in ProcessingStepName.values)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Icon(
                  completedSteps.contains(step) ? Icons.check_circle : Icons.radio_button_unchecked,
                  size: 16,
                  color: completedSteps.contains(step) ? AppColors.mint : AppColors.textDim,
                ),
                const SizedBox(width: 12),
                Text(
                  _label(step),
                  style: AppTextStyles.dataLabel.copyWith(
                    color: completedSteps.contains(step) ? AppColors.textMist : AppColors.textDim,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
