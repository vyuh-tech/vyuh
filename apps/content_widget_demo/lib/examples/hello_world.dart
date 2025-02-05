import 'package:vyuh_content_widget/vyuh_content_widget.dart';

import '../example.dart';

final helloWorld = Example(
  title: 'Hello World',
  description:
      'Renders a single document from CMS, using the default document layout',
  builder: (context) =>
      VyuhContentWidget.fromDocument(identifier: 'hello-world'),
);
