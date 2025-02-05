import 'package:flutter/material.dart';
import 'package:vyuh_content_widget/vyuh_content_widget.dart';

import '../example.dart';

final customWidget = Example(
  title: 'Custom Builder',
  description: 'Uses a custom builder to render content from CMS',
  builder: (context) => VyuhContentWidget.fromDocument(
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
              if (doc.item != null)
                VyuhContentBinding.content.buildContent(context, doc.item!),
            ]),
          ),
        );
      }),
);
