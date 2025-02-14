import 'package:flutter/material.dart';

final class Example {
  final String title;
  final String description;
  final Widget Function(BuildContext) builder;

  Example({
    required this.title,
    required this.description,
    required this.builder,
  });
}

final class ExampleContent extends StatelessWidget {
  final Example example;

  const ExampleContent({super.key, required this.example});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          example.title,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            spacing: 8,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  Icon(
                    Icons.info_outlined,
                    color: theme.disabledColor,
                  ),
                  Expanded(
                    child: Text(
                      example.description,
                      style: TextStyle(color: theme.disabledColor),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(child: example.builder(context)),
            ],
          ),
        ),
      ),
    );
  }
}
