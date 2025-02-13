import 'package:favourite_place/model/place.dart';
import 'package:flutter/material.dart';

class PlaceDetailScreen extends StatelessWidget {
  final Place place;
  const PlaceDetailScreen({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          place.title,
          style: theme.textTheme.bodyLarge!
              .copyWith(color: theme.colorScheme.onSurface),
        ),
      ),
    );
  }
}
