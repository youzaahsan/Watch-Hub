// lib/widgets/gold_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/constants/app_colors.dart';

class GoldButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool outline;
  final bool isLoading;
  final double? width;
  final IconData? icon;
  final EdgeInsetsGeometry? padding;

  const GoldButton({
    super.key,
    required this.label,
    this.onPressed,
    this.outline = false,
    this.isLoading = false,
    this.width,
    this.icon,
    this.padding,
  });

  @override
  State<GoldButton> createState() => _GoldButtonState();
}

class _GoldButtonState extends State<GoldButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: widget.width,
        decoration: BoxDecoration(
          gradient: widget.outline
              ? null
              : LinearGradient(
                  colors: _isHovered
                      ? [AppColors.goldLight, AppColors.gold]
                      : [AppColors.goldDark, AppColors.gold],
                ),
          borderRadius: BorderRadius.circular(8),
          border: widget.outline
              ? Border.all(color: AppColors.gold, width: 1.5)
              : null,
          boxShadow: _isHovered && !widget.outline
              ? [
                  BoxShadow(
                    color: AppColors.gold.withOpacity(0.35),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: widget.isLoading ? null : widget.onPressed,
            child: Padding(
              padding:
                  widget.padding ??
                  const EdgeInsets.symmetric(horizontal: 28, vertical: 15),
              child: widget.isLoading
                  ? const Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.bg,
                        ),
                      ),
                    )
                  : FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (widget.icon != null) ...[
                            Icon(
                              widget.icon,
                              color: widget.outline
                                  ? AppColors.gold
                                  : AppColors.bg,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                          ],
                          Text(
                            widget.label.toUpperCase(),
                            style: TextStyle(
                              color: widget.outline
                                  ? AppColors.gold
                                  : AppColors.bg,
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ),
      ),
    ).animate().scale(begin: const Offset(1, 1), end: const Offset(1, 1));
  }
}
