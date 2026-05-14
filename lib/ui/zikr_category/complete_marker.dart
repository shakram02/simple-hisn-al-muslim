import 'package:azkar/constants.dart';
import 'package:azkar/l10n/app_localizations.dart';
import 'package:azkar/ui/components/app_colors.dart';
import 'package:flutter/material.dart';

class ZikrItemCompleteMarker extends StatefulWidget {
  const ZikrItemCompleteMarker({super.key});

  @override
  State<ZikrItemCompleteMarker> createState() => _ZikrItemCompleteMarkerState();
}

class _ZikrItemCompleteMarkerState extends State<ZikrItemCompleteMarker>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = AppColors.of(context).secondary;
    final doneLabel = AppLocalizations.of(context).done;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ScaleTransition(
          scale: CurvedAnimation(
            parent: _controller,
            curve: Curves.easeOutBack,
          ),
          child: FadeTransition(
            opacity: _controller,
            child: Icon(Icons.check_circle, size: 20, color: color),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          doneLabel,
          style: TextStyle(
            fontSize: AppTheme.noteFontSize,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
