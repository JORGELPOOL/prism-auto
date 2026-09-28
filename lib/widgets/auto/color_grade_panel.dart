import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Color grading panel for the Clip Editor (Screen 4) — 6 preset
/// before/after thumbnails plus a collapsed-by-default "Advanced"
/// disclosure with manual sliders.
class ColorGradePanel extends StatefulWidget {
  final int selectedPreset;
  final ValueChanged<int> onPresetSelected;

  const ColorGradePanel({super.key, required this.selectedPreset, required this.onPresetSelected});

  @override
  State<ColorGradePanel> createState() => _ColorGradePanelState();
}

class _ColorGradePanelState extends State<ColorGradePanel> {
  bool _advancedOpen = false;
  double _exposure = 0, _contrast = 0, _saturation = 0, _warmth = 0;

  static const _presetNames = ['None', 'Vivid', 'Warm', 'Cool', 'Cinematic', 'Mono'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (int i = 0; i < _presetNames.length; i++)
              GestureDetector(
                onTap: () => widget.onPresetSelected(i),
                child: Container(
                  width: 72,
                  height: 96,
                  decoration: BoxDecoration(
                    color: AppColors.bgSurface,
                    border: Border.all(
                      color: widget.selectedPreset == i ? AppColors.cyan : AppColors.border1,
                      width: widget.selectedPreset == i ? 2 : 1,
                    ),
                  ),
                  child: Center(
                    child: Text(_presetNames[i], style: AppTextStyles.bodyS, textAlign: TextAlign.center),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 20),
        InkWell(
          onTap: () => setState(() => _advancedOpen = !_advancedOpen),
          child: Row(
            children: [
              Icon(_advancedOpen ? Icons.expand_less : Icons.expand_more, size: 18, color: AppColors.textSilver),
              const SizedBox(width: 6),
              Text('ADVANCED', style: AppTextStyles.dataLabel),
            ],
          ),
        ),
        if (_advancedOpen) ...[
          const SizedBox(height: 12),
          _slider('Exposure', _exposure, (v) => setState(() => _exposure = v)),
          _slider('Contrast', _contrast, (v) => setState(() => _contrast = v)),
          _slider('Saturation', _saturation, (v) => setState(() => _saturation = v)),
          _slider('Warmth', _warmth, (v) => setState(() => _warmth = v)),
        ],
      ],
    );
  }

  Widget _slider(String label, double value, ValueChanged<double> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 80, child: Text(label, style: AppTextStyles.bodyS)),
          Expanded(
            child: SliderTheme(
              data: SliderThemeData(
                activeTrackColor: AppColors.cyan,
                inactiveTrackColor: AppColors.border2,
                thumbColor: AppColors.cyan,
                trackHeight: 2,
              ),
              child: Slider(min: -1, max: 1, value: value, onChanged: onChanged),
            ),
          ),
        ],
      ),
    );
  }
}
