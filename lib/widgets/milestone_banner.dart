import 'dart:math';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text.dart';

/// Slides a celebration banner down from the top with a burst of confetti,
/// then slides it away by itself. Tapping it calls [onTap].
void showMilestoneBanner(
  BuildContext context, {
  required String title,
  VoidCallback? onTap,
  VoidCallback? onDone,
}) {
  final overlay = Overlay.of(context, rootOverlay: true);
  late final OverlayEntry entry;
  entry = OverlayEntry(
    builder: (_) => _MilestoneBanner(
      title: title,
      onTap: onTap,
      onDone: () {
        entry.remove();
        onDone?.call();
      },
    ),
  );
  overlay.insert(entry);
}

class _MilestoneBanner extends StatefulWidget {
  const _MilestoneBanner({
    required this.title,
    required this.onDone,
    this.onTap,
  });

  final String title;
  final VoidCallback onDone;
  final VoidCallback? onTap;

  @override
  State<_MilestoneBanner> createState() => _MilestoneBannerState();
}

class _MilestoneBannerState extends State<_MilestoneBanner>
    with TickerProviderStateMixin {
  late final _slide = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 450));
  late final _confetti = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1800));
  final _pieces = List.generate(36, (i) => _Piece.random(Random(i * 7 + 3)));
  bool _closing = false;

  @override
  void initState() {
    super.initState();
    _run();
  }

  Future<void> _run() async {
    _confetti.forward();
    await _slide.forward();
    await Future.delayed(const Duration(milliseconds: 3600));
    await _close();
  }

  Future<void> _close() async {
    if (_closing || !mounted) return;
    _closing = true;
    await _slide.reverse();
    widget.onDone();
  }

  @override
  void dispose() {
    _slide.dispose();
    _confetti.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top + 12;
    final slide = CurvedAnimation(
        parent: _slide, curve: Curves.easeOutBack, reverseCurve: Curves.easeIn);

    return Stack(
      children: [
        // Confetti (doesn't block taps on the app underneath).
        Positioned.fill(
          child: IgnorePointer(
            child: AnimatedBuilder(
              animation: _confetti,
              builder: (context, _) => CustomPaint(
                painter: _ConfettiPainter(
                  pieces: _pieces,
                  t: _confetti.value,
                  origin: Offset(MediaQuery.sizeOf(context).width / 2, top + 40),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: top,
          left: 16,
          right: 16,
          child: SlideTransition(
            position: Tween(begin: const Offset(0, -1.6), end: Offset.zero)
                .animate(slide),
            child: Material(
              color: Colors.transparent,
              child: GestureDetector(
                onTap: () {
                  widget.onTap?.call();
                  _close();
                },
                onVerticalDragEnd: (_) => _close(),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(14, 12, 16, 12),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.accent, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.22),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: const BoxDecoration(
                          color: AppColors.accentTint,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.emoji_events_rounded,
                            color: AppColors.accent, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Milestone reached!',
                                style: AppText.label.copyWith(
                                    color: AppColors.accent)),
                            Text(widget.title,
                                style: AppText.bodyStrong
                                    .copyWith(color: AppColors.text)),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded,
                          color: AppColors.textMuted),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Piece {
  _Piece(this.angle, this.speed, this.size, this.color, this.spin);

  factory _Piece.random(Random r) => _Piece(
        -pi / 2 + (r.nextDouble() - 0.5) * pi * 1.1, // mostly upward fan
        260 + r.nextDouble() * 260,
        5 + r.nextDouble() * 5,
        const [
          AppColors.accent,
          AppColors.leaf,
          AppColors.primarySoft,
          Colors.white,
          AppColors.primary,
        ][r.nextInt(5)],
        (r.nextDouble() - 0.5) * 12,
      );

  final double angle;
  final double speed;
  final double size;
  final Color color;
  final double spin;
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter({required this.pieces, required this.t, required this.origin});

  final List<_Piece> pieces;
  final double t;
  final Offset origin;

  @override
  void paint(Canvas canvas, Size size) {
    if (t <= 0 || t >= 1) return;
    const gravity = 520.0;
    final secs = t * 1.8;
    final fade = t < 0.7 ? 1.0 : (1 - (t - 0.7) / 0.3);
    for (final p in pieces) {
      final dx = cos(p.angle) * p.speed * secs;
      final dy = sin(p.angle) * p.speed * secs + 0.5 * gravity * secs * secs;
      final paint = Paint()..color = p.color.withValues(alpha: fade);
      canvas.save();
      canvas.translate(origin.dx + dx, origin.dy + dy);
      canvas.rotate(p.spin * secs);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset.zero, width: p.size, height: p.size * 0.6),
          const Radius.circular(1.5),
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => old.t != t;
}
