import 'package:content_widget_demo/example.dart';
import 'package:feature_conference/feature_conference.dart' as conf;
import 'package:flutter/material.dart';
import 'package:vyuh_content_widget/vyuh_content_widget.dart';
import 'package:vyuh_feature_system/vyuh_feature_system.dart' as system;

final class ConferencesExample extends ExampleWidget {
  const ConferencesExample({super.key})
      : super(
          title: 'Conferences',
          description:
              'Shows a list of conferences from the CMS, using the listBuilder',
        );

  @override
  Widget build(BuildContext context) {
    return VyuhContentWidget(
      query: '''
*[_type == "conf.conference"]{
  ...,
  "slug": slug.current,
}
  ''',
      fromJson: conf.Conference.fromJson,
      listBuilder: (context, conferences) => ListView.builder(
        itemCount: conferences.length,
        itemBuilder: (context, index) => ListTile(
          leading: system.ContentImage(
            ref: conferences[index].logo,
            width: 48,
            height: 48,
          ),
          title: Text(conferences[index].title),
          subtitle: Text(conferences[index].slug),
        ),
      ),
    );
  }
}
