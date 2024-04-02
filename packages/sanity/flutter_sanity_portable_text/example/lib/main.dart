import 'package:flutter/material.dart';
import 'package:flutter_sanity_portable_text/flutter_sanity_portable_text.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              // Typically you would render this by querying Sanity and
              // fetching the data. Here we are hard-coding the model for brevity.
              // Use the sanity_client package to fetch data from Sanity.
              child: PortableText(
                blocks: [
                  TextBlockItem(
                    children: [
                      Span(
                        text: 'Sanity Portable Text',
                      ),
                    ],
                    style: 'h1',
                  ),

                  TextBlockItem(
                    children: [
                      Span(
                        text: 'Hello, ',
                      ),
                      Span(
                        text: 'World!',
                        marks: [
                          'strong',
                          'em',
                          'underline',
                        ],
                      ),
                    ],
                  ),

                  // Let's try a blockquote now
                  TextBlockItem(
                    children: [
                      Span(
                        text:
                            '"The best way to predict the future is to invent it."',
                      ),
                      Span(
                        text: '\n- Steve Jobs',
                      ),
                    ],
                    style: 'blockquote',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
