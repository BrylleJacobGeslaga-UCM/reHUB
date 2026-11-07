import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../widgets/empty_state.dart';
import '../../widgets/screen_header.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ScreenHeader(title: 'Your feed', subtitle: 'Updates from your hubs'),
          EmptyState(
            icon: Icons.article_outlined,
            title: 'No updates yet',
            message: 'Once you join hubs, posts from their members '
                'will show up here.',
          ),
        ],
      ),
    );
  }
}
