import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../models/usul_model.dart';

/// Usul vuruş kalıbını dairesel veya yatay olarak gösteren widget.
class UsulPatternDisplay extends StatelessWidget {
  final Usul usul;
  final int activeBeatIndex; // Şu anda çalmakta olan vuruşun indeksi (-1 = hiçbiri)

  const UsulPatternDisplay({
    super.key,
    required this.usul,
    required this.activeBeatIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        children: [
          // Vuruş dairelerini çiz
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 14,
            children: List.generate(usul.pattern.length, (index) {
              final beat = usul.pattern[index];
              final isActive = index == activeBeatIndex;
              final isDum = beat.type == "dum";
              final isTek = beat.type == "tek";
              final isRest = beat.type == "rest";

              final double size = isDum ? 42 : (isTek ? 34 : 28);

              Color bgColor;
              Color borderColor;
              if (isActive) {
                bgColor = isDum
                    ? AppColors.usulDum.withOpacity(0.3)
                    : isTek
                        ? AppColors.usulTek.withOpacity(0.3)
                        : AppColors.usulInactive;
                borderColor = isDum ? AppColors.usulDum : AppColors.usulTek;
              } else {
                bgColor = AppColors.usulInactive;
                borderColor = AppColors.borderLight;
              }

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 120),
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      color: bgColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: borderColor,
                        width: isActive ? 2.5 : 1.0,
                      ),
                      boxShadow: isActive
                          ? [
                              BoxShadow(
                                color: (isDum ? AppColors.usulDum : AppColors.usulTek)
                                    .withOpacity(0.25),
                                blurRadius: 12,
                                spreadRadius: 2,
                              )
                            ]
                          : [],
                    ),
                    child: Center(
                      child: isRest
                          ? Text(
                              "·",
                              style: TextStyle(
                                fontSize: 16,
                                color: isActive ? AppColors.primaryText : AppColors.tertiaryText,
                              ),
                            )
                          : Text(
                              isDum ? "D" : "T",
                              style: TextStyle(
                                fontSize: isDum ? 14 : 12,
                                fontWeight: FontWeight.w700,
                                color: isActive
                                    ? AppColors.primaryText
                                    : AppColors.secondaryText,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isRest ? "·" : (isDum ? "Düm" : "Tek"),
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                      color: isActive ? AppColors.primaryText : AppColors.tertiaryText,
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
