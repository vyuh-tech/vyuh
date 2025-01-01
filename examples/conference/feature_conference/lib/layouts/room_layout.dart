import 'package:flutter/material.dart';

import '../content/room.dart';

class RoomLayout extends StatelessWidget {
  final Room room;

  const RoomLayout({
    super.key,
    required this.room,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            title: Text(room.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (room.description != null) ...[
                  Text(room.description!),
                  const SizedBox(height: 8),
                ],
                Wrap(
                  spacing: 8,
                  children: [
                    Chip(
                      avatar: Icon(
                        Icons.people,
                        color: Colors.white,
                      ),
                      label: Text(
                        '${room.capacity}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: Colors.blue.shade600,
                    ),
                    Chip(
                      avatar: Icon(
                        Icons.stairs,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Floor ${room.floor}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: Colors.teal.shade600,
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (room.facilities != null && room.facilities!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Facilities',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: room.facilities!
                        .map((f) => Chip(
                              label: Text(
                                f.displayName,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              backgroundColor: Colors.grey.shade600,
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
