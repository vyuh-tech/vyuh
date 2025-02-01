import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final void Function() onTap;

  const MyWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: const FlutterLogo(size: 56.0),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}
