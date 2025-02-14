import 'package:flutter/material.dart';
import 'package:vyuh_content_widget/vyuh_content_widget.dart';

import '../example.dart';

final class CustomWidgetExample extends ExampleWidget {
  const CustomWidgetExample({super.key})
      : super(
          title: 'Custom Builder',
          description: 'Uses a custom builder to render content from CMS',
        );

  @override
  Widget build(BuildContext context) {
    return VyuhContentWidget.fromDocument(
        identifier: 'hello-world',
        builder: (context, doc) {
          return Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: [
                Text(doc.title ?? '---',
                    style: Theme.of(context).textTheme.titleMedium),
                Text(doc.description ?? '---'),
                if (doc.items != null && doc.items!.isNotEmpty)
                  VyuhContentBinding.content
                      .buildContent(context, doc.items!.first),
              ]),
            ),
          );
        });
  }
}
