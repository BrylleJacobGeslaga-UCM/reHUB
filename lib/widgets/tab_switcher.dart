import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Like an IndexedStack (every tab keeps its scroll position and state),
/// but switching tabs plays a short slide: the new page fades in over the
/// old one, sliding in from the side you're moving towards.
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
    ..value = 1;
  late int _from = widget.index;

  @override
  void didUpdateWidget(TabSwitcher old) {
    super.didUpdateWidget(old);
    if (old.index == widget.index) return;
    _from = old.index;
    if (MediaQuery.of(context).disableAnimations) {
      _c.value = 1;
    } else {
      _c.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final to = widget.index;
    final dir = to > _from ? 1.0 : -1.0;
    // The new page fades in ON TOP of the old one (which stays solid
    // underneath), so the green headers never turn pale mid-switch.
    final inCurve = CurvedAnimation(parent: _c, curve: Curves.easeOutCubic);

    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        final animating = _c.isAnimating && _from != to;
        final slots = [
          for (var i = 0; i < widget.children.length; i++)
            _slot(
              i,
              visible: i == to || (animating && i == _from),
              opacity: animating && i == to ? inCurve.value : 1,
              dx: animating && i == to ? dir * 0.08 * (1 - inCurve.value) : 0,
            ),
        ];
        // Draw the incoming page last so it sits on top.
        final top = slots.removeAt(to);
        return ClipRect(
          child: Stack(fit: StackFit.expand, children: [...slots, top]),
        );
      },
    );
  }

  Widget _slot(int i,
      {required bool visible, required double opacity, required double dx}) {
    return KeyedSubtree(
      key: ValueKey(i), // keeps each tab's state when the order changes
      child: Offstage(
      offstage: !visible,
      child: TickerMode(
        enabled: visible,
        child: IgnorePointer(
          ignoring: i != widget.index,
          child: FractionalTranslation(
            translation: Offset(dx, 0),
            child: Opacity(
              opacity: opacity.clamp(0.0, 1.0),
              // Each page gets its own background so pages never show
              // through each other.
              child: ColoredBox(
                color: AppColors.bg,
                child: widget.children[i],
              ),
            ),
          ),
        ),
      ),
      ),
    );
  }
}
