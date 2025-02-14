import 'package:flutter/cupertino.dart';
import 'package:vyuh_content_widget/vyuh_content_widget.dart';

import '../example.dart';

final class HelloWorldExample extends ExampleWidget {
  const HelloWorldExample({super.key})
      : super(
          title: 'Hello World',
          description:
              'Renders a single document from CMS, using the default document layout',
        );

  @override
  Widget build(BuildContext context) =>
      VyuhContentWidget.fromDocument(identifier: 'hello-world');
}
