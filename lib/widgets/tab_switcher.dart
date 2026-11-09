import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Like an IndexedStack (every tab keeps its scroll position and state),
/// but switching tabs plays a short slide: the new page fades in over the
/// old one, sliding in from the side you're moving towards.
///
/// Uses FadeTransition/SlideTransition so the pages themselves are never
/// rebuilt during the animation (only repainted), which keeps it smooth.
class TabSwitcher extends StatefulWidget {
  const TabSwitcher({super.key, required this.index, required this.children});

  final int index;
  final List<Widget> children;

  @override
  State<TabSwitcher> createState() => _TabSwitcherState();
}

class _TabSwitcherState extends State<TabSwitcher>
    with SingleTickerProviderStateMixin {
  late final _c = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 260))
    ..value = 1
    ..addStatusListener((s) {
      // Once finished, hide the old page again.
      if (s == AnimationStatus.completed && mounted) setState(() {});
    });
  late final _curve = CurvedAnimation(parent: _c, curve: Curves.easeOutCubic);
  late int _from = widget.index;
  late Animation<Offset> _slideIn = const AlwaysStoppedAnimation(Offset.zero);

  @override
  void didUpdateWidget(TabSwitcher old) {
    super.didUpdateWidget(old);
    if (old.index == widget.index) return;
    _from = old.index;
    if (MediaQuery.of(context).disableAnimations) {
      _c.value = 1;
      return;
    }
    final dir = widget.index > _from ? 1.0 : -1.0;
    _slideIn = Tween(begin: Offset(dir * 0.08, 0), end: Offset.zero)
        .animate(_curve);
    _c.forward(from: 0);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final to = widget.index;
    final animating = _c.isAnimating && _from != to;
    const still = AlwaysStoppedAnimation(1.0);

    final slots = [
      for (var i = 0; i < widget.children.length; i++)
        KeyedSubtree(
          key: ValueKey(i), // keeps each tab's state when the order changes
          child: Offstage(
            offstage: !(i == to || (animating && i == _from)),
            child: TickerMode(
              enabled: i == to || (animating && i == _from),
              child: IgnorePointer(
                ignoring: i != to,
                child: SlideTransition(
                  position: i == to
                      ? _slideIn
                      : const AlwaysStoppedAnimation(Offset.zero),
                  child: FadeTransition(
                    opacity: i == to ? _curve : still,
                    child: RepaintBoundary(
                      child: ColoredBox(
                        color: AppColors.bg,
                        child: widget.children[i],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
    ];
    // Draw the incoming page last so it sits on top of the old one.
    final top = slots.removeAt(to);
    return ClipRect(
      child: Stack(fit: StackFit.expand, children: [...slots, top]),
    );
  }
}
