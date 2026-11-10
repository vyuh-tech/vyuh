import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vyuh_core/vyuh_core.dart';

void main() {
  testWidgets('retains only the active and two most recently used branches', (
    tester,
  ) async {
    final mounted = <int>[];
    final disposed = <int>[];
    final children = [
      for (var i = 0; i < 4; i++)
        _Branch(key: ValueKey(i), id: i, mounted: mounted, disposed: disposed),
    ];
    Future<void> select(int index, {int limit = 3}) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: NavigationBranchContainer(
            currentIndex: index,
            maxRetainedBranches: limit,
            children: children,
          ),
        ),
      );
    }

    await select(0);
    expect(mounted, [0]);
    await select(1);
    await select(0);
    await select(2);
    expect(mounted, [0, 1, 2]);
    expect(disposed, isEmpty);
    await select(3);
    expect(disposed, [1]);
    expect(find.text('branch 3'), findsOneWidget);
    expect(find.text('branch 0'), findsNothing);
    await select(1);
    expect(mounted, [0, 1, 2, 3, 1]);
    expect(disposed, [1, 0]);
    await select(1, limit: 1);
    expect(disposed.toSet(), {0, 1, 2, 3});
  });
}

class _Branch extends StatefulWidget {
  const _Branch({
    super.key,
    required this.id,
    required this.mounted,
    required this.disposed,
  });
  final int id;
  final List<int> mounted;
  final List<int> disposed;
  @override
  State<_Branch> createState() => _BranchState();
}

class _BranchState extends State<_Branch> {
  @override
  void initState() {
    super.initState();
    widget.mounted.add(widget.id);
  }

  @override
  void dispose() {
    widget.disposed.add(widget.id);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Text('branch ${widget.id}');
}
