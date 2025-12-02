import 'package:flutter/material.dart';

class IconBadge extends StatelessWidget {
  final Widget child;

  const IconBadge({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(backgroundColor: Theme.of(context).colorScheme.primary, child: child);
  }
}
