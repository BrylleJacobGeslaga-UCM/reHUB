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
      vsync: this, duration: const Duration(milliseconds: 1300));
  bool _done = false;
  Rect? _logoRect;
  double? _heroHeight;

  /// Roughly the size of the logo on the native splash screen.
  static const _splashLogoSize = 165.0;

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

  Widget _circle(double size) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: 0.07),
        ),
      );

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
                final v = _c.value;
                // 0 → 0.75: the green shrinks into the header shape.
                final t = Curves.easeInOutCubic.transform((v / 0.75).clamp(0.0, 1.0));
                final h = lerpDouble(size.height, _heroHeight ?? size.height, t)!;
                final start = Rect.fromCenter(
                  center: size.center(Offset.zero),
                  width: _splashLogoSize,
                  height: _splashLogoSize,
                );
                final logo = Rect.lerp(start, _logoRect ?? start, t)!;
                // 0.75 → 1: the overlay (now identical to the header, minus
                // the text) fades away, so only the title and subtitle
                // appear to fade in.
                final fade = v < 0.75 ? 1.0 : 1 - (v - 0.75) / 0.25;

                return Opacity(
                  opacity: fade.clamp(0.0, 1.0),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      height: h,
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(32 * (t * 4).clamp(0.0, 1.0))),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            const Positioned.fill(
                                child: ColoredBox(color: AppColors.primary)),
                            // Same soft circles as the header, so nothing
                            // pops in at the end.
                            Positioned(top: -70, right: -60, child: _circle(220)),
                            Positioned(top: 150, left: -40, child: _circle(120)),
                            Positioned.fromRect(
                              rect: logo,
                              child: SvgPicture.asset('assets/logo_white.svg'),
                            ),
                          ],
                        ),
                      ),
                    ),
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
