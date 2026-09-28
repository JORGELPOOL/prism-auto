import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Dual-handle trim range slider for the Clip Editor (Screen 4).
class TrimSlider extends StatelessWidget {
  final int totalSeconds;
  final int startSeconds;
  final int endSeconds;
  final ValueChanged<RangeValues> onChanged;

  const TrimSlider({
    super.key,
    required this.totalSeconds,
    required this.startSeconds,
    required this.endSeconds,
    required this.onChanged,
  });

  String _fmt(int s) => '${s ~/ 60}:${(s % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final maxVal = totalSeconds > 0 ? totalSeconds.toDouble() : 1.0;
    final start = startSeconds.toDouble().clamp(0.0, maxVal).toDouble();
    final end = endSeconds.toDouble().clamp(0.0, maxVal).toDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: AppColors.cyan,
            inactiveTrackColor: AppColors.border2,
            thumbColor: AppColors.cyan,
            overlayColor: AppColors.cyan.withOpacity(0.15),
            rangeThumbShape: const RoundRangeSliderThumbShape(enabledThumbRadius: 8),
            trackHeight: 3,
          ),
          child: RangeSlider(
            min: 0,
            max: maxVal,
            values: RangeValues(start, end),
            onChanged: onChanged,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(_fmt(startSeconds), style: AppTextStyles.dataTag),
            Text(_fmt(endSeconds), style: AppTextStyles.dataTag),
          ],
        ),
      ],
    );
  }
}
