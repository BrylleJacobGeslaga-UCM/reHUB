import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_colors.dart';

/// Continues the native splash screen into the Sign In header:
/// the green background shrinks into the header while the logo glides from
/// the middle of the screen into its place. Plays once per app launch.
///
/// [heroKey] is the header, [logoKey] the logo inside it. The overlay starts
/// looking exactly like the splash (full green, centered logo), so the
/// hand-off is seamless.
class SplashIntro extends StatefulWidget {
  const SplashIntro({
    super.key,
    required this.heroKey,
    required this.logoKey,
    required this.child,
  });

  final GlobalKey heroKey;
  final GlobalKey logoKey;

  /// The screen underneath. It receives the progress (0→1) so it can fade
  /// its own content in.
  final Widget Function(Animation<double> progress) child;

  /// Only the very first Sign In screen after launch plays the intro.
  static bool _played = false;

  /// Called when the app opens on another screen (already signed in), so
  /// signing out later doesn't replay the intro.
  static void skip() => _played = true;

  @override
  State<SplashIntro> createState() => _SplashIntroState();
}

class _SplashIntroState extends State<SplashIntro>
    with SingleTickerProviderStateMixin {
  late final _c = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1150));
  bool _done = false;
  Rect? _logoRect;
  double? _heroHeight;

  /// Roughly the size of the logo on the native splash screen.
  static const _splashLogoSize = 98.0;

  @override
  void initState() {
    super.initState();
    if (SplashIntro._played) {
      _c.value = 1;
      _done = true;
      return;
    }
    SplashIntro._played = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      // Respect "remove animations" in the phone's accessibility settings.
      if (MediaQuery.of(context).disableAnimations) {
        _c.value = 1;
        setState(() => _done = true);
        return;
      }
      final logo = widget.logoKey.currentContext?.findRenderObject();
      final hero = widget.heroKey.currentContext?.findRenderObject();
      if (logo is RenderBox && hero is RenderBox) {
        _logoRect = logo.localToGlobal(Offset.zero) & logo.size;
        _heroHeight = hero.size.height;
      }
      setState(() {});
      await Future.delayed(const Duration(milliseconds: 150));
      if (!mounted) return;
      await _c.forward();
      if (mounted) setState(() => _done = true);
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final content = widget.child(_c);
    if (_done) return content;

    return Stack(
      children: [
        content,
        Positioned.fill(
          child: IgnorePointer(
            child: AnimatedBuilder(
              animation: _c,
              builder: (context, _) {
                final size = MediaQuery.sizeOf(context);
                final t = Curves.easeInOutCubic.transform(_c.value);
                final h = lerpDouble(size.height, _heroHeight ?? size.height, t)!;
                final start = Rect.fromCenter(
                  center: size.center(Offset.zero),
                  width: _splashLogoSize,
                  height: _splashLogoSize,
                );
                final logo = Rect.lerp(start, _logoRect ?? start, t)!;
                // Fade the overlay out at the very end to reveal the real
                // header (title, subtitle) underneath.
                final fade = _c.value < 0.82 ? 1.0 : 1 - (_c.value - 0.82) / 0.18;

                return Opacity(
                  opacity: fade.clamp(0.0, 1.0),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        right: 0,
                        top: 0,
                        height: h,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(32 * t)),
                          ),
                        ),
                      ),
                      Positioned.fromRect(
                        rect: logo,
                        child: SvgPicture.asset('assets/logo_white.svg'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
