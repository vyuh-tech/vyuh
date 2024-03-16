import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:mobx/mobx.dart';
import 'package:vyuh_core/vyuh_core.dart';

final featureCounter = FeatureDescriptor(
  name: 'counter',
  title: 'The classic Flutter counter',
  description: 'A simple counter that tracks the number of button presses',
  icon: Icons.add_circle_outlined,
  routes: () async {
    return [
      GoRoute(
          path: '/counter',
          builder: (context, state) {
            return const _Counter();
          }),
    ];
  },
);

class _Counter extends StatefulWidget {
  const _Counter();

  @override
  State<_Counter> createState() => _CounterState();
}

class _CounterState extends State<_Counter> {
  final counter = 0.obs();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Counter')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Number of Button presses',
            textAlign: TextAlign.center,
          ),
          Observer(
              builder: (_) => Text(
                    '${counter.value}',
                    style: Theme.of(context)
                        .textTheme
                        .displayLarge
                        ?.apply(fontFamily: 'Courier New', fontWeightDelta: 2),
                    textAlign: TextAlign.center,
                  )),
        ],
      ),
      floatingActionButton: IconButton.filled(
        icon: const Icon(Icons.add),
        onPressed: () => runInAction(() => counter.value++),
      ),
    );
  }
}
