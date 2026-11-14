import 'package:flutter/material.dart';

/// "Build itself in" animation for Home, played only right after signing in
/// (or continuing as a guest, or finishing onboarding), never on normal
/// tab switches.
class Entrance {
  Entrance._();
  static bool _pending = false;

  /// Call when the user has just signed in. The next Home screen plays it.
  static void arm() => _pending = true;

  /// True once (then resets), so only the first Home build animates.
  static bool take() {
    final v = _pending;
    _pending = false;
    return v;
  }
}

/// Fades and lifts [child] into place, [index] steps after the others.
class StaggerIn extends StatefulWidget {
  const StaggerIn({
    super.key,
    required this.index,
    required this.enabled,
    required this.child,
  });

  final int index;
  final bool enabled;
  final Widget child;

  /// Waits for the screen crossfade before the first piece arrives.
  static const _baseDelay = Duration(milliseconds: 380);
  static const _step = Duration(milliseconds: 70);

  @override
  State<StaggerIn> createState() => _StaggerInState();
}

class _StaggerInState extends State<StaggerIn>
    with SingleTickerProviderStateMixin {
  late final _c = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 420));
  late final _curve = CurvedAnimation(parent: _c, curve: Curves.easeOutCubic);

  @override
  void initState() {
    super.initState();
    if (!widget.enabled) {
      _c.value = 1;
      return;
    }
    Future.delayed(StaggerIn._baseDelay + StaggerIn._step * widget.index, () {
      if (mounted) _c.forward();
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _curve,
      child: SlideTransition(
        position: Tween(begin: const Offset(0, 0.15), end: Offset.zero)
            .animate(_curve),
        child: widget.child,
      ),
    );
  }
}
