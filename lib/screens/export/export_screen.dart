import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/common/prism_button.dart';

/// SCREEN 6: Export. Fast, unambiguous resolution choices with plain
/// labels (not jargon), a plan-locked option shown rather than hidden, and
/// a caption-format toggle.
class ExportScreen extends StatefulWidget {
  const ExportScreen({super.key});

  @override
  State<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends State<ExportScreen> {
  int _resolution = 1; // 1080p recommended, default
  bool _burnedIn = true;
  bool _exporting = false;
  bool _done = false;

  static const _resolutions = [
    {'label': '720p — quick preview', 'locked': false},
    {'label': '1080p — recommended', 'locked': false},
    {'label': '4K — best quality', 'locked': true},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(backgroundColor: AppColors.bgPrimary, elevation: 0),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Export', style: AppTextStyles.pageTitle),
                const SizedBox(height: 24),
                for (int i = 0; i < _resolutions.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      onTap: (_resolutions[i]['locked'] as bool) ? null : () => setState(() => _resolution = i),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: AppColors.bgVoid,
                          border: Border.all(
                            color: _resolution == i ? AppColors.cyan : AppColors.border1,
                            width: _resolution == i ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_resolutions[i]['label'] as String, style: AppTextStyles.bodyM.copyWith(color: AppColors.textWhite)),
                            if (_resolutions[i]['locked'] as bool)
                              Row(
                                children: [
                                  const Icon(Icons.lock_outline, size: 14, color: AppColors.textDim),
                                  const SizedBox(width: 6),
                                  Text('UPGRADE TO UNLOCK', style: AppTextStyles.dataLabel),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 24),
                Text('CAPTION FORMAT', style: AppTextStyles.dataLabel),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: PrismButton(
                        label: 'Burned-in',
                        onPressed: () => setState(() => _burnedIn = true),
                        variant: _burnedIn ? PrismButtonVariant.primary : PrismButtonVariant.ghost,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: PrismButton(
                        label: 'Clip + .srt',
                        onPressed: () => setState(() => _burnedIn = false),
                        variant: !_burnedIn ? PrismButtonVariant.primary : PrismButtonVariant.ghost,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                if (_exporting) ...[
                  const LinearProgressIndicator(color: AppColors.cyan, backgroundColor: AppColors.bgSurface),
                  const SizedBox(height: 16),
                ],
                if (_done)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Export ready.', style: AppTextStyles.bodyM.copyWith(color: AppColors.mint)),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          PrismButton(label: 'Download', onPressed: () {}),
                          const SizedBox(width: 12),
                          PrismButton(
                            label: 'Back to Gallery',
                            onPressed: () => Navigator.of(context).pop(),
                            variant: PrismButtonVariant.ghost,
                          ),
                        ],
                      ),
                    ],
                  )
                else
                  PrismButton(
                    label: 'Export',
                    fullWidth: true,
                    loading: _exporting,
                    onPressed: () async {
                      setState(() => _exporting = true);
                      await Future.delayed(const Duration(seconds: 2));
                      if (mounted) {
                        setState(() {
                          _exporting = false;
                          _done = true;
                        });
                      }
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
