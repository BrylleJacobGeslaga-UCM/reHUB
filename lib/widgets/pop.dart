import 'package:flutter/material.dart';

/// Gives [child] a quick bouncy "pop" whenever [active] turns on
/// (a mood being picked, a reaction being tapped).
class Pop extends StatefulWidget {
  const Pop({super.key, required this.active, required this.child});

  final bool active;
  final Widget child;

  @override
  State<Pop> createState() => _PopState();
}

class _PopState extends State<Pop> with SingleTickerProviderStateMixin {
  late final _c = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 520));

  // Shrink a little, overshoot, settle back.
  late final _scale = TweenSequence<double>([
    TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.75)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 18),
    TweenSequenceItem(
        tween: Tween(begin: 0.75, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 82),
  ]).animate(_c);

  @override
  void didUpdateWidget(Pop old) {
    super.didUpdateWidget(old);
    if (widget.active && !old.active) {
      if (MediaQuery.of(context).disableAnimations) return;
      _c.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      ScaleTransition(scale: _scale, child: widget.child);
}
