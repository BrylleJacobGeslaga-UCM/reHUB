import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../widgets/empty_state.dart';
import '../../widgets/screen_header.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ScreenHeader(title: 'Messages', subtitle: 'Connect with your hubs'),
          EmptyState(
            icon: Icons.chat_bubble_outline_rounded,
            title: 'No conversations yet',
            message: 'Each hub you join gets a group chat. '
                'They’ll be listed here.',
          ),
        ],
      ),
    );
  }
}
