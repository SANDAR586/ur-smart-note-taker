import 'package:flutter/foundation.dart';

/// Lightweight note model created from GenUI intents.
@immutable
class Note {
  const Note({
    required this.id,
    required this.title,
    this.body,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String? body;
  final DateTime createdAt;
}
