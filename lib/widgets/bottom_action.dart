import 'package:flutter/material.dart';

/// Layout for screens with scrolling content and a button pinned at the
/// bottom (Greeting, Interests, Goals, Check-in...).
class BottomActionLayout extends StatelessWidget {
  const BottomActionLayout({
    super.key,
    required this.children,
    required this.action,
    this.footer,
  });

  /// Scrolling content (usually a header first, then the body).
  final List<Widget> children;

  /// The pinned bottom button.
  final Widget action;

  /// Optional small widget shown just above the button.
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: children,
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (footer != null) ...[footer!, const SizedBox(height: 12)],
                  action,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
